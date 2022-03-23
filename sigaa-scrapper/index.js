const puppeteer = require('puppeteer')
const createMateria = require('./helpers/createMateria')
const createParticipante = require('./helpers/createParticipante')
const createTurma = require('./helpers/createTurma')
const createRelationParticipanteTurma = require('./helpers/createRelationParticipanteTurma')

require('dotenv').config();

async function login(page){
	const PASSWORD = process.env.PASSWORD
	const USER = process.env.USERNAME
	await page.goto('https://sig.unb.br/sigaa/ava/index.jsf')
	await page.$eval('#username', (el, USER) => {el.value = USER}, USER)
	await page.$eval('#password', (el, PASSWORD) => {el.value = PASSWORD}, PASSWORD)
	await page.click('.btn-login')
	// await page.waitForSelector('input[name="j_id_jsp_933481798_1:j_id_jsp_933481798_3"]');
	// await page.click('input[name="j_id_jsp_933481798_1:j_id_jsp_933481798_3"]')
	await page.waitForSelector('#turmas-portal');
}

function parserDicentes (data) {
	data = data.split('\t\t\t')
	data = data.map(duplas=>{
		return duplas.split('\t')
	})
	data = data.flat(Infinity)
	data = data.filter(el => el !== '\n')
	data.pop()
	data = data.map(aluno => {
		aluno = aluno.trim()
		aluno = aluno.split('\n')
		aluno[0] = aluno[0].trim()
		return {
			nome: aluno[0],
			curso: aluno[1].replace('Curso: ', ''),
			matricula: aluno[2].replace('Matrícula: ', ''),
			usuario: aluno[3].replace('Usuário: ', ''),
			formacao: 'graduando',
			ocupacao: 'dicente',
			email: aluno[4].split(' ')[1],
		}
	})
	return data
}

function parserDocente (data) {
	data = data.replaceAll('\t', '')
	data = data.trim()
	data = data.split('\n')
	return {
		nome: data[0],
		departamento: data[1].replace('Departamento: ', ''),
		formacao: data[2].replace('Formação: ', ''),
		usuario: data[3].replace('Usuário: ', ''),
		email: data[4].split(' ')[1],
		ocupacao: 'docente'
	}
}

async function scrapMateria(selector, page){
	const urlInicial = await page.url()
	await page.click(`#${selector} a`)
	await page.waitForSelector('.rich-panelbar-content')
	await page.evaluate(()=>{
		const nodes = Array.from(document.querySelector('.rich-panelbar-content').childNodes)
		nodes.filter(hyperlink => hyperlink.innerText === 'Participantes')[0].click()
	})
	await page.waitForSelector('.participantes')
	// get Participantes
  await page.screenshot('print.png')
	const resultado = await page.evaluate(()=>{
    const participantes = document.querySelectorAll('.participantes')
		return {dicente: participantes[1].innerText, docente: participantes[0].innerText}
	})
	resultado.dicente = parserDicentes(resultado.dicente)
	resultado.docente = parserDocente(resultado.docente)
	// get Turma info
	const info = await page.evaluate(()=>{
    let codigoMateria = document.querySelector('#linkCodigoTurma').innerText
		codigoMateria = codigoMateria.trim().split(' ')[0]
		const nomeMateria = document.querySelector('#linkNomeTurma').innerText
		const infoTurma = document.querySelector('#linkPeriodoTurma').innerText
		return {codigoMateria, nomeMateria, infoTurma}
	})
  
	//parser infoTurma
	let turma = info.infoTurma.replaceAll(/\(|\)/g,'')
	turma = turma.split(' ')
	turma = turma.filter(char => char!=='-')
	info.infoTurma = {codigo: turma[0], semestre: turma[1], horario: turma[2]}
	resultado.info = info
	await page.goto(urlInicial)
  console.log('teste', resultado)
	return resultado
}

(async () => {
	const browser = await puppeteer.launch({ headless: true })
	const page = await browser.newPage()
	await login(page)

	const selectors = await page.evaluate(()=> Array.from(document.querySelectorAll("#turmas-portal .descricao form")).map(el=>el.id))
	let contador = 1
	const max = selectors.length
	for(selector of selectors){
		console.log(`Realizando Scrapping: ${contador}/${max}`)
		contador++
		const res = await scrapMateria(selector, page)
		const materiaCadastrada = await createMateria({
			codigo: res.info.codigoMateria,
			nome: res.info.nomeMateria
		})
		const turmaCadastrada = await createTurma({
			codigo: res.info.infoTurma.codigo,
			codigo_materia: materiaCadastrada.insertId,
			semestre: res.info.infoTurma.semestre,
			horario: res.info.infoTurma.horario
		})
		for(aluno of res.dicente){
			const alunoCadastrado = await createParticipante({
				nome:aluno.nome,
				matricula: aluno.matricula,
				usuario: aluno.usuario,
				email: aluno.email,
				formacao: aluno.formacao,
				ocupacao: aluno.ocupacao
			})
			await createRelationParticipanteTurma({
				idParticipante: alunoCadastrado.insertId,
				idTurma: turmaCadastrada.insertId
			})
		}
		const professorCadastrado = await createParticipante({
			nome: res.docente.nome,
			departamento: res.docente.departamento,
			formacao: res.docente.formacao,
			usuario: res.docente.usuario,
			matricula: res.docente.usuario,
			email: res.docente.email,
			ocupacao: res.docente.ocupacao
		})
		await createRelationParticipanteTurma({
			idParticipante: professorCadastrado.insertId,
			idTurma: turmaCadastrada.insertId
		})
	}
	await browser.close()
	console.log('Scrapping realizado com sucesso')
	process.exit()
})();