async function login(page, USER, PASSWORD){
	console.log("Executing login")

	// LOGIN SELECTORS
	const usernameSelector = 'input[name="user.login"]'
	const passwordSelector = 'input[name="user.senha"]'
	const buttonSelector = 'input[type="submit"]'

	await page.goto('https://sig.unb.br/sigaa/verTelaLogin.do')
	await page.waitForSelector(usernameSelector);
	await page.waitForSelector(passwordSelector);
	await page.waitForSelector(buttonSelector);
	await page.$eval(usernameSelector, (el, USER) => {el.value = USER}, USER)
	await page.$eval(passwordSelector, (el, PASSWORD) => {el.value = PASSWORD}, PASSWORD)
	await page.click(buttonSelector)
}
async function clickEleicao(page){
	const eleicaoSelector = '#j_id_jsp_933481798_1 > div > input[type=submit]'
	await page.waitForSelector(eleicaoSelector);
	await page.click(`${eleicaoSelector}`)
}

async function getClassesIds(page){
	// CLASS SELECTOR
	const classesSelector = '#turmas-portal .descricao form'
	await page.waitForSelector(classesSelector)
	const selectors = await page.evaluate((classesSelector) => {return Array.from(document.querySelectorAll(classesSelector)).map(el=>el.id)},classesSelector)
    return selectors
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
	data = removeTab(data)
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

async function goBack(page){
	await page.goBack()
}

async function clickMateria(materiaId, page){
	await page.click(`#${materiaId} a`)
}

async function clickParticipantes(page){
	const handler = await page.$x("//div[contains(text(), 'Participantes')]")
	await handler[0].click()
}

function removeParanthesis (elem){
	return elem.replaceAll(/\(|\)/g,'')
}

function removeTab (elem){
	return elem.replaceAll('\t', '')
}

function removeTabs (elem, num){
	let tabs = ""
	for(let i = 0; i < num; i++){
		tabs += "\t"
	}
	return elem.replaceAll(tabs, '')
}

function removeDashes (elem){
	return elem.replaceAll(/\-/g,'')
}

async function getMateriaInfo(page){
	// Wait for page to load
	await page.waitForSelector('#nomeTurma')

	// Get info elements
	const info = await page.evaluate(()=> Array.from(document.querySelectorAll('#nomeTurma p')).map(elem => elem.innerText))

	// Remove () and -
	let data = info.map(elem => removeDashes(removeParanthesis(elem)))

	// Parsing each field
	data[0] = data[0].slice(0, -2)
	const localTime = data[2].split(' ')
	const classCode = localTime[1]
	const semester = localTime[2]
	const time = localTime.slice(3).join(' ').slice(1)

	return {code: data[0], name: data[1], class: {classCode, semester, time}}
}

async function getMembersInfo(page){
	// Wait for page to load
	await page.waitForSelector('.rich-panelbar-content')
	await clickParticipantes(page)

	// Get participantes
  await page.screenshot({path:"teste.png"})
	await page.waitForSelector('.participantes')
	const participantes = await page.evaluate(()=>{
    	const discentesDocentes = document.querySelectorAll('.participantes')
 	 	return {dicente: discentesDocentes[1].innerText, docente: discentesDocentes[0].innerText}
 	})

	// Parsing members
	participantes.dicente = parserDicentes(participantes.dicente)
 	participantes.docente = parserDocente(participantes.docente)

	return participantes
}

module.exports = {login, clickEleicao, getClassesIds, clickMateria, getMateriaInfo, goBack, getMembersInfo}