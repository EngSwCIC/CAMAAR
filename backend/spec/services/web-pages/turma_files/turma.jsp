

var Mensagem = function() {

	var painel, updater, dest, turma, bloqueio;

	var listener1 = function() { 
		if (dest){ document.getElementById('destinatarios').value = dest; }
		updater.un('update', listener1); 
	};

	var listener2 = function() { 
		updater.un('update', listener2); 
		painel.hide(); 
		//painel = null; 
		updater = null; 
		if (dest != undefined) {	Ext.MessageBox.alert('Status da Mensagem', 'Mensagem enviada com sucesso.'); }	
 	}

	var listener3 = function() {
	
		// Adiciona o nome da turma quando um discente envia mensagem pra um professor.
		var assunto = null;
		if ( turma != null )
			assunto = Ext.get('assunto-facade').dom.value + " - " + turma;
		else
			assunto = Ext.get('assunto-facade').dom.value;
				
		Ext.get('assunto-mensagem').dom.value=escape(assunto);
		Ext.get('corpoMensagem').dom.value=escape(Ext.get('corpo-facade').dom.value);
		Ext.get('statusEnvio').dom.style.visibility='visible';
		updater.un('beforeupdate', listener3);
	}

	var listener5 = function() {
		updater.un('update', listener5); 
		painel.hide(); 
		//painel = null; 
		updater = null;	
		if (bloqueio == 'true') {	Ext.MessageBox.alert('Status da Mensagem', 'Caixa postal temporariamente bloqueada.'); }	
		else
		Ext.MessageBox.alert('Status da Mensagem', 'Falhou. A mensagem não foi enviada.');
	}

	return {
	
		show: function(tipo, _dest, _turma, _bloqueio) {
		
			if (!Ext.get('mensagem')) {
				var dh = Ext.DomHelper;
				var elem = Ext.get(Ext.DomQuery.select('html')[0]);
				dh.append(elem, {
					id: 'mensagem',
					tag: 'div',
					html: '<div class="x-window-header"></div><div class="x-window-body"></div>'
				});
			}
				
			if (!painel) {
				painel = new Ext.Window({
					applyTo: 'mensagem',
					autoCreate:true,
					width: 700,
					height: 260,
					indicatorText: '<div class="loading-indicator">Enviando...</div>',
					closeAction: 'hide',
					buttons: [
					{ text: 'Enviar', handler: function() { 
							if (Ext.get('assunto-facade').dom.value == '' || Ext.get('corpo-facade').dom.value == '') {
								alert('Digite um assunto e um texto para a mensagem.');
								return;
							}
							if (Ext.get('destinatarios').dom.value == '') {
								Ext.MessageBox.alert('Status da Mensagem', 'Digite pelo menos um destinatário.');
								return;
							}
					
							var mgr = painel.getUpdater();
							mgr.on('beforeupdate', listener3);
							mgr.on('failure', listener5);
							mgr.on('update', listener2);
							mgr.formUpdate('formMensagem');
						} 
					}, { text: 'Cancelar', handler: function() { painel.hide();  } }
					]
				});
			}
			dest = _dest;
			turma = _turma;
			bloqueio = _bloqueio;
			if(tipo==undefined){ tipo = 1; }

			//painel.html = '';
			painel.setHeight(262);
			painel.syncSize();
			
			updater = painel.getUpdater();
			//updater.on('failure', function() { alert("Falha na abertura do formulário. Contate o administrador do sistema!"); });
			updater.on('failure', listener5 );
			updater.on('update', listener1 );
			updater.update({ url: "/sigaa/mensagem/enviaMensagem.do?acao=5&mensagem.tipo=" + tipo });
		
			if (tipo == 3) {
				painel.setTitle("Enviar Chamado");
			} else {
				painel.setTitle("Enviar Mensagem");
			}
			
			painel.show();
			painel.center();
		}
		
	}

}();

var PainelModulos = function(){
	var painel,link;
	var tries=0;
	
	return{
		init:function(){
			link=Ext.get('show-modulos-ava');
			if(link!=undefined){
				link.on('click',this.show,this,true);
			} else if(tries<10){
				setTimeout('PainelModulos.init()',50);
				tries++;
			}
		},
		
		show:function(){
			if(!painel){
				painel = new Ext.Window({
					title:'Módulos do SIGAA',
					modal:false,
					width:760,
					height:382,
					resizable:false,
					closeAction: 'hide'
				});
			}
			painel.show();
			var mgr = painel.getUpdater();
			mgr.update('/sigaa/verMenuPrincipal.do?dialog=true');
		}
	};
}();

var PainelAjuda = function(){
	var painel,link;
	
	return{	
		init:function(){
			link=Ext.get('show-ajuda-ava');
			if(link!=undefined)
				link.on('click',this.show,this,true);
		},
		
		show:function(){
			if(!painel){
				painel=new Ext.Window({
					autoCreate:true,
					title:'Ajuda do SIGAA',
					modal:false,
					animateTarget:'show-ajuda',
					width:640,
					height:400,
					shadow:true,
					resizable:false
				});
			}
			painel.show();
			var mgr=painel.getUpdater();
			mgr.update('/sigaa'+document.getElementById('linkAjuda').value);
		}
	};
}();

function validarNomePasta() {
	if(document.getElementById('formPasta:nomePasta').value.trim() == '') {
		alert("Digite o nome da pasta.");
		return false;
	}
	return true;
}

/** Verificação para solicitar confirmação do usuário caso sejam identificados caracteres passíveis de remoçao */
function verificaNomeArquivo() {
	var regex = /[^a-zA-Z0-9_.\/\\:]+/g;
	var nomeArquivo = document.getElementById('form:arquivo').value;
	if(nomeArquivo.match(regex)!=undefined) {
		return confirm("Prezado usuário, o nome do arquivo contém caracteres especiais que serão removidos pelo sistema. Deseja continuar?");
	}
	return true;
}

var keys = new Object();
	
keys.KEY_RETURN = 13;
keys.KEY_BACKSPACE = 8;
keys.KEY_TAB = 9;
keys.KEY_LEFT = 37;
keys.KEY_RIGHT = 39;
keys.KEY_DELETE = 46;
function mask(field,_mask,val){
	var i,mki;var aux="";
	if(val.length>=field.maxLength){return val.substr(0,field.maxLength);}
	else {
		for(i=mki=0;i<val.length;i++,mki++){
			if(_mask.charAt(mki)==''||_mask.charAt(mki)=='#'||_mask.charAt(i)==val.charAt(i)){aux+=val.charAt(i);}
			else{aux+=_mask.charAt(mki)+val.charAt(i);mki++;}
		}
	}
	return aux;
}
function formataData(field,event){
	if (field.maxLength != 10) field.maxLength = 10;
	var _mask='##/##/####';
	var key='';var aux='';
	var len=0;var i=0;var strCheck='0123456789';
	var rcode=event.keyCode?event.keyCode:event.which?event.which:event.charCode;
	if((rcode==keys.KEY_RETURN)||(rcode==keys.KEY_BACKSPACE)||(rcode==keys.KEY_TAB)||(rcode==keys.KEY_LEFT)||(rcode==keys.KEY_RIGHT)||(rcode==keys.KEY_DELETE)){return true;}
	aux=field.value+key;
	aux=mask(field,_mask,aux);
	field.value=aux;
	return false;
}

function datePicker(id) {
	dateField = new Ext.form.DateField({
    	allowBlank:false,
        format:'d/m/Y',
        applyTo: id
	});
}
function formatarInteiro(campo, event) {campo.value = campo.value.replace(/\D+/, '');}
