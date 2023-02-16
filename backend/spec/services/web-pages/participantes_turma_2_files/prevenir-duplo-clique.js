var aguardandoProcessamento = false;

function prevenirDuploClique () {
	if (!aguardandoProcessamento){
		aguardandoProcessamento = true;
		return true;
	}
	return false;
}