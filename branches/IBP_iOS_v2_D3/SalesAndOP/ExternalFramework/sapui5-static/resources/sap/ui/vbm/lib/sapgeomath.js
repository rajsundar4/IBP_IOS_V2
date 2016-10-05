﻿ VBI.MathLib=(function(){var m={};m.min_longitude=-Math.PI;m.max_longitude=Math.PI;m.min_latitude=(-85.05112878*2*Math.PI)/360.0;m.max_latitude=(85.05112878*2*Math.PI)/360.0;m.mercator_for_max_latitude=3.1415942;m.div_mercator_for_max_latitude=(0.5/m.mercator_for_max_latitude);m.div_max_longitude=(1.0/m.max_longitude);m.earthradius=6371000;m.DegToRad=function(l){return[l[0]*Math.PI/180.0,l[1]*Math.PI/180.0]};m.RadToDeg=function(l){return[l[0]*180.0/Math.PI,l[1]*180.0/Math.PI]};m.LonLatToUCS=function(l,u){var n=u[0];var a=u[1];var L=l[0];var f=l[1];if(l[0]<-m.max_longitude||l[0]>m.max_longitude)L=((l[0]+m.max_longitude)%Math.PI)-m.max_longitude;if(f<m.min_latitude)f=m.min_latitude;else if(f>m.max_latitude)f=m.max_latitude;u[0]=L*m.div_max_longitude;u[0]=(u[0]+1)*n*0.5;var s=Math.sin(f);u[1]=(Math.log((1.0+s)/(1.0-s))*m.div_mercator_for_max_latitude);u[1]=(u[1]+1.0)*a*0.5;return u};m.UCSToLonLat=function(u,l){l[0]=u[0]*Math.PI;l[1]=Math.atan(m.sinh(-u[1]*m.mercator_for_max_latitude));return l};m.sinh=function(v){var a=Math.pow(Math.E,v);var b=Math.pow(Math.E,-v);return(a-b)/2};m.PositiveLODModulo=function(n,a){var b,c=(1<<a);return((b=n%c)>=0)?b:(b+c)};m.Distance=function(l,b){var R=m.earthradius;var e=l[1];var f=l[0];var g=b[1];var h=b[0];var L=g-e;var i=h-f;var a=Math.sin(L/2)*Math.sin(L/2)+Math.cos(e)*Math.cos(g)*Math.sin(i/2)*Math.sin(i/2);var c=2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a));var d=R*c;return d};m.EquidistantLonLat=function(l,d,s){var r=[];s=s||64;var b,a,c;var e=d/m.earthradius;for(var n=0;n<s;n++){b=n*2*Math.PI/s;a=Math.asin(Math.sin(l[1])*Math.cos(e)+Math.cos(l[1])*Math.sin(e)*Math.cos(b));c=l[0]+Math.atan2(Math.sin(b)*Math.sin(e)*Math.cos(l[1]),Math.cos(e)-Math.sin(l[1])*Math.sin(a));var f=[c,a];r.push(f)}return r};return m})();
