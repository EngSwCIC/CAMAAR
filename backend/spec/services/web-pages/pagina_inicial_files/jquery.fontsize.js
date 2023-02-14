var J = jQuery.noConflict();
function redimensionarFonte(painel, alvo, minTam, tam, maxTam) {if(J.cookie != undefined) {var cookie = alvo.replace(/[#. ]/g,'');var value = J.cookie(cookie);if(value !=null) {J(alvo).css('font-size', parseInt(value));}}
J(painel + " .fonteMenor").click(function(){atualTam = parseInt(J(alvo).css("font-size"));novoTam = atualTam - 1;if(novoTam >= minTam) J(alvo).css('font-size', novoTam);atualizaTamCookie(alvo, novoTam);});
J(painel + " .fonteMaior").click(function(){atualTam = parseInt(J(alvo).css("font-size"));novoTam = atualTam + 1;if(novoTam <= maxTam)J(alvo).css('font-size', novoTam);atualizaTamCookie(alvo, novoTam);});
function atualizaTamCookie(alvo, tam){if(J.cookie != undefined) { var cookie = alvo.replace(/[#. ]/g,'');J.cookie(cookie, tam);}}
}