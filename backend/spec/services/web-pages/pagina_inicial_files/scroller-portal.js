/*
Fading Scroller- By DynamicDrive.com
For full source code, and usage terms, visit http://www.dynamicdrive.com
This notice MUST stay intact for use
*/

var delay=10000 //set delay between message change (in miliseconds)

var fwidth='240px' //set scroller width
var fheight='45px' //set scroller height

var fadescheme=0 //set 0 to fade text color from (white to black), 1 for (black to white)
var fadelinks=1  //should links inside scroller content also fade like text? 0 for no, 1 for yes.
var paused = false;

///No need to edit below this line/////////////////

var hex=(fadescheme==0)? 255 : 0
var startcolor=(fadescheme==0)? "rgb(239,240,241)" : "rgb(0,0,0)"
var endcolor=(fadescheme==0)? "rgb(0,0,0)" : "rgb(239,240,241)"

var ie4=document.all&&!document.getElementById
var ns4=document.layers
var DOM2=document.getElementById
var faderdelay=0
var index=0

if (DOM2)
faderdelay=2000

//function to change content
function changecontent(){
	if (!paused) {
		change()
		index++
	}
	setTimeout("changecontent()",delay+faderdelay)
}

function change() {
	if (index>=fcontent.length)
		index=0
	if (DOM2){
		document.getElementById("fscroller").style.color=startcolor
		document.getElementById("fscroller").innerHTML=fcontent[index]
		linksobj=document.getElementById("fscroller").getElementsByTagName("A")
		if (fadelinks)
			linkcolorchange(linksobj)
		colorfade()
	} else if (ie4) {
		document.all.fscroller.innerHTML=fcontent[index]
	} else if (ns4) {
		document.fscrollerns.document.fscrollerns_sub.document.write(fcontent[index])
		document.fscrollerns.document.fscrollerns_sub.document.close()
	}
}
// colorfade() partially by Marcio Galli for Netscape Communications.  ////////////
// Modified by Dynamicdrive.com

frame=20;

function linkcolorchange(obj){
if (obj.length>0){
for (i=0;i<obj.length;i++)
obj[i].style.color="rgb("+hex+","+hex+","+hex+")"
}
}

function lerTudo() {
	var url = sistema + "/noticias_comum.jsf?portal=" + portal;
	window.open(url,'','width=690,height=430, top=100, left=100, scrollbars' );
}

function pauseEl() { paused = !paused; }
function nextEl() { 
	index++; 
	if (index>=fcontent.length)
		index=0
	change(); 
}
function previousEl() { 
	index--;
	if (index < 0)
		index=fcontent.length - 1
	change(); 
}
function colorfade() {
// 20 frames fading process
if(frame>0) {
hex=(fadescheme==0)? hex-12 : hex+12 // increase or decrease color value depd on fadescheme
document.getElementById("fscroller").style.color="rgb("+hex+","+hex+","+hex+")"; // Set color value.
if (fadelinks)
linkcolorchange(linksobj)
frame--;
setTimeout("colorfade()",20);
}

else{
document.getElementById("fscroller").style.color=endcolor;
frame=20;
hex=(fadescheme==0)? 255 : 0
}
}
var controls = '<div id="controls" style="text-align: right; position: absolute; bottom: 5px; right: 5px"><img src="/shared/img/flash_volta.gif" style="cursor: pointer" onclick="previousEl();"/>&nbsp;<img src="/shared/img/flash_pause.gif" style="cursor: pointer" onclick="pauseEl();"/>&nbsp;<img src="/shared/img/flash_vai.gif" style="cursor: pointer" onclick="nextEl();"/>&nbsp;<img src="/shared/img/vermais8.jpg" style="text-indent: -5000px;" alt="clique aqui para visualizar todas as noticias." style="cursor: pointer" onclick="lerTudo();"/></div>';
var lerMais = '<div id="lerMais" style="text-align: right; position: absolute; bottom: 5px; right: 5px"><img src="/shared/img/vermais.jpg" style="cursor: pointer" onclick="lerTudo();"/><img src="/shared/img/vermais8.jpg" style="cursor: pointer" onclick="lerTudo();"/></div>';
if (ie4||DOM2)
document.write('<div id="fscroller" style="border:0px solid black;padding:2px;"></div>' + controls/* + lerMais*/) // width:'+fwidth+';height:'+fheight+';

window.onload=changecontent