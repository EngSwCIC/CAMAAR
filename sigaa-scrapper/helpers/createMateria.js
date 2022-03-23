const pool = require('../dbConnection')
async function createMateria({codigo, nome}){
	const connect = await pool.getConnection()
	try{
		let res = await connect.query('select id from materias where codigo = ?', [codigo])
		if(!res.length){
			res = await connect.query('insert into materias values(default, ?, ?)', [codigo, nome])
		} else {
			res.insertId = res[0].id
		}
		connect.end()
		return res 
	} catch(e) {
		console.error('ERROR AO INSERIR MATERIA:', e)
		if(connect){
			connect.end()
		}
	}
}

module.exports = createMateria
