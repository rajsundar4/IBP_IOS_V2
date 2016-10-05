/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.ux3.OverlayDialogRenderer");jQuery.sap.require("sap.ui.ux3.OverlayRenderer");jQuery.sap.require("sap.ui.core.Renderer");sap.ui.ux3.OverlayDialogRenderer=sap.ui.core.Renderer.extend(sap.ui.ux3.OverlayRenderer);
sap.ui.ux3.OverlayDialogRenderer.renderContent=function(r,c){var a=r;a.write("<div role='Main' class='sapUiUx3ODContent' id='"+c.getId()+"-content'>");var b=c.getContent();for(var i=0;i<b.length;i++){var d=b[i];a.renderControl(d)}a.write("</div>")};
sap.ui.ux3.OverlayDialogRenderer.addRootClasses=function(r,c){var a=r;a.addClass("sapUiUx3OD")};
sap.ui.ux3.OverlayDialogRenderer.addOverlayClasses=function(r,c){var a=r;a.addClass("sapUiUx3ODOverlay")};
