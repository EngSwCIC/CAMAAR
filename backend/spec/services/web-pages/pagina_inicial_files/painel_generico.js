/**
 * Edson Anibal (ambar@info.ufrn.br)
 * Thiago Marques (thiagomarques@info.ufrn.br)
 * 
 * Painel gen?rico que mostra as views por ajax.
 * 
 * O painel deve ser chamado da seguinte forma na JSP:
 * var PainelNomeDoPainel = (function() {
 *	 return {
 *       show : function(parametro1 , parametro2){ //id 
 *       	PainelDetalhar.show(
 *      			'/url/da/jsp'+'?ajaxRequest=true&p1='+parametro1+'&p2='+parametro2,
 *    				'T?tulo do painel', 
 *    				520, //largura
 *    				370 //altura
 *     			);
 *       }
 *	 };
 * })();
 *
 */

if ( (typeof LAYOUT_BETA != 'undefined') && LAYOUT_BETA === true ){
	//No layout do sigaa-beta, ? utilizado o di?logo do bootstrap (bootstrap-dialog.js).
	var PainelDetalhar = (function($,BootstrapDialog) {
		return {
	        show : function(url,titulo,width,height){        	
	        	BootstrapDialog.show({
	        		title: titulo,
	        		message: function (dialog){
	        			var $message = $('<div><i class="fa fa-spinner fa-pulse"></i> Carregando...</div>').load(url, function(responseTxt, statusTxt, xhr){
	        	            if(statusTxt == "error")
	        	            	dialog.setMessage("N?o foi poss?vel completar a opera??o. Tente novamente.");
	        	        });
	        			return $message;
	        		},
	        		buttons: [{
	                    label: 'OK',
	                    action: function(dialog) {
	                        dialog.close();
	                    }
	                }],
	            });
	        }
		};
	})(jQuery, BootstrapDialog);
	
	var PainelForm = (function($,BootstrapDialog) {
		return {
	        show : function(url,titulo,width,height){        	
	        	BootstrapDialog.show({
	        		title: titulo,
	        		message: function (dialog){
	        			var $message = $('<div><i class="fa fa-spinner fa-pulse"></i> Carregando...</div>').load(url, function(responseTxt, statusTxt, xhr){
	        	            if(statusTxt == "error")
	        	            	dialog.setMessage("N?o foi poss?vel completar a opera??o. Tente novamente.");
	        	        });
	        			return $message;
	        		},
	            });
	        }
		};
	})(jQuery, BootstrapDialog);
} else {
	//Funcoes do Painel em S?
	var painel; //variavel global para as views enxergarem o painel de mudarem seu tamanho.
	var PainelForm = PainelDetalhar = (function() {
	
		return {
	
	        show : function(url, titulo,width,height){
	        	var p = getEl('painel-detalhar');
	        	if (p)
	        		p.remove();
	   	 		painel = new YAHOO.ext.BasicDialog("painel-detalhar", {
	   	 			autoCreate: true,
					title: titulo,
					width:700,
					height:400,
					constraintoviewport: false,
					fixedcenter: true,
	                modal: false,
	                shadow: false,
	                resizable: true
	            });
	
	
				if(!width) width = 700;
				if(!height) height = 400;
				painel.resizeTo(width, height);
	
	       	 	painel.show();
	
				var um = painel.body.getUpdateManager();
				um.disableCaching = false;
				um.update({
					 url: url,
					 discardUrl: true,
					 nocache: true,
					 text: 'CARREGANDO...'
				 });
	        }
		};
	})();
}