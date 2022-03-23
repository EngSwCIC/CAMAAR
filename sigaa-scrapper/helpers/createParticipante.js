const pool = require('../dbConnection')
async function createParticipante({nome, matricula, usuario, email, formacao, ocupacao}){
	const connect = await pool.getConnection()
	try{
		let res = await connect.query('select id from participantes where matricula = ?', [matricula])
		if(!res.length){
			res = await connect.query('insert into participantes values(default, ?, ?, ?, ?, ?, ?)', [nome, matricula, usuario, email, formacao, ocupacao])
		} else {
			res.insertId = res[0].id
		}
		connect.end()
		return res
	} catch(e) {
		console.error('ERROR AO INSERIR PARTICIPANTE:', e)
		if(connect){
			connect.end()
		}
	}
}

module.exports = createParticipante
