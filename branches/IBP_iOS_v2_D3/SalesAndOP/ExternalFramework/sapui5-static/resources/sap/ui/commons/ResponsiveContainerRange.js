/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.commons.ResponsiveContainerRange");jQuery.sap.require("sap.ui.commons.library");jQuery.sap.require("sap.ui.core.Control");sap.ui.core.Control.extend("sap.ui.commons.ResponsiveContainerRange",{metadata:{library:"sap.ui.commons",properties:{"width":{type:"sap.ui.core.CSSSize",group:"Dimension",defaultValue:''},"height":{type:"sap.ui.core.CSSSize",group:"Dimension",defaultValue:''},"key":{type:"string",group:"Misc",defaultValue:''}},associations:{"content":{type:"sap.ui.core.Control",multiple:false}}}});
