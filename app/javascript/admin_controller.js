function ligarMenuAdmin() {
  const menuItems = document.querySelectorAll('.nav-item')
  const btnExp = document.querySelector('#btn-exp')
  const menuSide = document.querySelector('.navbar')
  const mainSide = document.querySelector('.dashboard-content')


  // MANTÉM O ITEM ATIVO 
  const urlAtual = window.location.pathname
  menuItems.forEach((item) => {
    const link = item.querySelector('a')
    if (link) {
      const href = link.getAttribute('href');
      if (urlAtual === href || (href !== '/' && urlAtual.includes(href))) {
        item.classList.add('ativo')
      } else if (href === '#gerenciamento' && window.location.hash === '#gerenciamento') {
        item.classList.add('ativo')
      } else {
        item.classList.remove('ativo')
      }
    }
  })

  // --- AJUSTE: LEMBRAR SE O MENU ESTAVA EXPANDIDO ---
  if (menuSide && localStorage.getItem('menuExpandido') === 'true') {
    menuSide.classList.add('expandir')
    mainSide.classList.add('expandir')
  }

  // Lógica original do clique nos itens
  function selectLink() {
    menuItems.forEach((item) => item.classList.remove('ativo'))
    this.classList.add('ativo')
  }

  menuItems.forEach((item) => {
    item.removeEventListener('click', selectLink)
    item.addEventListener('click', selectLink)
  })

  // Lógica original do botão de expandir (com o salvamento da memória)
  if (btnExp && menuSide && mainSide) {
    function toggleMenu(e) {
      e.preventDefault()
      menuSide.classList.toggle('expandir')
      mainSide.classList.toggle('expandir')
      
      // Salva no navegador se o menu está aberto (true) ou fechado (false)
      const estaExpandido = menuSide.classList.contains('expandir')
      const mainExpandido = mainSide.classList.contains('expandir')
      localStorage.setItem('menuExpandido', estaExpandido)
      localStorage.setItem('menuExpandido', mainExpandido)
    }
    btnExp.removeEventListener('click', toggleMenu)
    btnExp.addEventListener('click', toggleMenu)
  }
}

// Garante o funcionamento com as trocas de página do Turbo
document.addEventListener('turbo:load', ligarMenuAdmin)
ligarMenuAdmin()