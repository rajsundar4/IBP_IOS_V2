﻿ 
function UnlinkImage(i){for(var a=i.m_Prev;a;a=a.m_Prev){a.m_bOutdated=true}for(var a=i.m_Next;a;a=a.m_Next){a.m_bOutdated=true}var c=i.m_Prev;var b=i.m_Next;if(c!=null){i.m_Prev.m_Next=b;i.m_Prev=null}if(b!=null){i.m_Next.m_Prev=c;i.m_Next=null}}
VBI.MapManager=(function(){var m={};m.vbiclass="MapManager";m.m_nRequest=0;m.m_tileWidth=256;m.m_tileHeight=256;m.onAbort=function(e){var i=e.srcElement;VBI.m_bTrace&&VBI.Trace("onAbort "+i.src);UnlinkImage(i)};m.onError=function(e){var i=e.srcElement;var a=null;VBI.m_bTrace&&VBI.Trace("onError "+i.src);if(i.m_Next!=null)i.m_Next.m_FillStyle=i.m_FillStyle;if(i.m_Prev==null&&i.m_Next!=null&&i.m_Next.complete==true)a=i.m_Next;UnlinkImage(i);if(a!=null)m.RenderTile(a)};m.onLoad=function(e){var i=e.srcElement||e.target;VBI.m_bTrace&&VBI.Trace("VBI.MapManager: onLoad  "+i.src);var c=true;for(var a=i.m_Prev;a!=null;a=a.m_Prev)c&=a.complete;for(var a=i.m_Next;a!=null;a=a.m_Next)c&=a.complete;if(!c){VBI.m_bTrace&&VBI.Trace("VBI.MapManager: onLoad skip due there is a a not yet loaded tile ");return}m.RenderTile(i)};m.RenderTile=function(i){var c=i.m_Target.getContext('2d');var n=nMaxY=(1<<c.canvas.m_nCurrentLOD);var a=((i.m_nReqX-c.canvas.m_nCurrentX)%n+n)%n;if(n<i.m_Target.m_Scene.m_nTilesX)a=i.m_nCol-i.m_nXOrigin+c.canvas.m_nCurrentX;var b=i.m_nReqY-c.canvas.m_nCurrentY;if(i.m_bOutdated||(a<0)||(b<0)||(a>=i.m_numCol)||(b>=i.m_numRow)||(i.m_nLOD!=c.canvas.m_nCurrentLOD)){UnlinkImage(i);VBI.m_bTrace&&VBI.Trace("VBI.MapManager: RenderTile  "+i.src+" is outdated");return}VBI.m_bTrace&&VBI.Trace("VBI.MapManager: RenderTile  "+i.src);var d=i.m_Target.getPixelWidth();var e=i.m_Target.getPixelHeight();var f=i.m_Target.m_Scene.m_nWidthCanvas;var g=i.m_Target.m_Scene.m_nHeightCanvas;i.m_Target.setPixelWidth(f);i.m_Target.setPixelHeight(g);var t=f/i.m_numCol;var h=g/i.m_numRow;var l=a*t;var j=b*h;var k=i;while(k.m_Prev!=null)k=k.m_Prev;while(k!=null&&k.complete==true){k.onload=null;k.onabort=null;k.onerror=null;if(k.m_FillStyle!=null){VBI.m_bTrace&&VBI.Trace("RenderTile fillRect "+k.src);var o=c.fillStyle;c.fillStyle=k.m_FillStyle;c.fillRect(l,j,t,h);c.fillStyle=o}VBI.m_bTrace&&VBI.Trace("RenderTile drawImage "+k.src);c.globalAlpha=k.m_Opacity;c.drawImage(k,l,j,t,h);if(k.m_Next!=null)k.m_Next.m_Prev=null;k=k.m_Next}if(VBI.m_bTrace){var o=c.fillStyle;c.fillStyle="#FF0000";c.font="18px Arial";c.fillText(i.m_nRequest+"."+i.m_nCount+":"+i.m_nReqX+"/"+i.m_nReqY+"@("+l+","+j+")",l+10,j+30);c.fillStyle=o}i.m_Target.setPixelWidth(d);i.m_Target.setPixelHeight(e);if(i.m_Target.onTileLoaded)i.m_Target.onTileLoaded(i);c.globalAlpha=1.0};m.RequestTiles=function(t,a,x,y,n,b,l,c,r,d,e,f){var g=0;var h=(1<<e);if(e<0)return;if(f){var j=t.getContext("2d");j.fillStyle='white';j.clearRect(0,0,j.canvas.width,j.canvas.height)}var o=a.m_MapLayerArray;t.m_nRequest=m.m_nRequest++;t.m_nCurrentX=x;t.m_nCurrentY=y;t.m_nCurrentLOD=e;var p=n-l-r;var q=b-c-d;for(var i=0;i<p;++i){for(var k=0;k<q;++k){g++;var u=null;var v=null;var w=(x+l+i)%h;if(w<0)w=h+w;var z=y+c+k;if(z<0||z>=h)continue;for(var s=0;s<o.length;++s){var A=o[s];if(A.fillStyle)v=A.fillStyle;if(A.GetMinLOD()>e)continue;if(A.GetMaxLOD()<e)continue;var B=new Image();B.m_nXOrigin=x;B.m_nCol=i+l;B.m_nRow=k+c;B.m_numCol=n;B.m_numRow=b;B.m_Target=t;B.m_nRequest=t.m_nRequest;B.m_Opacity=A.m_fOpacity;B.m_bOutdated=false;B.m_Prev=u;if(u!=null)u.m_Next=B;if(B.m_Prev==null)B.m_FillStyle=v;B.m_nReqX=w;B.m_nReqY=z;B.m_nLOD=e;var C=A.GetMapProvider().CombineUrl(w,z,e);B.onload=m.onLoad;B.onabort=m.onAbort;B.onerror=m.onError;B.src=C;B.m_nCount=g;VBI.m_bTrace&&VBI.Trace("RequestTiles "+C);u=B}}}};return m})();
