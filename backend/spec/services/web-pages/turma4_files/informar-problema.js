/**
 * Componente para chamada da tela de informar um problema no sistema
 * @author Arlindo Rodrigues
 */
"use strict";
class InformarProblemaButton extends HTMLElement {

   
   constructor() {
       super();
   } 
   
   getAttributes(){
      var data = {};
	  data['usuario'] = this.getAttribute('data-usuario') ? this.getAttribute('data-usuario') : "-";
	  data['idUsuario'] = this.getAttribute('data-id')? this.getAttribute('data-id') : "0";
	  data['sistema'] = this.getAttribute('data-sistema') ? this.getAttribute('data-sistema'): "0";
	  data['urlBase'] = this.getAttribute('data-url') ? this.getAttribute('data-url') : "";	  	  
	  data['url'] = window.location.href;	  	  
	  data['email'] = this.getAttribute('data-email') ? this.getAttribute('data-email') : "-";	  	  
	  data['modulo'] = this.getAttribute('data-modulo')? this.getAttribute('data-modulo') : "INDEFINIDO";	  	  
	  data['registroEntrada'] = this.getAttribute('data-registro-entrada') ? this.getAttribute('data-registro-entrada') : "0";	  
	  data['dialog'] = this.getAttribute('data-dialog') ? this.getAttribute('data-dialog') : 'yahoo';	
	  return data;
   }
   
   createContent(params){
	   
	  var iframe = "<iframe id='iframe-info-problema' name='iframe-info-problema' width='100%' height='100%' frameborder='0' scrolling='no'></iframe>";
	  var content ="<div class='ydlg-hd'>&nbsp;</div><div class='ydlg-bd'>"+iframe+"</div>";
	  
	  if (params['dialog'] == 'bootstrap'){
		  content =
	       "<div class='modal-dialog modal-dialog-problema'>"+
	        "<div class='modal-content modal-body-problema'>"+
	          "<div class='modal-header'>"+
	            "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>"+
	            "<h4 class='modal-title'>Informar Problema</h4>"+
	          "</div>"+
	          "<div class='modal-body'>"+
	          	iframe+
	          "</div>"+
	        "</div>"+
	       "</div>";
	  } 
	   
	  var divBase = document.createElement('div');
	  divBase.id = "dialog-info-problema";
	  divBase.innerHTML = content;
	  divBase.className = params['dialog'] == 'bootstrap' ? "modal fade" : "hide-dialog";
	  return divBase;
   }   

   createdCallback(){

      var params = this.getAttributes();
  	
      this.appendChild(this.createContent(params));
      
      var link = document.createElement('a');
      link.innerText = this.getAttribute('data-titulo');
      link.href = "#";
      link.className = 'informar-problema-titulo';
      
      if (params['dialog'] === 'bootstrap') {
	      link.setAttribute("data-toggle", "modal");
	      link.setAttribute("data-target", "#dialog-info-problema");	    	  
      }
      
      link.addEventListener('click', () => this.submeterRelatorio(params));      
      this.appendChild(link);
      
   }  

   showLoading(){
	   var htmlLoading = '<body><img src="/shared/img/websnapr/loading.gif"/> Carregando...</body>';
	   jQuery("#dialog-info-problema").find('iframe').html("").attr("src","javascript:'"+htmlLoading+"'");	 
   }

   submeterRelatorio(params){
	  this.showLoading();
	  submeter(params);
   }         
   
}

var dialogInfoProblema = (function() {
	var painel;
	return {
        show : function(){
            jQuery("#dialog-info-problema").attr('style', 'display:inline');
            painel = new YAHOO.ext.BasicDialog("dialog-info-problema", {
                modal: true,
                width: 930,
                height: 760,
                shadow: false,
                fixedcenter: true,
                resizable: false,
                closable: true
            });
       	 	painel.show();
            jQuery("#dialog-info-problema .ydlg-close").html("<i class='icon fa fa-times' title='Fechar'></i>");
        }
	};
})();


document.registerElement("informar-problema", InformarProblemaButton);

function redirectPost(params){
	 var form = '';
    jQuery.each( params, function( key, value ) {
        value = value.split('"').join('\"')
        form += '<input type="hidden" name="'+key+'" value="'+value+'">';
    });
    var formHtml = jQuery('<form id="form-info-problema" action="' + params['urlBase'] + '" method="POST" target="iframe-info-problema" accept-charset="UTF-8">' + form + '</form>').appendTo(jQuery(document.body));
    formHtml.submit();
}

var submeter = function(params) {
    html2canvas(document.body, {
    	onrendered: function (canvas) {
  		  	if (params['dialog'] == 'yahoo')
			  dialogInfoProblema.show();    		
  		  	params['print'] = canvas.toDataURL("image/png");;
        	redirectPost(params);	
        }
    });
}
