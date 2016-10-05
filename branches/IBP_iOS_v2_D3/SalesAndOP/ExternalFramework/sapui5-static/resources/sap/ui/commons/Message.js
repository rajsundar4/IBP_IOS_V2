/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.commons.Message");jQuery.sap.require("sap.ui.commons.library");jQuery.sap.require("sap.ui.core.Control");sap.ui.core.Control.extend("sap.ui.commons.Message",{metadata:{deprecated:true,publicMethods:["bindDetails"],library:"sap.ui.commons",properties:{"type":{type:"sap.ui.commons.MessageType",group:"Behavior",defaultValue:null},"text":{type:"string",group:"Data",defaultValue:null},"associatedElementId":{type:"string",group:"Data",defaultValue:null},"design":{type:"string",group:"Misc",defaultValue:null}}}});jQuery.sap.require("sap.ui.commons.Dialog");
sap.ui.commons.Message.prototype.init=function(){this.isRTL=sap.ui.getCore().getConfiguration().getRTL();this.fnCallBack=null;this.oLink=null;this.oContainer=null;this.oDetails=null;this.oBtnOK=null};
sap.ui.commons.Message.prototype.exit=function(){if(this.oLink){this.oLink.destroy();this.oLink=null}if(this.oDetails){this.oDetails.destroy();this.oDetails=null}if(this.oContainer){this.oContainer.destroy();this.oContainer=null}if(this.oBtnOK){this.oBtnOK.destroy();this.oBtnOK=null}};
sap.ui.commons.Message.closeDetails=function(c){c.getSource().getParent().close()};
sap.ui.commons.Message.prototype.closeDetails=function(){if(this.oContainer){this.oContainer.close()}};
sap.ui.commons.Message.prototype.openDetails=function(){if(!this.oContainer){var r=sap.ui.getCore().getLibraryResourceBundle("sap.ui.commons");var O=r.getText("MSGBAR_DETAILS_DIALOG_CLOSE");var t=r.getText("MSGBAR_DETAILS_DIALOG_TITLE");var h=this.fnCallBack(this.getId());this.oDetails=new sap.ui.commons.Message({type:this.getType(),text:h});this.oBtnOK=new sap.ui.commons.Button({text:O,press:sap.ui.commons.Message.closeDetails});this.oContainer=new sap.ui.commons.Dialog();this.oContainer.addContent(this.oDetails);this.oContainer.setTitle(t);this.oContainer.addButton(this.oBtnOK)}var c=this.oContainer.getId();var o=0;var a=jQuery('.sapUiDlg');for(var i=a.length-1;i>=0;i--){if(jQuery(a[i]).css('visibility')!="visible"){a.splice(i,1)}else if(a[i].id==c){a.splice(i,1)}else{o=Math.max(o,jQuery(a[i]).css('zIndex'))}}var w=this.oContainer.isOpen();this.oContainer.open();var C=this.oContainer.$();var j=C.rect();if(a.length==0){if(this.isRTL){j.left=Number(C.css('right').replace("px",""))}this.setLastOffsets(j);return}if(w){if(o>C.css('zIndex')){C.css('zIndex',o+1)}return}var n=this.getNextOffsets();C.css('top',(n.top-sap.ui.commons.Message.TOP_INCR)+"px");if(this.isRTL){C.css('right',(n.left-sap.ui.commons.Message.LEFT_INCR)+"px")}else{C.css('left',(n.left-sap.ui.commons.Message.LEFT_INCR)+"px")}var j=C.rect();var s=jQuery(window).scrollTop();var b=jQuery(window).scrollLeft();var d=-b;if((jQuery(window).height()+s)<(n.top+j.height)){n.top=s;this.setLastOffsets(n)}if(this.isRTL){if((jQuery(window).width()+d)<(n.left+j.width)){n.left=d;this.setLastOffsets(n)}C.animate({top:n.top+"px",right:n.left+"px"},200)}else{if((jQuery(window).width()+b)<(n.left+j.width)){n.left=b;this.setLastOffsets(n)}C.animate({top:n.top+"px",left:n.left+"px"},200)}};
sap.ui.commons.Message.TOP_INCR=20;sap.ui.commons.Message.LEFT_INCR=10;(function(){var l=null;sap.ui.commons.Message.setLastOffsets=function(o){l=o};sap.ui.commons.Message.prototype.setLastOffsets=function(o){sap.ui.commons.Message.setLastOffsets(o)};sap.ui.commons.Message.getNextOffsets=function(){l.top+=sap.ui.commons.Message.TOP_INCR;l.left+=sap.ui.commons.Message.LEFT_INCR;return l};sap.ui.commons.Message.prototype.getNextOffsets=function(){return sap.ui.commons.Message.getNextOffsets()}}());
sap.ui.commons.Message.prototype.bindDetails=function(c){this.fnCallBack=c};
