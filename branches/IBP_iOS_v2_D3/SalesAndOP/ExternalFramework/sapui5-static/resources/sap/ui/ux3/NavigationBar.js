/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.ux3.NavigationBar");jQuery.sap.require("sap.ui.ux3.library");jQuery.sap.require("sap.ui.core.Control");sap.ui.core.Control.extend("sap.ui.ux3.NavigationBar",{metadata:{publicMethods:["setAssociatedItems","isSelectedItemValid"],library:"sap.ui.ux3",properties:{"toplevelVariant":{type:"boolean",group:"Misc",defaultValue:false},"visible":{type:"boolean",group:"Appearance",defaultValue:true}},defaultAggregation:"items",aggregations:{"items":{type:"sap.ui.ux3.NavigationItem",multiple:true,singularName:"item"},"overflowMenu":{type:"sap.ui.commons.Menu",multiple:false,visibility:"hidden"}},associations:{"selectedItem":{type:"sap.ui.ux3.NavigationItem",multiple:false},"associatedItems":{type:"sap.ui.ux3.NavigationItem",multiple:true,singularName:"associatedItem"}},events:{"select":{allowPreventDefault:true}}}});sap.ui.ux3.NavigationBar.M_EVENTS={'select':'select'};jQuery.sap.require("sap.ui.core.delegate.ItemNavigation");jQuery.sap.require("jquery.sap.dom");sap.ui.ux3.NavigationBar.SCROLL_STEP=250;
sap.ui.ux3.NavigationBar.prototype.init=function(){this._bPreviousScrollForward=false;this._bPreviousScrollBack=false;this._iLastArrowPos=-100;this._bRtl=sap.ui.getCore().getConfiguration().getRTL();this.allowTextSelection(false);this.startScrollX=0;this.startTouchX=0;var t=this;this._oItemNavigation=new sap.ui.core.delegate.ItemNavigation().setCycling(false);this.addDelegate(this._oItemNavigation);if(jQuery.sap.touchEventMode==="ON"){var T=function(e){e.preventDefault();if(t._iInertiaIntervalId){window.clearInterval(t._iInertiaIntervalId)}t.startScrollX=jQuery.sap.domById(t.getId()+"-list").scrollLeft;t.startTouchX=e.touches[0].pageX;t._bTouchNotMoved=true;t._lastMoveTime=new Date().getTime()};var f=function(e){var d=e.touches[0].pageX-t.startTouchX;var l=jQuery.sap.domById(t.getId()+"-list");var o=l.scrollLeft;var n=t.startScrollX-d;l.scrollLeft=n;t._bTouchNotMoved=false;var b=new Date().getTime()-t._lastMoveTime;t._lastMoveTime=new Date().getTime();if(b>0){t._velocity=(n-o)/b}e.preventDefault()};var a=function(e){if(t._bTouchNotMoved===false){e.preventDefault();var l=jQuery.sap.domById(t.getId()+"-list");var d=50;var b=Math.abs(t._velocity/10);t._iInertiaIntervalId=window.setInterval(function(){t._velocity=t._velocity*0.80;var c=t._velocity*d;l.scrollLeft=l.scrollLeft+c;if(Math.abs(t._velocity)<b){window.clearInterval(t._iInertiaIntervalId);t._iInertiaIntervalId=undefined}},d)}else if(t._bTouchNotMoved===true){t.onclick(e);e.preventDefault()}else{}t._bTouchNotMoved=undefined;t._lastMoveTime=undefined};this.ontouchstart=T;this.ontouchend=a;this.ontouchmove=f}};
sap.ui.ux3.NavigationBar.prototype.exit=function(){if(this._oItemNavigation){this.removeDelegate(this._oItemNavigation);this._oItemNavigation.destroy();delete this._oItemNavigation}};
sap.ui.ux3.NavigationBar.prototype.onBeforeRendering=function(){if(this._checkOverflowIntervalId){jQuery.sap.clearIntervalCall(this._checkOverflowIntervalId);this._checkOverflowIntervalId=null}if(!!sap.ui.Device.browser.firefox){this.$().unbind("DOMMouseScroll",this._handleScroll)}else{this.$().unbind("mousewheel",this._handleScroll)}var a=jQuery.sap.domById(this.getId()+"-arrow");this._iLastArrowPos=a?parseInt(this._bRtl?a.style.right:a.style.left,10):-100};
sap.ui.ux3.NavigationBar.prototype._calculatePositions=function(){var i=this.getId();var d=jQuery.sap.domById(i);var l=d.firstChild;var o=jQuery.sap.domById(i+"-ofb");var a=jQuery.sap.domById(i+"-off");this._bPreviousScrollForward=false;this._bPreviousScrollBack=false;this._checkOverflow(this.getDomRef().firstChild,jQuery.sap.domById(i+"-ofb"),jQuery.sap.domById(i+"-off"));var s=sap.ui.getCore().byId(this.getSelectedItem());if(s){this._checkOverflow(l,o,a);var A=jQuery.sap.byId(this.getId()+"-arrow");var b=A.outerWidth();var t=sap.ui.ux3.NavigationBar._getArrowTargetPos(s.getId(),b,this._bRtl);if(!this._bRtl){A[0].style.left=t+"px"}else{A[0].style.right=t+"px"}}};
sap.ui.ux3.NavigationBar.prototype.onThemeChanged=function(){if(this.getDomRef()){this._calculatePositions()}};
sap.ui.ux3.NavigationBar.prototype.onAfterRendering=function(){var i=this.getId();var d=jQuery.sap.domById(i);var l=d.firstChild;var o=jQuery.sap.domById(i+"-ofb");var a=jQuery.sap.domById(i+"-off");this._checkOverflowIntervalId=jQuery.sap.intervalCall(350,this,"_checkOverflow",[l,o,a]);if(!!sap.ui.Device.browser.firefox){jQuery(d).bind("DOMMouseScroll",jQuery.proxy(this._handleScroll,this))}else{jQuery(d).bind("mousewheel",jQuery.proxy(this._handleScroll,this))}this._calculatePositions();this._updateItemNavigation();var n=this.$();n.on("scroll",function(){n.children().scrollTop(0);n.scrollTop(0)})};
sap.ui.ux3.NavigationBar.prototype._updateItemNavigation=function(){var d=this.getDomRef();if(d){var s=-1;var S=this.getSelectedItem();var i=jQuery(d).children().children("li").children().not(".sapUiUx3NavBarDummyItem");i.each(function(a,e){if(e.id==S){s=a}});this._oItemNavigation.setRootDomRef(d);this._oItemNavigation.setItemDomRefs(i.toArray());this._oItemNavigation.setSelectedIndex(s)}};
sap.ui.ux3.NavigationBar.prototype.onsapspace=function(e){this._handleActivation(e)};
sap.ui.ux3.NavigationBar.prototype.onclick=function(e){this._handleActivation(e)};
sap.ui.ux3.NavigationBar.prototype._handleActivation=function(e){var t=e.target.id;if(t){var i=this.getId();e.preventDefault();if(t==i+"-ofb"){this._scroll(-sap.ui.ux3.NavigationBar.SCROLL_STEP,500)}else if(t==i+"-off"){this._scroll(sap.ui.ux3.NavigationBar.SCROLL_STEP,500)}else if(t==i+"-oflt"||t==i+"-ofl"){this._showOverflowMenu()}else{var a=sap.ui.getCore().byId(t);if(a&&(t!=this.getSelectedItem())&&(sap.ui.getCore().byId(t)instanceof sap.ui.ux3.NavigationItem)){if(this.fireSelect({item:a,itemId:t})){this.setAssociation("selectedItem",a,true);this._updateSelection(t)}}}}};
sap.ui.ux3.NavigationBar.prototype._getOverflowMenu=function(){var m=this.getAggregation("overflowMenu");if(!m||this._menuInvalid){if(m){m.destroyAggregation("items",true)}else{m=new sap.ui.commons.Menu()}var I=this._getCurrentItems();var t=this;var s=this.getSelectedItem();for(var i=0;i<I.length;++i){var n=I[i];var M=new sap.ui.commons.MenuItem(n.getId()+"-overflowItem",{text:n.getText(),visible:n.getVisible(),icon:s==n.getId()?"sap-icon://accept":null,select:(function(n){return function(e){t._handleActivation({target:{id:n.getId()},preventDefault:function(){}})}})(n)});m.addAggregation("items",M,true)}this.setAggregation("overflowMenu",m,true);this._menuInvalid=false}return m};
sap.ui.ux3.NavigationBar.prototype._getCurrentItems=function(){var I=this.getItems();if(I.length<1){I=this.getAssociatedItems();var c=sap.ui.getCore();for(var i=0;i<I.length;++i){I[i]=c.byId(I[i])}}return I};
sap.ui.ux3.NavigationBar.prototype._showOverflowMenu=function(){var m=this._getOverflowMenu();var t=jQuery.sap.byId(this.getId()+"-ofl").get(0);m.open(true,t,sap.ui.core.Popup.Dock.EndTop,sap.ui.core.Popup.Dock.CenterCenter,t)};
sap.ui.ux3.NavigationBar.prototype._updateSelection=function(i){this._menuInvalid=true;var $=jQuery.sap.byId(i);$.attr("tabindex","0").attr("aria-checked","true");$.parent().addClass("sapUiUx3NavBarItemSel");$.parent().parent().children().each(function(){var a=this.firstChild;if(a&&(a.id!=i)&&(a.className.indexOf("Dummy")==-1)){jQuery(a).attr("tabindex","-1");jQuery(a).parent().removeClass("sapUiUx3NavBarItemSel");jQuery(a).attr("aria-checked","false")}});var s=$.parent().index();if(s>0){s--}this._oItemNavigation.setSelectedIndex(s);var A=jQuery.sap.byId(this.getId()+"-arrow");var b=A.outerWidth();var t=sap.ui.ux3.NavigationBar._getArrowTargetPos(i,b,this._bRtl);A.stop();var c=this._bRtl?{right:t+"px"}:{left:t+"px"};A.animate(c,500,"linear");var d=this;window.setTimeout(function(){t=sap.ui.ux3.NavigationBar._getArrowTargetPos(i,b,d._bRtl);A.stop();var a=d._bRtl?{right:t+"px"}:{left:t+"px"};A.animate(a,200,"linear",function(){var e=jQuery.sap.domById(i);d._scrollItemIntoView(e)})},300)};
sap.ui.ux3.NavigationBar.prototype._scrollItemIntoView=function(i){if(!i){return}var l=jQuery(i.parentNode);var u=l.parent();var t=undefined;var r=sap.ui.getCore().getConfiguration().getRTL();var a=l.index()-1;if(a==0){t=r?(u[0].scrollWidth-u.innerWidth()+20):0}else if(a==l.siblings().length-2){t=r?0:(u[0].scrollWidth-u.innerWidth()+20)}else{var b=l.position().left;var c=r?u.scrollLeftRTL():u.scrollLeft();if(b<0){t=c+b}else{var d=u.innerWidth()-(b+l.outerWidth(true));if(d<0){t=c-d;t=Math.min(t,c+b)}}}if(t!==undefined){if(r){t=jQuery.sap.denormalizeScrollLeftRTL(t,u.get(0))}u.stop(true,true).animate({scrollLeft:t})}};
sap.ui.ux3.NavigationBar._getArrowTargetPos=function(t,a,r){var i=jQuery.sap.byId(t);if(i.length>0){var w=i.outerWidth();var l=Math.round(i[0].offsetLeft+(w/2)-(a/2));if(!r){return l}else{return i.parent().parent().innerWidth()-l-a}}else{return-100}};
sap.ui.ux3.NavigationBar.prototype._handleScroll=function(e){if(e.type=="DOMMouseScroll"){var s=e.originalEvent.detail*40;this._scroll(s,50)}else{var s=-e.originalEvent.wheelDelta;this._scroll(s,50)}e.preventDefault()};
sap.ui.ux3.NavigationBar.prototype._scroll=function(d,D){var o=this.$()[0].firstChild;var s=o.scrollLeft;if(!!!sap.ui.Device.browser.internet_explorer&&this._bRtl){d=-d}var S=s+d;jQuery(o).stop(true,true).animate({scrollLeft:S},D)};
sap.ui.ux3.NavigationBar.prototype._checkOverflow=function(l,o,a){if(l){var s=l.scrollLeft;var S=false;var b=false;var r=l.scrollWidth;var c=l.clientWidth;if(Math.abs(r-c)==1){r=c}if(!this._bRtl){if(s>0){S=true}if((r>c)&&(s+c<r)){b=true}}else{var L=jQuery(l);if(L.scrollLeftRTL()>0){b=true}if(L.scrollRightRTL()>0){S=true}}if((b!=this._bPreviousScrollForward)||(S!=this._bPreviousScrollBack)){this._bPreviousScrollForward=b;this._bPreviousScrollBack=S;this.$().toggleClass("sapUiUx3NavBarScrollBack",S).toggleClass("sapUiUx3NavBarScrollForward",b)}}};
sap.ui.ux3.NavigationBar.prototype.setSelectedItem=function(i){this.setAssociation("selectedItem",i,true);if(this.getDomRef()){var I=(!i||(typeof(i)=="string"))?i:i.getId();this._updateSelection(I)}};
sap.ui.ux3.NavigationBar.prototype.addItem=function(i){this._menuInvalid=true;return this.addAggregation("items",i)};
sap.ui.ux3.NavigationBar.prototype.destroyItems=function(){this._menuInvalid=true;return this.destroyAggregation("items")};
sap.ui.ux3.NavigationBar.prototype.insertItem=function(i,I){this._menuInvalid=true;return this.insertAggregation("items",i,I)};
sap.ui.ux3.NavigationBar.prototype.removeItem=function(i){this._menuInvalid=true;return this.removeAggregation("items",i)};
sap.ui.ux3.NavigationBar.prototype.removeAllItems=function(){this._menuInvalid=true;return this.removeAllAggregation("items")};
sap.ui.ux3.NavigationBar.prototype.addAssociatedItem=function(i){this._menuInvalid=true;return this.addAssociation("associatedItems",i)};
sap.ui.ux3.NavigationBar.prototype.removeAssociatedItem=function(i){this._menuInvalid=true;return this.removeAssociation("associatedItems",i)};
sap.ui.ux3.NavigationBar.prototype.removeAllAssociatedItems=function(){this._menuInvalid=true;return this.removeAllAssociation("associatedItems")};
sap.ui.ux3.NavigationBar.prototype.setAssociatedItems=function(I){var l=jQuery.sap.domById(this.getId()+"-list");this.removeAllAssociation("associatedItems",true);for(var i=0;i<I.length;i++){this.addAssociation("associatedItems",I[i],true)}if(l){var f=jQuery(l).find(":focus");var a=(f.length>0)?f.attr("id"):null;if(arguments.length>1&&typeof arguments[1]==="boolean"){this._iLastArrowPos=-100}else{var b=jQuery.sap.domById(this.getId()+"-arrow");this._iLastArrowPos=parseInt(this._bRtl?b.style.right:b.style.left,10)}l.innerHTML="";var r=sap.ui.getCore().createRenderManager();sap.ui.ux3.NavigationBarRenderer.renderItems(r,this);r.flush(l,true);r.destroy();var n;if(a&&(n=jQuery.sap.domById(a))){jQuery.sap.focus(n)}this._updateSelection(this.getSelectedItem());this._updateItemNavigation()}return this};
sap.ui.ux3.NavigationBar.prototype.isSelectedItemValid=function(){var s=this.getSelectedItem();if(!s){return false}var a=this.getItems();if(!a||a.length==0){a=this.getAssociatedItems();for(var i=0;i<a.length;i++){if(a[i]==s){return true}}}else{for(var i=0;i<a.length;i++){if(a[i].getId()==s){return true}}}return false};
