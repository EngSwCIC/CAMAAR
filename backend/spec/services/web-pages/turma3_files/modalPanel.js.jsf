
if(!window.DW){window.DW={};}
if(!window.Richfaces){window.Richfaces={};}
function discardElement(element){var garbageBin=document.getElementById('IELeakGarbageBin');if(!garbageBin){garbageBin=document.createElement('DIV');garbageBin.id='IELeakGarbageBin';garbageBin.style.display='none';document.body.appendChild(garbageBin);}
window.RichFaces.Memory.clean(element);garbageBin.appendChild(element);garbageBin.innerHTML='';}
Selection={};Selection.eventHandler=function(event){Event.stop(event);};Selection.eventHandler=Selection.eventHandler.bindAsEventListener(Selection);Selection.disableSelection=function(element)
{if(typeof element.onselectstart!="undefined")
{Event.observe(element,'selectstart',this.eventHandler);}
else if(typeof element.style.MozUserSelect!="undefined")
{element.style.MozUserSelect="none";}
else
{Event.observe(element,'mousedown',this.eventHandler);}}
Selection.enableSelection=function(element)
{if(typeof element.onselectstart!="undefined")
{Event.stopObserving(element,'selectstart',this.eventHandler);}
else if(typeof element.style.MozUserSelect!="undefined")
{element.style.MozUserSelect="";}
else
{Event.stopObserving(element,'mousedown',this.eventHandler);}}
ModalPanel=Class.create();{var ieVersion=RichFaces.getIEVersion();if(ieVersion&&ieVersion<7){ModalPanel.disableSelects=true;}}
ModalPanel.panels=new Array();ModalPanel.activePanels=new Array();function getSizeElement(){var element;var element;if(RichFaces.navigatorType()!=RichFaces.OPERA&&document.compatMode=='CSS1Compat'){element=document.documentElement;}else{element=document.body;}
return element;}
ModalPanel.getMinimumSize=function(size){return Math.max(size,2*ModalPanel.Sizer.INITIAL_MIN+2);};ModalPanel.prototype={initialize:function(id,options){this["rich:destructor"]="destroy";this.markerId=$(id);this.id=$(id+"Container");this.options=options;this.baseZIndex=this.options.zindex?this.options.zindex:100;this.minWidth=ModalPanel.getMinimumSize(this.options.minWidth);this.minHeight=ModalPanel.getMinimumSize(this.options.minHeight);this.div=id+"Div";this.cursorDiv=id+"CursorDiv";this.cdiv=id+"CDiv";this.contentDiv=id+"ContentDiv";this.contentTable=id+"ContentTable";this.shadowDiv=id+"ShadowDiv";this.borders=new Array();if(this.options.resizeable){this.borders.push(new ModalPanel.Border(id+"ResizerN",this,"N-resize",ModalPanel.Sizer.N));this.borders.push(new ModalPanel.Border(id+"ResizerE",this,"E-resize",ModalPanel.Sizer.E));this.borders.push(new ModalPanel.Border(id+"ResizerS",this,"S-resize",ModalPanel.Sizer.S));this.borders.push(new ModalPanel.Border(id+"ResizerW",this,"W-resize",ModalPanel.Sizer.W));this.borders.push(new ModalPanel.Border(id+"ResizerNWU",this,"NW-resize",ModalPanel.Sizer.NWU));this.borders.push(new ModalPanel.Border(id+"ResizerNEU",this,"NE-resize",ModalPanel.Sizer.NEU));this.borders.push(new ModalPanel.Border(id+"ResizerNEL",this,"NE-resize",ModalPanel.Sizer.NEL));this.borders.push(new ModalPanel.Border(id+"ResizerSEU",this,"SE-resize",ModalPanel.Sizer.SEU));this.borders.push(new ModalPanel.Border(id+"ResizerSEL",this,"SE-resize",ModalPanel.Sizer.SEL));this.borders.push(new ModalPanel.Border(id+"ResizerSWL",this,"SW-resize",ModalPanel.Sizer.SWL));this.borders.push(new ModalPanel.Border(id+"ResizerSWU",this,"SW-resize",ModalPanel.Sizer.SWU));this.borders.push(new ModalPanel.Border(id+"ResizerNWL",this,"NW-resize",ModalPanel.Sizer.NWL));}
if(this.options.moveable&&$(id+"Header")){this.header=new ModalPanel.Border(id+"Header",this,"move",ModalPanel.Header);}
this.markerId.component=this;var eDiv=$(this.div);if(eDiv.style.setExpression)
if(ModalPanel.disableSelects||Richfaces.getComputedStyle(eDiv,"position")!="fixed")
{eDiv.style.position="absolute";var eCursorDiv=$(this.cursorDiv);eCursorDiv.style.position="absolute";eDiv.style.zoom="1";eCursorDiv.style.zoom="1";var eCdiv=$(this.cdiv);eCdiv.style.position="absolute";eCdiv.parentNode.style.position="absolute";eCdiv.mpUseExpr=true;}
ModalPanel.panels.push(this);this.eventFirstOnfocus=this.firstOnfocus.bindAsEventListener(this);this.eventLastOnfocus=this.lastOnfocus.bindAsEventListener(this);this.firstHref=id+"FirstHref";this.lastHref=id+"LastHref";this.selectBehavior=options.selectBehavior;},_saveInputValues:function(element){if(Prototype.Browser.IE){var inputs=element.getElementsByTagName('input');if(inputs){for(var i=0;i<inputs.length;i++){var input=inputs[i];if(input.type=='checkbox'||input.type=='radio'){input.defaultChecked=input.checked;}}}}},width:function(){return this.getSizedElement().clientWidth;},height:function(){return this.getSizedElement().clientHeight;},getSizedElement:function(){if(!this._sizedElement){this._sizedElement=$(this.cdiv);}
return this._sizedElement;},getContentElement:function(){if(!this._contentElement){this._contentElement=this.options.autosized?$(this.contentTable):$(this.contentDiv);}
return this._contentElement;},destroy:function(){if(this.observerSize){window.clearInterval(this.observerSize);this.observerSize=null;}
this._contentElement=null;this._sizedElement=null;ModalPanel.panels=ModalPanel.panels.without(this);this.enableSelects();ModalPanel.activePanels=ModalPanel.activePanels.without(this);this.parent=null;this.firstOutside=null;this.lastOutside=null;if(this.header){this.header.destroy();this.header=null;}
for(var k=0;k<this.borders.length;k++){this.borders[k].destroy();}
this.borders=null;setTimeout(function(){if(this.domReattached){var element=this.id;var parent=element.parentNode;if(parent){parent.removeChild(element);discardElement(element);}}}.bind(this),0);this.markerId.component=null;this.markerId=null;},initIframe:function(){if(this.contentWindow){Element.setStyle(this.contentWindow.document.body,{"margin":"0px 0px 0px 0px"});}else{}
if("transparent"==Element.getStyle(document.body,"background-color")){this.style.filter="alpha(opacity=0)";this.style.opacity="0";}},enableSelect:function(elt){if(elt._mdwProcessed){elt._mdwProcessed=undefined;if(elt._mdwDisabled){elt.disabled=false;elt._mdwDisabled=undefined;}
if(typeof elt._mdwHidden!="undefined"){elt.style.visibility=elt._mdwHidden;elt._mdwHidden=undefined;}}},disableSelect:function(elt){if(!elt._mdwProcessed){elt._mdwProcessed=true;if("hide"==this.selectBehavior){if(elt.style.visibility!="hidden"){elt._mdwHidden=elt.style.visibility;elt.style.visibility="hidden";}}else{if(!elt.disabled){elt.disabled=true;elt._mdwDisabled=true;}}}},enableInnerSelects:function(){if(ModalPanel.disableSelects){var selects=this.id.getElementsByTagName("SELECT");for(var k=0;k<selects.length;k++){this.enableSelect(selects[k]);}}},disableInnerSelects:function(){if(ModalPanel.disableSelects){var selects=this.id.getElementsByTagName("SELECT");for(var k=0;k<selects.length;k++){this.disableSelect(selects[k]);}}},enableSelects:function(){if(!ModalPanel.disableSelects){return;}
var lastPanel=ModalPanel.activePanels[ModalPanel.activePanels.length-1];var newLastPanel=ModalPanel.activePanels[ModalPanel.activePanels.length-2];if(newLastPanel){if(lastPanel==this){newLastPanel.enableInnerSelects();}}else{var selects=document.body.getElementsByTagName("SELECT");for(var i=0;i<selects.length;i++){this.enableSelect(selects[i]);}}},disableOuterSelects:function(){if(!ModalPanel.disableSelects){return;}
var lastPanel=ModalPanel.activePanels.last();if(lastPanel){lastPanel.disableInnerSelects();this.enableInnerSelects();}else{var selects=document.body.getElementsByTagName("SELECT");var innerSelects=this.id.getElementsByTagName("SELECT");var firstInnerSelect=innerSelects[0];var lastInnerSelect=innerSelects[innerSelects.length-1];var selectsAreInner=false;for(var i=0;i<selects.length;i++){var select=selects[i];if(select==firstInnerSelect){selectsAreInner=true;}
if(!selectsAreInner){this.disableSelect(select);}
if(select==lastInnerSelect){selectsAreInner=false;}}}},setLeft:function(pos){var eCdiv=$(this.cdiv);if(eCdiv.mpUseExpr){eCdiv.mpLeft=pos;}else{eCdiv.style.left=pos+"px";}},setTop:function(pos){var eCdiv=$(this.cdiv);if(eCdiv.mpUseExpr){eCdiv.mpTop=pos;}else{eCdiv.style.top=pos+"px";}},firstOnfocus:function(event){var e=$(this.firstHref)
if(e&&(ModalPanel.activePanels.last()==this)){e.focus();}},lastOnfocus:function(event){var e=$(this.lastHref);if(e&&(ModalPanel.activePanels.last()==this)){e.focus();}},formElements:"|a|input|select|button|textarea|",processAllFocusElements:function(root,callback){var idx=-1;var tagName;if(root.focus&&root.nodeType==1&&(tagName=root.tagName)&&(idx=this.formElements.indexOf(tagName.toLowerCase()))!=-1&&this.formElements.charAt(idx-1)==='|'&&this.formElements.charAt(idx+tagName.length)==='|'&&!root.disabled&&root.type!="hidden"){callback.call(this,root);}else{if(root!=this.id){var child=root.firstChild;while(child){if(!child.style||child.style.display!='none'){this.processAllFocusElements(child,callback);}
child=child.nextSibling;}}}},processTabindexes:function(input){if(!this.firstOutside&&!(input.tagName.toLowerCase()=="select"&&ModalPanel.disableSelects)){this.firstOutside=input;}
this.lastOutside=input;if(input.tabIndex&&!input.prevTabIndex){input.prevTabIndex=input.tabIndex;}
input.tabIndex=undefined;if(input.accesskey&&!input.prevAccesskey){input.prevAccesskey=input.accesskey;}
input.accesskey=undefined;},restoreTabindexes:function(input){if(input.prevTabIndex){input.tabIndex=input.prevTabIndex;input.prevTabIndex=undefined;}
if(input.prevAccesskey){input.accesskey=input.prevAccesskey;input.prevAccesskey=undefined;}},preventFocus:function(){this.processAllFocusElements(document,this.processTabindexes);if(this.firstOutside){Event.observe(this.firstOutside,"focus",this.eventFirstOnfocus);}
if(this.lastOutside&&this.lastOutside!=this.firstOutside){Event.observe(this.lastOutside,"focus",this.eventLastOnfocus);}},restoreFocus:function(){this.processAllFocusElements(document,this.restoreTabindexes);if(this.firstOutside){Event.stopObserving(this.firstOutside,"focus",this.eventFirstOnfocus);this.firstOutside=null;}
if(this.lastOutside){Event.stopObserving(this.lastOutside,"focus",this.eventLastOnfocus);this.lastOutside=null;}},show:function(event,opts){if(!this.shown&&this.invokeEvent("beforeshow",event,null,element)){var element=this.id;this.preventFocus();if(!this.domReattached){this.parent=element.parentNode;var domElementAttachment;if(opts){domElementAttachment=opts.domElementAttachment;}
if(!domElementAttachment){domElementAttachment=this.options.domElementAttachment;}
var newParent;if('parent'==domElementAttachment){newParent=this.parent;}else if('form'==domElementAttachment){newParent=this._findForm(element)||document.body;}else{newParent=document.body;}
if(newParent!=this.parent){this._saveInputValues(element);newParent.insertBefore(element,null);this.domReattached=true;}else{Element.show(this.parent);}}
var eCdiv=$(this.cdiv);var forms=eCdiv.getElementsByTagName("form");if(this.options.keepVisualState&&forms){this.formOnsubmit=this.setStateInput.bindAsEventListener(this);for(var i=0;i<forms.length;i++){Event.observe(forms[i],"submit",this.formOnsubmit);}}
var eIframe;if((ModalPanel.disableSelects||this.options.overlapEmbedObjects)&&!this.iframe){this.iframe=this.id.id+"IFrame";new Insertion.Top(eCdiv,"<iframe src=\"javascript:''\" frameborder=\"0\" scrolling=\"no\" id=\""+this.iframe+"\" "+"class=\"rich-mpnl-iframe\" style=\"width: 1px; height: 1px;\">"+"</iframe>");eIframe=$(this.iframe);Event.observe(eIframe,'load',this.initIframe.bindAsEventListener(eIframe));}
var options={};this.userOptions={};if(!eCdiv.mpSet){Object.extend(options,this.options);}
if(opts){Object.extend(options,opts);Object.extend(this.userOptions,opts);}
this.currentMinHeight=ModalPanel.getMinimumSize((options.minHeight||options.minHeight==0)?options.minHeight:this.minHeight);this.currentMinWidth=ModalPanel.getMinimumSize((options.minWidth||options.minWidth==0)?options.minWidth:this.minWidth);var eContentElt=this.getContentElement();if(!this.options.autosized){if(options.width&&options.width==-1)
options.width=300;if(options.height&&options.height==-1)
options.height=200;}
if(options.width&&options.width!=-1){if(this.currentMinWidth>options.width){options.width=this.currentMinWidth;}
eContentElt.style.width=options.width+(/px/.test(options.width)?'':'px');}
if(options.height&&options.height!=-1){if(this.currentMinHeight>options.height){options.height=this.currentMinHeight;}
eContentElt.style.height=options.height+(/px/.test(options.height)?'':'px');}
eCdiv.mpSet=true;this.disableOuterSelects();ModalPanel.activePanels=ModalPanel.activePanels.without(this);ModalPanel.activePanels.push(this);var eDiv=$(this.div);if(eDiv.style.position=="absolute")
{var we="getSizeElement().clientWidth + \"px\"";var he="getSizeElement().clientHeight + \"px\"";eDiv.style.setExpression("width",we);eDiv.style.setExpression("height",he);var eCursorDiv=$(this.cursorDiv);eCursorDiv.style.setExpression("width",we);eCursorDiv.style.setExpression("height",he);var le="-Position.cumulativeOffset(this.parentNode)[0] + getSizeElement().scrollLeft + \"px\"";var te="-Position.cumulativeOffset(this.parentNode)[1] + getSizeElement().scrollTop + \"px\"";eDiv.style.setExpression("left",le);eDiv.style.setExpression("top",te);eCursorDiv.style.setExpression("left",le);eCursorDiv.style.setExpression("top",te);var leftExpr="(this.mpLeft || 0) + -Position.cumulativeOffset(this.parentNode)[0] + getSizeElement().scrollLeft + \"px\"";var topExpr="(this.mpTop || 0) + -Position.cumulativeOffset(this.parentNode)[1] + getSizeElement().scrollTop + \"px\"";eCdiv.style.setExpression("left",leftExpr);eCdiv.style.setExpression("top",topExpr);}
element.style.visibility="hidden";Element.show(element);this.correctShadowSize();if(options.left){var _left;if(options.left!="auto"){_left=parseInt(options.left,10);}else{var cw=getSizeElement().clientWidth;var _width=this.width();if(cw>=_width){_left=(cw-_width)/2;}else{_left=0;}}
this.setLeft(Math.round(_left));}
if(options.top){var _top;if(options.top!="auto"){_top=parseInt(options.top,10);}else{var cw=getSizeElement().clientHeight;var _height=this.height();if(cw>=_height){_top=(cw-_height)/2;}else{_top=0;}}
this.setTop(Math.round(_top));}
if(this.options.autosized){this.observerSize=window.setInterval(this.correctShadowSize.bindAsEventListener(this),500);}
this.doResizeOrMove(ModalPanel.Sizer.Diff.EMPTY);for(var k=0;k<this.borders.length;k++){this.borders[k].doPosition();}
if(this.header){this.header.doPosition();}
Element.hide(eCdiv);element.style.visibility="";this.lastOnfocus();Element.show(eCdiv);var event={};event.parameters=opts||{};this.shown=true;this.invokeEvent("show",event,null,element);}},startDrag:function(border){for(var k=0;k<this.borders.length;k++){this.borders[k].hide();}
Selection.disableSelection(document.body);},endDrag:function(border){for(var k=0;k<this.borders.length;k++){this.borders[k].show();this.borders[k].doPosition();}
Selection.enableSelection(document.body);},hide:function(event,opts){if(this.shown&&this.invokeEvent("beforehide",event,null,element)){this.currentMinHeight=undefined;this.currentMinWidth=undefined;this.restoreFocus();this.enableSelects();ModalPanel.activePanels=ModalPanel.activePanels.without(this);var eDiv=$(this.div);var eCdiv=$(this.cdiv);if(eDiv.style.position=="absolute"){eDiv.style.removeExpression("width");eDiv.style.removeExpression("height");eDiv.style.removeExpression("left");eDiv.style.removeExpression("top");var eCursorDiv=$(this.cursorDiv);eCursorDiv.style.removeExpression("width");eCursorDiv.style.removeExpression("height");eCursorDiv.style.removeExpression("left");eCursorDiv.style.removeExpression("top");eCdiv.style.removeExpression("left");eCdiv.style.removeExpression("top");}
var element=$(this.id);Element.hide(element);if(this.parent){if(this.domReattached){this._saveInputValues(element);this.parent.appendChild(element);this.domReattached=false;}else{Element.hide(this.parent);}}
var event={};event.parameters=opts||{};if(this.options&&this.options.onhide){this.options.onhide(event);}
var forms=eCdiv.getElementsByTagName("form");if(this.options.keepVisualState&&forms){for(var i=0;i<forms.length;i++){Event.stopObserving(forms[i],"submit",this.formOnsubmit);}}
this.shown=false;if(this.observerSize){window.clearInterval(this.observerSize);this.observerSize=null;}
if(ModalPanel.activePanels.length>0){ModalPanel.activePanels.last().preventFocus();}}},_getStyle:function(elt,name){return parseInt(elt.style[name].replace("px",""),10);},doResizeOrMove:function(diff){var vetoes={};var cssHash={};var cssHashWH={};var vetoeChange=false;var newSize;var eContentElt=this.getContentElement();newSize=this._getStyle(eContentElt,"width");var oldSize=newSize;newSize+=diff.deltaWidth||0;if(newSize>=this.currentMinWidth||this.options.autosized){if(diff.deltaWidth){cssHashWH.width=newSize+'px';}}else{if(diff.deltaWidth){cssHashWH.width=this.currentMinWidth+'px';vetoes.vx=oldSize-this.currentMinWidth;}
vetoes.x=true;}
if(vetoes.vx&&diff.deltaX){diff.deltaX=-vetoes.vx;}
var eCdiv=$(this.cdiv);if(diff.deltaX&&(vetoes.vx||!vetoes.x)){if(vetoes.vx){diff.deltaX=vetoes.vx;}
var newPos;newPos=this._getStyle(eCdiv,"left");newPos+=diff.deltaX;cssHash.left=newPos+'px';}
newSize=this._getStyle(eContentElt,"height")
var oldSize=newSize;newSize+=diff.deltaHeight||0;if(newSize>=this.currentMinHeight||this.options.autosized){if(diff.deltaHeight){cssHashWH.height=newSize+'px';}}else{if(diff.deltaHeight){cssHashWH.height=this.currentMinHeight+'px';vetoes.vy=oldSize-this.currentMinHeight;}
vetoes.y=true;}
if(vetoes.vy&&diff.deltaY){diff.deltaY=-vetoes.vy;}
if(diff.deltaY&&(vetoes.vy||!vetoes.y)){if(vetoes.vy){diff.deltaY=vetoes.vy;}
var newPos;if(eCdiv.mpUseExpr){newPos=eCdiv.mpTop||0;newPos+=diff.deltaY;eCdiv.mpTop=newPos;cssHash.top=newPos+'px';}else{newPos=this._getStyle(eCdiv,"top");newPos+=diff.deltaY;cssHash.top=newPos+'px';}}
Element.setStyle(eContentElt,cssHashWH);Element.setStyle(eCdiv,cssHash);this.correctShadowSize();Object.extend(this.userOptions,cssHash);Object.extend(this.userOptions,cssHashWH);var w=this.width();var h=this.height();this.reductionData=null;if(w<=2*ModalPanel.Sizer.INITIAL_MAX){this.reductionData={};this.reductionData.w=w;}
if(h<=2*ModalPanel.Sizer.INITIAL_MAX){if(!this.reductionData){this.reductionData={};}
this.reductionData.h=h;}
if(this.header){this.header.doPosition();}
return vetoes;},_findForm:function(elt){var target=elt;while(target){if(!target.tagName||target.tagName.toLowerCase()!="form"){target=target.parentNode;}else{break;}}
return target;},setStateInput:function(e){var target=Event.element(e);if(e&&target){target=this._findForm(target);var input=document.createElement("input");input.type="hidden";input.id=this.markerId.id+"OpenedState";input.name=this.markerId.id+"OpenedState";input.value=this.shown?"true":"false";target.appendChild(input);var keys=$H(this.userOptions).keys();if(keys){for(var i=0;i<keys.length;i++){input=document.createElement("input");input.type="hidden";input.id=this.id.id+"StateOption_"+keys[i];input.name=this.id.id+"StateOption_"+keys[i];input.value=this.userOptions[keys[i]];target.appendChild(input);}}
return true;}},correctShadowSize:function(){var eShadowDiv=$(this.shadowDiv);if(!eShadowDiv){return;}
var eIframe=$(this.iframe);var dx=0;var dy=0;if(!Richfaces.browser.isIE)
{dx=eShadowDiv.offsetWidth-eShadowDiv.clientWidth;dy=eShadowDiv.offsetHeight-eShadowDiv.clientHeight;}
var w=this.width();var h=this.height();eShadowDiv.style.width=(w-dx)+"px";eShadowDiv.style.height=(h-dy)+"px";if(eIframe){eIframe.style.width=w+"px";eIframe.style.height=h+"px";}},invokeEvent:function(eventName,event,value,element){var eventFunction=this.options['on'+eventName];var result;if(eventFunction){var eventObj;if(event){eventObj=event;}
else if(document.createEventObject){eventObj=document.createEventObject();}
else if(document.createEvent){eventObj=document.createEvent('Events');eventObj.initEvent(eventName,true,false);}
eventObj.rich={component:this};eventObj.rich.value=value;try{result=eventFunction.call(element,eventObj);}
catch(e){LOG.warn("Exception: "+e.Message+"\n[on"+eventName+"]");}}
if(result!=false){result=true;}
return result;}}
Richfaces.findModalPanel=function(id){if(id){var prefId=(id.charAt(0)==':'?id:':'+id);for(var i=0;i<ModalPanel.panels.length;i++){var pnl=ModalPanel.panels[i];if(pnl&&pnl.markerId){var pnlId=pnl.markerId.id;if(pnlId){if(pnlId.length>=prefId.length){var substr=pnlId.substring(pnlId.length-prefId.length,pnlId.length);if(substr==prefId){return pnl.markerId;}}}}}}}
Richfaces.showModalPanel=function(id,opts,event){var invoke=(Richfaces.browser.isIE||Richfaces.browser.isSafari)?function(f){if(document.readyState!="complete"){var args=arguments;var dis=this;window.setTimeout(function(){args.callee.apply(dis,args);},50);}else{f();}}:function(f){f();};var panel=$(id);if(!panel){panel=Richfaces.findModalPanel(id);}
invoke(function(){panel.component.show(event,opts);});};Richfaces.hideModalPanel=function(id,opts,event){var panel=$(id);if(!panel){panel=Richfaces.findModalPanel(id);}
panel.component.hide(event,opts);};Richfaces.hideTopModalPanel=function(event,opts){var mp=ModalPanel.activePanels.last();if(mp){mp.hide(event,opts);}}