/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */

/* ----------------------------------------------------------------------------------
 * Hint: This is a derived (generated) file. Changes should be done in the underlying 
 * source files only (*.control, *.js) or they will be lost after the next generation.
 * ---------------------------------------------------------------------------------- */

// Provides control sap.viz.ui5.types.RootContainer.
jQuery.sap.declare("sap.viz.ui5.types.RootContainer");
jQuery.sap.require("sap.viz.library");
jQuery.sap.require("sap.viz.ui5.core.BaseStructuredType");


/**
 * Constructor for a new ui5/types/RootContainer.
 * 
 * Accepts an object literal <code>mSettings</code> that defines initial 
 * property values, aggregated and associated objects as well as event handlers. 
 * 
 * If the name of a setting is ambiguous (e.g. a property has the same name as an event), 
 * then the framework assumes property, aggregation, association, event in that order. 
 * To override this automatic resolution, one of the prefixes "aggregation:", "association:" 
 * or "event:" can be added to the name of the setting (such a prefixed name must be
 * enclosed in single or double quotes).
 *
 * The supported settings are:
 * <ul>
 * <li>Properties
 * <ul></ul>
 * </li>
 * <li>Aggregations
 * <ul>
 * <li>{@link #getLayout layout} : sap.viz.ui5.types.RootContainer_layout</li></ul>
 * </li>
 * <li>Associations
 * <ul></ul>
 * </li>
 * <li>Events
 * <ul></ul>
 * </li>
 * </ul> 
 *
 * 
 * In addition, all settings applicable to the base type {@link sap.viz.ui5.core.BaseStructuredType#constructor sap.viz.ui5.core.BaseStructuredType}
 * can be used as well.
 *
 * @param {string} [sId] id for the new control, generated automatically if no id is given 
 * @param {object} [mSettings] initial settings for the new control
 *
 * @class
 * Module ui5/types/RootContainer
 * @extends sap.viz.ui5.core.BaseStructuredType
 *
 * @author  
 * @version 1.16.3
 *
 * @constructor   
 * @public
 * @since 1.7.2
 * @experimental Since version 1.7.2. 
 * Charting API is not finished yet and might change completely
 * @name sap.viz.ui5.types.RootContainer
 */
sap.viz.ui5.core.BaseStructuredType.extend("sap.viz.ui5.types.RootContainer", { metadata : {

	// ---- object ----

	// ---- control specific ----
	library : "sap.viz",
	aggregations : {
    	"layout" : {type : "sap.viz.ui5.types.RootContainer_layout", multiple : false}
	}
}});


/**
 * Creates a new subclass of class sap.viz.ui5.types.RootContainer with name <code>sClassName</code> 
 * and enriches it with the information contained in <code>oClassInfo</code>.
 * 
 * <code>oClassInfo</code> might contain the same kind of informations as described in {@link sap.ui.core.Element.extend Element.extend}.
 *   
 * @param {string} sClassName name of the class to be created
 * @param {object} [oClassInfo] object literal with informations about the class  
 * @param {function} [FNMetaImpl] constructor function for the metadata object. If not given, it defaults to sap.ui.core.ElementMetadata.
 * @return {function} the created class / constructor function
 * @public
 * @static
 * @name sap.viz.ui5.types.RootContainer.extend
 * @function
 */


/**
 * Getter for aggregation <code>layout</code>.<br/>
 * Layout properties
 * 
 * @return {sap.viz.ui5.types.RootContainer_layout}
 * @public
 * @name sap.viz.ui5.types.RootContainer#getLayout
 * @function
 */


/**
 * Setter for the aggregated <code>layout</code>.
 * @param oLayout {sap.viz.ui5.types.RootContainer_layout}
 * @return {sap.viz.ui5.types.RootContainer} <code>this</code> to allow method chaining
 * @public
 * @name sap.viz.ui5.types.RootContainer#setLayout
 * @function
 */
	

/**
 * Destroys the layout in the aggregation 
 * named <code>layout</code>.
 * @return {sap.viz.ui5.types.RootContainer} <code>this</code> to allow method chaining
 * @public
 * @name sap.viz.ui5.types.RootContainer#destroyLayout
 * @function
 */


// Start of sap/viz/ui5/types/RootContainer.js
sap.viz.ui5.types.RootContainer.prototype.getLayout = function() {
  return this._getOrCreate("layout");
}
