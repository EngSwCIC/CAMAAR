var slider = null;
var timeout = null;
var valorInicial = 0;
var select = null;

// Slider Desativado
/*
function configurarSlider() {
	slider = J("#sliderPaginacao").slider({
		min: 1,
		max: maximoSlider,
		range: "min",
		value: select[0].selectedIndex + 1,
		animate: true,
		start : function (event, ui) {
			valorInicial = ui.value;
		},
		slide: function(event, ui) {
			select[0].selectedIndex = ui.value - 1;
			J("#tooltip1").html(J('#formAva\\:escolherTopico :selected').text());
		},
		stop: function(event, ui) {
			carregarTopico();
		}
	});

	J("#sliderPaginacao").parent().wTooltip({
		content: J('#formAva\\:escolherTopico :selected').text(),
		id: "tooltip1"
	});
}
*/
function exibeTopicoAnterior (){
	document.getElementById("formAva:escolherTopico").selectedIndex --;
	escolheTopico ();
}

function exibeProximoTopico (){
	document.getElementById("formAva:escolherTopico").selectedIndex ++;
	escolheTopico ();
}

function escolheTopico (){

	panelAcoesTopicoAula.hide();
	
	var select = document.getElementById("formAva:escolherTopico");
	
	document.getElementById('formAva:idTopicoSelecionado').value = select.value;
	document.getElementById('formAva:bExibirTopico').click();
}

function auxEscolheTopico(id){
	var select = document.getElementById("formAva:escolherTopico");
	select.value = id;
	
	escolheTopico();
}

function acaoTopico (select){
	document.getElementById("formAva:idTopicoAcao").value = select.value;
	J('#formAva\\:realizarAcaoTopico').trigger("click");
}

function cancelarEsperaSlider () {
	configurarBotoes(false);
	slider.slider( "option", "value", valorInicial );
}

function completarCarregamentoTopico () {
	slider.slider( "option", "value", select[0].selectedIndex + 1 );
	J("#tooltip1").html(J('#formAva\\:escolherTopico :selected').text());
	
	if (timeout != null)
		clearTimeout(timeout);
	
	configurarBotoes(false);
}

function carregarTopico () {
	escolheTopico();
	configurarBotoes(true);
	timeout = setTimeout('cancelarEsperaSlider()', 2000);
}

function configurarBotoes(estado){
	slider.slider( "option", "disabled", estado );
}