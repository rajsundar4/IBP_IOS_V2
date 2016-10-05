/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.ux3.Notifier");jQuery.sap.require("sap.ui.ux3.library");jQuery.sap.require("sap.ui.core.Element");sap.ui.core.Element.extend("sap.ui.ux3.Notifier",{metadata:{publicMethods:["hasItems"],library:"sap.ui.ux3",properties:{"icon":{type:"sap.ui.core.URI",group:"Misc",defaultValue:null},"title":{type:"string",group:"Misc",defaultValue:null}},aggregations:{"messages":{type:"sap.ui.core.Message",multiple:true,singularName:"message"},"views":{type:"sap.ui.core.Control",multiple:true,singularName:"view",visibility:"hidden"}},events:{"messageSelected":{}}}});sap.ui.ux3.Notifier.M_EVENTS={'messageSelected':'messageSelected'};jQuery.sap.require("sap.ui.commons.Callout");(function(){var b=function(){this.fireEvent("_childControlCalling",{type:"openCallout",callout:this._oCallout,notifier:this})};var c=function(E){if(E.getSource()){E.getSource().destroyContent()}};sap.ui.ux3.Notifier.prototype.hasItems=function(){if(this.getMessages().length>0){return true}return false};sap.ui.ux3.Notifier.prototype.init=function(){this._oCallout=new sap.ui.commons.Callout(this.getId()+"-callout",{beforeOpen:jQuery.proxy(b,this),open:function(E){this.$().css("position","fixed")},close:jQuery.proxy(c,this),collision:"none"});this._oCallout.addStyleClass("sapUiNotifierCallout");if(sap.ui.Device.browser.mobile){this._oCallout.setOpenDelay(0)}this._oCallout.setMyPosition("begin bottom");this._oCallout.setAtPosition("begin top");this._oCallout.setTip=function(){sap.ui.commons.Callout.prototype.setTip.apply(this,arguments);var $=jQuery.sap.byId(this.getId()+"-arrow");$.css("bottom","-24px");var r=sap.ui.getCore().getConfiguration().getRTL();if(!r){$.css("left","6px")}};this.setTooltip(this._oCallout);this.setTooltip=function(){jQuery.sap.log.warning("Setting toolstips for notifiers deactivated")};this._proxyEnableMessageSelect=jQuery.proxy(e,this);this.attachEvent(sap.ui.base.EventProvider.M_EVENTS.EventHandlerChange,this._proxyEnableMessageSelect)};var e=function(E){var s=E.getParameter("EventId");if(s==="messageSelected"){if(E.getParameter("type")==="listenerAttached"){this._bEnableMessageSelect=true}else if(E.getParameter("type")==="listenerDetached"){this._bEnableMessageSelect=false}this.fireEvent("_enableMessageSelect",{enabled:this._bEnableMessageSelect,notifier:this})}};sap.ui.ux3.Notifier.prototype.exit=function(E){this._oCallout=undefined;if(this._oMessageView){this._oMessageView.destroy();delete this._oMessageView}this.detachEvent(sap.ui.base.EventProvider.M_EVENTS.EventHandlerChange,this._proxyEnableMessageSelect);delete this._proxyEnableMessageSelect};sap.ui.ux3.Notifier.prototype.onclick=function(E){E.preventDefault();this.$().trigger("mouseover")};var f=function(t,m,T){var l=m?m.getLevel():sap.ui.core.MessageType.None;T.fireEvent("_childControlCalling",{type:t,notifier:T,level:l,message:m,callout:T._oCallout})};sap.ui.ux3.Notifier.prototype.addMessage=function(m){this.addAggregation("messages",m);f("added",m,this);return this};sap.ui.ux3.Notifier.prototype.insertMessage=function(m,i){this.insertAggregation("messages",m,i);f("added",m,this);return this};sap.ui.ux3.Notifier.prototype.removeMessage=function(m){var r=this.removeAggregation("messages",m);if(r){f("removed",r,this)}return r};sap.ui.ux3.Notifier.prototype.removeAllMessages=function(){var r=this.removeAllAggregation("messages");if(r.length>0){f("removed",null,this)}return r};sap.ui.ux3.Notifier.prototype.destroyMessages=function(){var l=this.getMessages().length;this.destroyAggregation("messages");if(l>0){f("removed",null,this)}return this}}());
