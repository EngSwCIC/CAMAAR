const pool = require('../dbConnection')
async function createTurma({codigo, codigo_materia, semestre, horario}){
	const connect = await pool.getConnection()
	try{
		let res = await connect.query('select id from turmas where codigo = ?', [codigo])

		if(!res.length){
			res = connect.query('insert into turmas values(default, ?, ?, ?, ?)', [codigo_materia, codigo, semestre, horario])
		} else {
			res.insertId = res[0].id
		}
		connect.end()
		return res 
	} catch(e) {
		console.error('ERROR AO INSERIR TURMA:', e)
		if(connect){
			connect.end()
		}
	}
}

module.exports = createTurma
