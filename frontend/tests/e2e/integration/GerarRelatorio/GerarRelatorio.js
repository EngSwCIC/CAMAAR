import { Given, When, Then, And } from "cypress-cucumber-preprocessor/steps";

const response = {
	"rows": [
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		},
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		},
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		},
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		},
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		},
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		}
	],
	"columns": [
		"Sugestões ou comentários adicionais para esta disciplina.",
		"Uma pergunta múltipla escolha.",
		"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.",
		"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).",
		"O professor utilizou preferencialmente recursos didáticos síncronos.",
		"O professor utilizou preferencialmente recursos didáticos assíncronos.",
		"As estratégias didáticas da disciplina foram efetivas para aprendizagem.",
		"A bibliografia básica da disciplina estava disponível para acesso online.",
		"Tive curiosidade ou interesse na disciplina.",
		"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.",
		"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.",
		"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.",
		"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).",
		"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina."
	],
	"average_rows": [
		{
			"Sugestões ou comentários adicionais para esta disciplina.": "Adorei essa disciplina!!!",
			"Uma pergunta múltipla escolha.": "3",
			"O professor apresentou o plano de ensino de maneira clara e coerente com a ementa.": 3,
			"O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas).": 2,
			"O professor utilizou preferencialmente recursos didáticos síncronos.": 3,
			"O professor utilizou preferencialmente recursos didáticos assíncronos.": 4,
			"As estratégias didáticas da disciplina foram efetivas para aprendizagem.": 4,
			"A bibliografia básica da disciplina estava disponível para acesso online.": 4,
			"Tive curiosidade ou interesse na disciplina.": 4,
			"As estratégias adotadas foram efetivas para o meu engajamento na disciplina.": 5,
			"O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina.": 2,
			"O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.).": 3,
			"Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina.": 3
		}
	],
	"charts": [
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				2,
				0,
				3,
				1,
				0
			],
			"question": "O professor apresentou o plano de ensino de maneira clara e coerente com a ementa."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				1,
				2,
				2,
				1,
				0
			],
			"question": "O professor foi efetivo na comunicação com os estudantes (clareza nos objetivos e estratégias didáticas)."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				1,
				3,
				2,
				0
			],
			"question": "O professor utilizou preferencialmente recursos didáticos síncronos."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				1,
				2,
				2,
				1
			],
			"question": "O professor utilizou preferencialmente recursos didáticos assíncronos."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				1,
				2,
				0,
				2,
				1
			],
			"question": "As estratégias didáticas da disciplina foram efetivas para aprendizagem."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				1,
				1,
				0,
				2,
				2
			],
			"question": "A bibliografia básica da disciplina estava disponível para acesso online."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				1,
				2,
				0,
				2,
				1
			],
			"question": "Tive curiosidade ou interesse na disciplina."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				3,
				1,
				1,
				1
			],
			"question": "As estratégias adotadas foram efetivas para o meu engajamento na disciplina."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				0,
				1,
				1,
				4
			],
			"question": "As estratégias adotadas foram efetivas para o meu engajamento na disciplina."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				1,
				2,
				2,
				1,
				0
			],
			"question": "O apoio pedagógico do professor e/ou monitor(es) foi efetivo para a disciplina."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				1,
				4,
				1,
				0
			],
			"question": "O professor utilizou recursos diversificados de mídias digitais (áudio, vídeo, podcast, etc.)."
		},
		{
			"labels": [
				1,
				2,
				3,
				4,
				5
			],
			"data": [
				0,
				2,
				3,
				0,
				1
			],
			"question": "Os materiais disponibilizados fizeram uso de linguagem clara e coerente com os objetivos da disciplina."
		}
	]
}

Given("que eu esteja logado como aluno no CAMAAR", () => {
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("eu estou na página de relatório do aluno", () => {
  cy.visit("/#/student-subjects");
})

When("eu clico na disciplina 'CIC0097'", () => {
  cy.contains('CIC0097').click()
})

And('eu clico na disciplina "Turma A"', () => {
    cy.contains('Turma A (2021.2) — A Definir — 35T45').click()
})

Then("Então deve ser exibido na tela o relatório e os gráficos da turma selecionada'", () => {
  cy.intercept('GET', '/cclasses/1/answers', {
    statusCode: 200,
    body: response,
  }).as('getClassReport')
  cy.wait('@getClassReport')

  cy.get('#q-app > div:nth-child(2) > div > div.q-table__middle.scroll > table > tbody').should('have.length.equal', 5)
  cy.get('canva').should('exist')
})