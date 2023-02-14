
if(!String.prototype.parseJSON){String.prototype.parseJSON=function(hook){try{if(!/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(this.replace(/("(\\.|[^"\\])*")|('(\\.|[^'\\])*')/g,''))){var j=eval('('+this+')');if(typeof hook==='function'){function walk(v){if(v&&typeof v==='object'){for(var i in v){if(v.hasOwnProperty(i)){v[i]=walk(v[i]);}}}
return hook(v);}
return walk(j);}
return j;}}catch(e){}
throw new SyntaxError("parseJSON");};}
EventHandlersWalk=function(v){if(v&&typeof v=='object'){var names=new Array();for(var i in v){if(v.hasOwnProperty(i)){if(i.length>2&&i.substring(0,2)=='on'){names.push(i);}}}
for(var i=0;i<names.length;i++){var name=names[i];var value=v[name];if(value&&typeof value!='function'){var f=eval('(['+v[name]+'])')[0];if(typeof f=='function'){v[name]=f;}}}}
return v;};