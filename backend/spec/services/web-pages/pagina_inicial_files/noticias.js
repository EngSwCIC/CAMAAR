
var PainelNoticias=(function(){var painel,link,urlRedirect;return{init:function(urlParametro){urlRedirect=urlParametro;link=getEl('noticias-portal');if(link!=undefined)
link.on('click',this.show,this,true);},show:function(event){var el=event.target?event.target:event.srcElement;if(el.nodeName!=='A'){return false;}
if(!painel){painel=new YAHOO.ext.BasicDialog("painel-noticia",{autoCreate:true,title:'Notícia',modal:false,animateTarget:'noticias-portal',width:700,height:400,shadow:true,resizable:false});painel.addKeyListener(27,painel.hide,painel);}
painel.show();var mgr=painel.body.getUpdateManager();if(!mgr.beforeUpdate.fireDirect){mgr.beforeUpdate.fireDirect=function(){}}
mgr.update(urlRedirect+'?id='+el.id.substring(8)+'&ajaxRequest=true');YAHOO.ext.DialogManager.bringToFront(painel);}};})();