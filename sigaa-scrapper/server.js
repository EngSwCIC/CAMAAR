const express = require('express')
const puppeteer = require('puppeteer')
require('dotenv').config()
const {login, getClassesIds, clickMateria, getMateriaInfo, goBack, getMembersInfo} = require('./index.js')

// SERVER CONFIGS
const PORT = process.env.PORT
const app = express() 
app.use(express.json())

// ROUTES
app.post("/turmas", async (req, res) => {
    const browser = await puppeteer.launch({ headless: true })
	const page = await browser.newPage()
	await login(page, process.env.USUARIO, process.env.PASSWORD)
    const selectors = await getClassesIds(page)
    let infos = []
    console.log("Getting classes' info")
    for(selector of selectors){
        await clickMateria(selector, page)
        const info = await getMateriaInfo(page)
        infos.push(info)
        await goBack(page)
    }
    console.log("Sending classes' info")
    res.send(infos)
})

app.post("/participantes", async (req, res) => {
    const browser = await puppeteer.launch({ headless: true })
	const page = await browser.newPage()
	await login(page, process.env.USUARIO, process.env.PASSWORD)
    const selectors = await getClassesIds(page)
    let infos = []
    console.log("Getting members' info")
    for(selector of selectors){
        await clickMateria(selector, page)
        let clasS = await getMateriaInfo(page)
        let condicional = false
        req.body.classes.forEach ((elemento) => {
            if (elemento.code === clasS.code && elemento.classCode === clasS.class.classCode) {
                condicional = true;
            }
        })
        if (condicional){
            let info = await getMembersInfo(page)
            info = {code: clasS.code,classCode: clasS.class.classCode,...info}
            infos.push(info)
            await goBack(page)
        }
        await goBack(page)
    }
    console.log("Sending members' info")
    res.send(infos)
})

app.listen(PORT, () => {console.log(`Server is running on ${PORT}`)})