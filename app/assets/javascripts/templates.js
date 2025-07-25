// Sistema de Perguntas para Templates
window.TemplatesManager = {
  perguntaCount: 0,
  
  init: function() {
    console.log('Inicializando TemplatesManager...');
    this.setupEventListeners();
    this.addInitialPergunta();
  },
  
  setupEventListeners: function() {
    const addBtn = document.getElementById('add-pergunta');
    if (addBtn) {
      // Remove listeners anteriores
      addBtn.replaceWith(addBtn.cloneNode(true));
      const newBtn = document.getElementById('add-pergunta');
      
      newBtn.addEventListener('click', (e) => {
        e.preventDefault();
        this.addPergunta();
      });
    }
  },
  
  addPergunta: function() {
    console.log('Adicionando nova pergunta...');
    this.perguntaCount++;
    
    const container = document.getElementById('perguntas-container');
    const template = document.getElementById('pergunta-template');
    
    if (!container || !template) {
      console.error('Elementos não encontrados!');
      return;
    }
    
    const clone = template.content.cloneNode(true);
    const perguntaItem = clone.querySelector('.pergunta-item');
    
    // Configurar campos
    this.setupPerguntaFields(clone, this.perguntaCount);
    
    container.appendChild(clone);
    
    // Configurar eventos
    this.setupPerguntaEvents(container.lastElementChild, this.perguntaCount);
    
    console.log(`Pergunta ${this.perguntaCount} adicionada!`);
  },
  
  setupPerguntaFields: function(clone, index) {
    clone.querySelector('.pergunta-number').textContent = index;
    clone.querySelector('.pergunta-texto').name = `perguntas[${index}][texto]`;
    clone.querySelector('.pergunta-tipo').name = `perguntas[${index}][tipo]`;
    clone.querySelector('.pergunta-obrigatoria').name = `perguntas[${index}][obrigatoria]`;
  },
  
  setupPerguntaEvents: function(perguntaItem, index) {
    // Botão remover
    const removeBtn = perguntaItem.querySelector('.remove-pergunta');
    removeBtn.addEventListener('click', (e) => {
      e.preventDefault();
      perguntaItem.remove();
      this.updateNumbers();
    });
    
    // Mudança de tipo
    const tipoSelect = perguntaItem.querySelector('.pergunta-tipo');
    const opcoesContainer = perguntaItem.querySelector('.opcoes-container');
    
    tipoSelect.addEventListener('change', () => {
      if (tipoSelect.value === 'multipla_escolha') {
        opcoesContainer.style.display = 'block';
        if (perguntaItem.querySelectorAll('.opcao-item').length === 0) {
          this.addOpcao(perguntaItem, index);
          this.addOpcao(perguntaItem, index);
        }
      } else {
        opcoesContainer.style.display = 'none';
      }
    });
    
    // Botão adicionar opção
    const addOpcaoBtn = perguntaItem.querySelector('.add-opcao');
    addOpcaoBtn.addEventListener('click', (e) => {
      e.preventDefault();
      this.addOpcao(perguntaItem, index);
    });
  },
  
  addOpcao: function(perguntaItem, perguntaIndex) {
    const opcoesList = perguntaItem.querySelector('.opcoes-list');
    const template = document.getElementById('opcao-template');
    
    const clone = template.content.cloneNode(true);
    const opcaoIndex = perguntaItem.querySelectorAll('.opcao-item').length + 1;
    
    clone.querySelector('.opcao-texto').name = `perguntas[${perguntaIndex}][opcoes][${opcaoIndex}]`;
    
    opcoesList.appendChild(clone);
    
    // Evento remover opção
    const opcaoItem = opcoesList.lastElementChild;
    const removeBtn = opcaoItem.querySelector('.remove-opcao');
    removeBtn.addEventListener('click', (e) => {
      e.preventDefault();
      opcaoItem.remove();
    });
  },
  
  updateNumbers: function() {
    const perguntas = document.querySelectorAll('.pergunta-item');
    perguntas.forEach((pergunta, index) => {
      pergunta.querySelector('.pergunta-number').textContent = index + 1;
    });
  },
  
  addInitialPergunta: function() {
    // Só adiciona se não existir nenhuma pergunta
    const container = document.getElementById('perguntas-container');
    if (container && container.children.length === 0) {
      setTimeout(() => this.addPergunta(), 100);
    }
  }
};

// Inicializar quando a página carregar
document.addEventListener('DOMContentLoaded', () => {
  TemplatesManager.init();
});

// Reinicializar após navegação Turbo
document.addEventListener('turbo:load', () => {
  TemplatesManager.init();
});

// Fallback
window.addEventListener('load', () => {
  TemplatesManager.init();
});
