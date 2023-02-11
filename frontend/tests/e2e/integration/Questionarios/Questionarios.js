import { Given, When, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache} = cy;

const surveys = {survey_list:[
    {"id":"teste",
      "name":"Questionário Teste",
      "description":"this is a test survey",
      "expiration_date":"2028-06-21T15:15:50.000Z",
      "semester":"2022/2",
      "role":{"name":"docente",
        "description":"docente"},
      "survey_questions":[
        {"question":"Sugestões ou comentários adicionais para esta disciplina.",
          "question_number":1,
          "optional":true,
          "question_type":{"name":"discursive"},
          "question_options":[],
          "likert_scale_questions":[]},
        {"question":"Uma pergunta múltipla escolha.",
          "question_number":2,
          "optional":false,
          "question_type":{"name":"multiple_choice"},
          "question_options":[
            {"content":"option 1"},
            {"content":"option 2"},
            {"content":"option 3"},
            {"content":"option 4"},
            {"content":"option 5"}],
          "likert_scale_questions":[]},
        {"question":"Sobre o ensino da disciplina/turma, julgue cada item e marque a coluna correspondente ao valor de seu julgamento.",
          "question_number":3,
          "optional":false,
          "question_type":{"name":"likert_scale"},
          "question_options":[],
          "likert_scale_questions":[
            {"question":"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.",
              "question_number":1,
              "scale_points":5},
            {"question":"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).",
              "question_number":2,
              "scale_points":5},
            {"question":"O professor utilizou preferencialmente recursos didáticos síncronos.",
              "question_number":3,
              "scale_points":5},
            {"question":"O professor utilizou preferencialmente recursos didáticos assíncronos.",
              "question_number":4,
              "scale_points":5},
            {"question":"As estratégias didáticas da disciplina foram efetivas para aprendizagem.",
              "question_number":5,
              "scale_points":5},
            {"question":"A bibliografia básica da disciplina estava disponível para acesso online.",
              "question_number":6,
              "scale_points":5},
            {"question":"Tive curiosidade ou interesse na disciplina.",
              "question_number":7,
              "scale_points":5},
            {"question":"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.",
              "question_number":8,
              "scale_points":5},
            {"question":"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.",
              "question_number":9,
              "scale_points":5},
            {"question":"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.",
              "question_number":10,
              "scale_points":5},
            {"question":"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).",
              "question_number":11,
              "scale_points":5},
            {"question":"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.",
              "question_number":12,
              "scale_points":5}]}]}
  ]}

const survey = [
  {"id":1,
    "code":"TA",
    "semester":"2021.2",
    "time":"35T45",
    "subject_id":1,
    "created_at":"2023-01-19T18:43:43.097Z",
    "updated_at":"2023-01-19T18:43:43.097Z",
    "subject":
      {"id":1,
        "code":"CIC0097",
        "name":"BANCO DE DADOS (teste)",
        "created_at":"2023-01-19T18:43:42.950Z",
        "updated_at":"2023-01-19T18:43:42.950Z"}}]


Before({ tags: '@MockQuestionarios'},() => {
  // @interceptingRequest
  cy.intercept('GET', '/api/surveys/open', surveys.survey_list).as('getRequest')
  cy.intercept('GET', '/api/surveys/teste', surveys.survey_list[0])
  cy.intercept('GET', '/api/members/1/cclasses', survey).as('teste');
  cy.intercept('POST', '/api/survey_answers').as('postRequest')

})

Before(() => {
  clearLocalStorageCache()
  visit('/')
  the('Email').type('Testador')
  the('Senha').type('testa')
  the('Login', 'button').click()
  visit('/#/surveys')
})

Given(`que estou na tela de selecao dos questionarios`, () => {
  visit('/#/surveys')
  }
)

Given(/que estou no questionario "(\w+)"/, (string) =>{
  visit("/#/surveys/" + string)
})

And(/clico no botão "(\w+)"/, (string) => {
  the(string, 'button').click()
})

When(`nao preencho o textarea obrigatorio da questão {}`, (numero) => {
  cy.get(`#questao-${numero} textarea`).clear()
})

Before({ tags: '@interceptingRequest'},() => {
  cy.intercept('POST', '/api/survey_answers').as('postRequest')
});

When(`clicar no questionario "{}"`, (string) =>{
  cy.get(`#questionario-${string} > .q-card > .q-card__actions > .q-btn`).click()
})

When(`preencho o textarea da questão {} com {}`, (numero, string) => {
  cy.get(`#questao-${numero} textarea`).type(string)
});

When (`preencho o radio button da questão {} com os labels: {}`, (numero ,labels) => {
  labels.split(/,\s?/).forEach(label =>
    cy.get(`#questao-${numero} .q-radio__label label`).contains(label).click()
  )
});

When(`clico no botão {}`, (button_content) => {
  cy.get('.q-btn').contains(button_content).click()
  cy.wait('@postRequest').then(interception => {
    cy.wrap(interception.request.body.answers_attributes).as('questoes_enviadas')
  })
});

When(`preencho todas as opções do likert da questão {} com "{}"`,(numero,value) => {
  cy.get(`#questao-${numero} input[value="${value}"]`).each((radio)=>{
    radio.click()
  })
});

Then(`a questão {} deveria enviar o likert com as opções com "{}"`, (num_questao, conteudo_testado) => {
  let indice = parseInt(num_questao) - 1
  cy.get('@questoes_enviadas').then(questoes => {
    questoes[indice].likert_answers_attributes.forEach(conteudo => expect(conteudo.content).to.equal(conteudo_testado))
  });
});

Then(`devo ver um mensagem de {}`, (string) => {
  get('.q-notification__message').should('contain', string)
});


Then(`a questão {} deveria enviar {}`, (num_questao, conteudo_testado) => {
  let indice = parseInt(num_questao) - 1
  cy.get('@questoes_enviadas').then(questao => {
    expect(questao[indice].content.toString()).to.equal(conteudo_testado)
  });

});

Then(`a questão {} deveria enviar nada`, (num_questao) => {
  let indice = parseInt(num_questao) - 1
  cy.get('@questoes_enviadas').then(questao => {
    expect(questao[indice].content).to.equal(null)
  });

});

Then(`devo ver questionarios`, () => {
  cy.get(".q-card").its('length').should('be.gt', 0)
})

Then(`eu devo estar na tela "{}"`, (path)=> {
  cy.url().should('include', path)
})
