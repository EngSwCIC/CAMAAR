const pool = require('../dbConnection')
async function createRelationParticipanteTurma({idParticipante, idTurma}){
	const connect = await pool.getConnection()
	try{
		const res = await connect.query('insert into tb_turmas_participantes values(default, ?, ?)', [idParticipante, idTurma])
		connect.end()
		return res 
	} catch(e) {
		console.error('ERROR AO INSERIR RELACAO PARTICIPANTE-TURMA:', e)
		if(connect){
			connect.end()
		}
	}
}

module.exports = createRelationParticipanteTurma
