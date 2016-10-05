/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */

/* ----------------------------------------------------------------------------------
 * Hint: This is a derived (generated) file. Changes should be done in the underlying 
 * source files only (*.control, *.js) or they will be lost after the next generation.
 * ---------------------------------------------------------------------------------- */

// Provides control sap.ui.richtexteditor.RichTextEditor.
jQuery.sap.declare("sap.ui.richtexteditor.RichTextEditor");
jQuery.sap.require("sap.ui.richtexteditor.library");
jQuery.sap.require("sap.ui.core.Control");


/**
 * Constructor for a new RichTextEditor.
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
 * <ul>
 * <li>{@link #getValue value} : string (default: '')</li>
 * <li>{@link #getTextDirection textDirection} : sap.ui.core.TextDirection (default: sap.ui.core.TextDirection.Inherit)</li>
 * <li>{@link #getWidth width} : sap.ui.core.CSSSize</li>
 * <li>{@link #getHeight height} : sap.ui.core.CSSSize</li>
 * <li>{@link #getEditorType editorType} : string (default: 'TinyMCE')</li>
 * <li>{@link #getEditorLocation editorLocation} : string (default: 'js/tiny_mce/tiny_mce_src.js')</li>
 * <li>{@link #getEditable editable} : boolean (default: true)</li>
 * <li>{@link #getShowGroupFontStyle showGroupFontStyle} : boolean (default: true)</li>
 * <li>{@link #getShowGroupTextAlign showGroupTextAlign} : boolean (default: true)</li>
 * <li>{@link #getShowGroupStructure showGroupStructure} : boolean (default: true)</li>
 * <li>{@link #getShowGroupFont showGroupFont} : boolean (default: false)</li>
 * <li>{@link #getShowGroupClipboard showGroupClipboard} : boolean (default: true)</li>
 * <li>{@link #getShowGroupInsert showGroupInsert} : boolean (default: false)</li>
 * <li>{@link #getShowGroupLink showGroupLink} : boolean (default: false)</li>
 * <li>{@link #getShowGroupUndo showGroupUndo} : boolean (default: false)</li>
 * <li>{@link #getWrapping wrapping} : boolean (default: true)</li>
 * <li>{@link #getRequired required} : boolean (default: false)</li>
 * <li>{@link #getSanitizeValue sanitizeValue} : boolean (default: true)</li></ul>
 * </li>
 * <li>Aggregations
 * <ul></ul>
 * </li>
 * <li>Associations
 * <ul></ul>
 * </li>
 * <li>Events
 * <ul>
 * <li>{@link sap.ui.richtexteditor.RichTextEditor#event:change change} : fnListenerFunction or [fnListenerFunction, oListenerObject] or [oData, fnListenerFunction, oListenerObject]</li>
 * <li>{@link sap.ui.richtexteditor.RichTextEditor#event:ready ready} : fnListenerFunction or [fnListenerFunction, oListenerObject] or [oData, fnListenerFunction, oListenerObject]</li></ul>
 * </li>
 * </ul> 

 *
 * @param {string} [sId] id for the new control, generated automatically if no id is given 
 * @param {object} [mSettings] initial settings for the new control
 *
 * @class
 * The RichTextEditor-Control is used to enter formatted text.
 * @extends sap.ui.core.Control
 *
 * @author SAP AG 
 * @version 1.16.3
 *
 * @constructor   
 * @public
 * @disclaimer Since version 1.6.0. 
 * The RichTextEditor of SAPUI5 contains a third party component TinyMCE provided by Moxiecode Systems AB. The SAP license agreement does not cover development of own applications with RichTextEditor of SAPUI5. To develop own applications with RichTextEditor of SAPUI5 a customer/partner has to first obtain an appropriate license from Moxiecode Systems AB. To prevent accidental usage, the TinyMCE code cannot be used directly starting with SAPUI5 version 1.8.
 * @name sap.ui.richtexteditor.RichTextEditor
 */
sap.ui.core.Control.extend("sap.ui.richtexteditor.RichTextEditor", { metadata : {

	// ---- object ----
	publicMethods : [
		// methods
		"getNativeApi"
	],

	// ---- control specific ----
	library : "sap.ui.richtexteditor",
	properties : {
		"value" : {type : "string", group : "Data", defaultValue : ''},
		"textDirection" : {type : "sap.ui.core.TextDirection", group : "Appearance", defaultValue : sap.ui.core.TextDirection.Inherit},
		"width" : {type : "sap.ui.core.CSSSize", group : "Dimension", defaultValue : null},
		"height" : {type : "sap.ui.core.CSSSize", group : "Dimension", defaultValue : null},
		"editorType" : {type : "string", group : "Misc", defaultValue : 'TinyMCE'},
		"editorLocation" : {type : "string", group : "Misc", defaultValue : 'js/tiny_mce/tiny_mce_src.js'},
		"editable" : {type : "boolean", group : "Misc", defaultValue : true},
		"showGroupFontStyle" : {type : "boolean", group : "Misc", defaultValue : true},
		"showGroupTextAlign" : {type : "boolean", group : "Misc", defaultValue : true},
		"showGroupStructure" : {type : "boolean", group : "Misc", defaultValue : true},
		"showGroupFont" : {type : "boolean", group : "Misc", defaultValue : false},
		"showGroupClipboard" : {type : "boolean", group : "Misc", defaultValue : true},
		"showGroupInsert" : {type : "boolean", group : "Misc", defaultValue : false},
		"showGroupLink" : {type : "boolean", group : "Misc", defaultValue : false},
		"showGroupUndo" : {type : "boolean", group : "Misc", defaultValue : false},
		"wrapping" : {type : "boolean", group : "Appearance", defaultValue : true},
		"required" : {type : "boolean", group : "Misc", defaultValue : false},
		"sanitizeValue" : {type : "boolean", group : "Misc", defaultValue : true}
	},
	events : {
		"change" : {}, 
		"ready" : {}
	}
}});


/**
 * Creates a new subclass of class sap.ui.richtexteditor.RichTextEditor with name <code>sClassName</code> 
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
 * @name sap.ui.richtexteditor.RichTextEditor.extend
 * @function
 */

sap.ui.richtexteditor.RichTextEditor.M_EVENTS = {'change':'change','ready':'ready'};


/**
 * Getter for property <code>value</code>.
 * An HTML string representing the editor content. Because this is HTML, the value cannot be generically escaped to prevent cross-site scripting, so the application is responsible for doing so.
 *
 * Default value is <code>''</code>
 *
 * @return {string} the value of property <code>value</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getValue
 * @function
 */

/**
 * Setter for property <code>value</code>.
 *
 * Default value is <code>''</code> 
 *
 * @param {string} sValue  new value for property <code>value</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setValue
 * @function
 */


/**
 * Getter for property <code>textDirection</code>.
 * The text direction
 *
 * Default value is <code>Inherit</code>
 *
 * @return {sap.ui.core.TextDirection} the value of property <code>textDirection</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getTextDirection
 * @function
 */

/**
 * Setter for property <code>textDirection</code>.
 *
 * Default value is <code>Inherit</code> 
 *
 * @param {sap.ui.core.TextDirection} oTextDirection  new value for property <code>textDirection</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setTextDirection
 * @function
 */


/**
 * Getter for property <code>width</code>.
 * Width of RichTextEditor control in CSS units.
 *
 * Default value is empty/<code>undefined</code>
 *
 * @return {sap.ui.core.CSSSize} the value of property <code>width</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getWidth
 * @function
 */

/**
 * Setter for property <code>width</code>.
 *
 * Default value is empty/<code>undefined</code> 
 *
 * @param {sap.ui.core.CSSSize} sWidth  new value for property <code>width</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setWidth
 * @function
 */


/**
 * Getter for property <code>height</code>.
 * Height of RichTextEditor control in CSS units.
 *
 * Default value is empty/<code>undefined</code>
 *
 * @return {sap.ui.core.CSSSize} the value of property <code>height</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getHeight
 * @function
 */

/**
 * Setter for property <code>height</code>.
 *
 * Default value is empty/<code>undefined</code> 
 *
 * @param {sap.ui.core.CSSSize} sHeight  new value for property <code>height</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setHeight
 * @function
 */


/**
 * Getter for property <code>editorType</code>.
 * The editor implementation to use.
 * Valid values are "TinyMCE" and any other editor identifier that may be introduced by other groups (hence this is not an enumeration).
 * Any attempts to set this property after the first rendering will not have any effect.
 *
 * Default value is <code>'TinyMCE'</code>
 *
 * @return {string} the value of property <code>editorType</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getEditorType
 * @function
 */

/**
 * Setter for property <code>editorType</code>.
 *
 * Default value is <code>'TinyMCE'</code> 
 *
 * @param {string} sEditorType  new value for property <code>editorType</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setEditorType
 * @function
 */


/**
 * Getter for property <code>editorLocation</code>.
 * Relative or absolute URL where the editor is available. Must be on the same server.
 * Any attempts to set this property after the first rendering will not have any effect.
 *
 * Default value is <code>'js/tiny_mce/tiny_mce_src.js'</code>
 *
 * @return {string} the value of property <code>editorLocation</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getEditorLocation
 * @function
 */

/**
 * Setter for property <code>editorLocation</code>.
 *
 * Default value is <code>'js/tiny_mce/tiny_mce_src.js'</code> 
 *
 * @param {string} sEditorLocation  new value for property <code>editorLocation</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setEditorLocation
 * @function
 */


/**
 * Getter for property <code>editable</code>.
 * Whether the editor content can be modified by the user. When set to "false" there might not be any editor toolbar.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>editable</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getEditable
 * @function
 */

/**
 * Setter for property <code>editable</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bEditable  new value for property <code>editable</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setEditable
 * @function
 */


/**
 * Getter for property <code>showGroupFontStyle</code>.
 * Whether the toolbar button group containing commands like Bold, Italic, Underline and Strikethrough is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>showGroupFontStyle</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupFontStyle
 * @function
 */

/**
 * Setter for property <code>showGroupFontStyle</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bShowGroupFontStyle  new value for property <code>showGroupFontStyle</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupFontStyle
 * @function
 */


/**
 * Getter for property <code>showGroupTextAlign</code>.
 * Whether the toolbar button group containing text alignment commands is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>showGroupTextAlign</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupTextAlign
 * @function
 */

/**
 * Setter for property <code>showGroupTextAlign</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bShowGroupTextAlign  new value for property <code>showGroupTextAlign</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupTextAlign
 * @function
 */


/**
 * Getter for property <code>showGroupStructure</code>.
 * Whether the toolbar button group containing commands like Bullets and Indentation is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>showGroupStructure</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupStructure
 * @function
 */

/**
 * Setter for property <code>showGroupStructure</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bShowGroupStructure  new value for property <code>showGroupStructure</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupStructure
 * @function
 */


/**
 * Getter for property <code>showGroupFont</code>.
 * Whether the toolbar button group containing commands like Font, Font Size and Colors is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>false</code>
 *
 * @return {boolean} the value of property <code>showGroupFont</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupFont
 * @function
 */

/**
 * Setter for property <code>showGroupFont</code>.
 *
 * Default value is <code>false</code> 
 *
 * @param {boolean} bShowGroupFont  new value for property <code>showGroupFont</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupFont
 * @function
 */


/**
 * Getter for property <code>showGroupClipboard</code>.
 * Whether the toolbar button group containing commands like Cut, Copy and Paste is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>showGroupClipboard</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupClipboard
 * @function
 */

/**
 * Setter for property <code>showGroupClipboard</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bShowGroupClipboard  new value for property <code>showGroupClipboard</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupClipboard
 * @function
 */


/**
 * Getter for property <code>showGroupInsert</code>.
 * Whether the toolbar button group containing commands like Insert Image and Insert Smiley is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>false</code>
 *
 * @return {boolean} the value of property <code>showGroupInsert</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupInsert
 * @function
 */

/**
 * Setter for property <code>showGroupInsert</code>.
 *
 * Default value is <code>false</code> 
 *
 * @param {boolean} bShowGroupInsert  new value for property <code>showGroupInsert</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupInsert
 * @function
 */


/**
 * Getter for property <code>showGroupLink</code>.
 * Whether the toolbar button group containing commands like Create Link and Remove Link is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>false</code>
 *
 * @return {boolean} the value of property <code>showGroupLink</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupLink
 * @function
 */

/**
 * Setter for property <code>showGroupLink</code>.
 *
 * Default value is <code>false</code> 
 *
 * @param {boolean} bShowGroupLink  new value for property <code>showGroupLink</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupLink
 * @function
 */


/**
 * Getter for property <code>showGroupUndo</code>.
 * Whether the toolbar button group containing commands like Undo and Redo is available. Changing this after the initial rendering will result in some visible redrawing.
 *
 * Default value is <code>false</code>
 *
 * @return {boolean} the value of property <code>showGroupUndo</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getShowGroupUndo
 * @function
 */

/**
 * Setter for property <code>showGroupUndo</code>.
 *
 * Default value is <code>false</code> 
 *
 * @param {boolean} bShowGroupUndo  new value for property <code>showGroupUndo</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setShowGroupUndo
 * @function
 */


/**
 * Getter for property <code>wrapping</code>.
 * Whether the text in the editor is wrapped. This does not affect the editor's value, only the representation in the control.
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>wrapping</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getWrapping
 * @function
 */

/**
 * Setter for property <code>wrapping</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bWrapping  new value for property <code>wrapping</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setWrapping
 * @function
 */


/**
 * Getter for property <code>required</code>.
 * Whether a value is required.
 *
 * Default value is <code>false</code>
 *
 * @return {boolean} the value of property <code>required</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getRequired
 * @function
 */

/**
 * Setter for property <code>required</code>.
 *
 * Default value is <code>false</code> 
 *
 * @param {boolean} bRequired  new value for property <code>required</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setRequired
 * @function
 */


/**
 * Getter for property <code>sanitizeValue</code>.
 * Whether to run the HTML sanitizer once the value (HTML markup) is applied or not. To configure allowed URLs please use the whitelist API via jQuery.sap.addUrlWhitelist
 *
 * Default value is <code>true</code>
 *
 * @return {boolean} the value of property <code>sanitizeValue</code>
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#getSanitizeValue
 * @function
 */

/**
 * Setter for property <code>sanitizeValue</code>.
 *
 * Default value is <code>true</code> 
 *
 * @param {boolean} bSanitizeValue  new value for property <code>sanitizeValue</code>
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#setSanitizeValue
 * @function
 */


/**
 * Event is fired when the text in the field has changed AND the focus leaves the editor or when the Enter key is pressed. 
 *
 * @name sap.ui.richtexteditor.RichTextEditor#change
 * @event
 * @param {sap.ui.base.Event} oControlEvent
 * @param {sap.ui.base.EventProvider} oControlEvent.getSource
 * @param {object} oControlEvent.getParameters

 * @param {string} oControlEvent.getParameters.newValue The new control value.
 * @public
 */
 
/**
 * Attach event handler <code>fnFunction</code> to the 'change' event of this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/>.
 * When called, the context of the event handler (its <code>this</code>) will be bound to <code>oListener<code> if specified
 * otherwise to this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/> itself. 
 *  
 * Event is fired when the text in the field has changed AND the focus leaves the editor or when the Enter key is pressed. 
 *
 * @param {object}
 *            [oData] An application specific payload object, that will be passed to the event handler along with the event object when firing the event.
 * @param {function}
 *            fnFunction The function to call, when the event occurs.  
 * @param {object}
 *            [oListener=this] Context object to call the event handler with. Defaults to this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/> itself.
 *
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#attachChange
 * @function
 */

/**
 * Detach event handler <code>fnFunction</code> from the 'change' event of this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/>
 *
 * The passed function and listener object must match the ones used for event registration.
 *
 * @param {function}
 *            fnFunction The function to call, when the event occurs.
 * @param {object}
 *            oListener Context object on which the given function had to be called.
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#detachChange
 * @function
 */

/**
 * Fire event change to attached listeners.
 * 
 * Expects following event parameters:
 * <ul>
 * <li>'newValue' of type <code>string</code> The new control value.</li>
 * </ul>
 *
 * @param {Map} [mArguments] the arguments to pass along with the event.
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @protected
 * @name sap.ui.richtexteditor.RichTextEditor#fireChange
 * @function
 */


/**
 * Fired when the used editor is loaded and ready (its HTML is also created). 
 *
 * @name sap.ui.richtexteditor.RichTextEditor#ready
 * @event
 * @param {sap.ui.base.Event} oControlEvent
 * @param {sap.ui.base.EventProvider} oControlEvent.getSource
 * @param {object} oControlEvent.getParameters

 * @public
 */
 
/**
 * Attach event handler <code>fnFunction</code> to the 'ready' event of this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/>.
 * When called, the context of the event handler (its <code>this</code>) will be bound to <code>oListener<code> if specified
 * otherwise to this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/> itself. 
 *  
 * Fired when the used editor is loaded and ready (its HTML is also created). 
 *
 * @param {object}
 *            [oData] An application specific payload object, that will be passed to the event handler along with the event object when firing the event.
 * @param {function}
 *            fnFunction The function to call, when the event occurs.  
 * @param {object}
 *            [oListener=this] Context object to call the event handler with. Defaults to this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/> itself.
 *
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#attachReady
 * @function
 */

/**
 * Detach event handler <code>fnFunction</code> from the 'ready' event of this <code>sap.ui.richtexteditor.RichTextEditor</code>.<br/>
 *
 * The passed function and listener object must match the ones used for event registration.
 *
 * @param {function}
 *            fnFunction The function to call, when the event occurs.
 * @param {object}
 *            oListener Context object on which the given function had to be called.
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @public
 * @name sap.ui.richtexteditor.RichTextEditor#detachReady
 * @function
 */

/**
 * Fire event ready to attached listeners.

 * @param {Map} [mArguments] the arguments to pass along with the event.
 * @return {sap.ui.richtexteditor.RichTextEditor} <code>this</code> to allow method chaining
 * @protected
 * @name sap.ui.richtexteditor.RichTextEditor#fireReady
 * @function
 */


/**
 * Returns the current editor's instance.
 * CAUTION: using the native editor introduces a dependency to that editor and breaks the wrapping character of the RichTextEditor control, so it should only be done in justified cases.
 *
 * @name sap.ui.richtexteditor.RichTextEditor.prototype.getNativeApi
 * @function

 * @type object
 * @public
 */


// Start of sap/ui/richtexteditor/RichTextEditor.js
/*
 * The following code is editor-independent
 */
 
/**
 * Initialization
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.init = function() {
	this._bEditorCreated = false;
	this._callEditorSpecific("init");
};

sap.ui.richtexteditor.RichTextEditor.prototype.onBeforeRendering = function() {
	this._callEditorSpecific("onBeforeRendering");
};

sap.ui.richtexteditor.RichTextEditor.prototype.onAfterRendering = function() {
	this._callEditorSpecific("onAfterRendering");
};

/**
 * After configuration has changed, this method can be used to trigger a complete re-rendering
 * that also re-initializes the editor instance from scratch. Caution: this is expensive, performance-wise!
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.reinitialize = function() {
	this._callEditorSpecific("reinitialize");
};

sap.ui.richtexteditor.RichTextEditor.prototype.getNativeApi = function() {
	return this._callEditorSpecific("getNativeApi");
};

sap.ui.richtexteditor.RichTextEditor.prototype.exit = function() {
	this._callEditorSpecific("exit");
};

sap.ui.richtexteditor.RichTextEditor.prototype.setValue = function(sValue) {
	
	if ( this.getSanitizeValue() ) {
		jQuery.sap.log.trace("sanitizing HTML content for " + this);
		// images are using the URL whitelist support
		sValue = jQuery.sap._sanitizeHTML(sValue);
	}
	
	if(sValue === this.getValue()){
		return this;
	}
	
	this.setProperty("value", sValue, true);
	var methodName = "setValue" + this.getEditorType();
	if (this[methodName] && typeof(this[methodName]) == "function") {
		this[methodName].call(this, sValue);
	} else {
		this.reinitialize();
	}
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype._callEditorSpecific = function(sPrefix) {
	var methodName = sPrefix + this.getEditorType();
	if (this[methodName] && typeof(this[methodName]) == "function") {
		return this[methodName].call(this);
	}
};

// the following setters will work after initial rendering, but can cause a complete re-initialization

sap.ui.richtexteditor.RichTextEditor.prototype.setEditable = function(bEditable) {
	this.setProperty("editable", bEditable, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setWrapping = function(bWrapping) {
	this.setProperty("wrapping", bWrapping, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setRequired = function(bRequired) {
	this.setProperty("required", bRequired, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupFontStyle = function(bShowGroupFontStyle) {
	this.setProperty("showGroupFontStyle", bShowGroupFontStyle, true);
	this.reinitialize();
	return this;
};


sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupTextAlign = function(bShowGroupTextAlign) {
	this.setProperty("showGroupTextAlign", bShowGroupTextAlign, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupStructure = function(bShowGroupStructure) {
	this.setProperty("showGroupStructure", bShowGroupStructure, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupFont = function(bShowGroupFont) {
	this.setProperty("showGroupFont", bShowGroupFont, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupClipboard = function(bShowGroupClipboard) {
	this.setProperty("showGroupClipboard", bShowGroupClipboard, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupInsert = function(bShowGroupInsert) {
	this.setProperty("showGroupInsert", bShowGroupInsert, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupLink = function(bShowGroupLink) {
	this.setProperty("showGroupLink", bShowGroupLink, true);
	this.reinitialize();
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setShowGroupUndo = function(bShowGroupUndo) {
	this.setProperty("showGroupUndo", bShowGroupUndo, true);
	this.reinitialize();
	return this;
};


// the following functions shall not work after the first rendering

sap.ui.richtexteditor.RichTextEditor.prototype.setEditorType = function(sEditorType) {
	if (!this._bEditorCreated) { // only supported before first rendering!
		this.setProperty("editorType", sEditorType);
	}
	return this;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setEditorLocation = function(sEditorLocation) {
	if (!this._bEditorCreated) { // only supported before first rendering!
		this.setProperty("editorLocation", sEditorLocation);
	}
	return this;
};





/************************************************************************
 * What now follows is Editor-dependent code
 * 
 * For other editors create suitable versions of these methods 
 * and attach them to sap.ui.richtexteditor.RichTextEditor.prototype
 ************************************************************************/

//License Key for TinyMCE which must be set by the application: see JSDoc!
sap.ui.richtexteditor.TinyMCELicense = sap.ui.richtexteditor.TinyMCELicense || "";

/**
 * Static initialization for usage of TinyMCE
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.initTinyMCEStatic = function() {
	sap.ui.richtexteditor.RichTextEditor.TinyMCE = {};
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupFontStyle = "bold,italic,underline,strikethrough";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupTextAlign = "justifyleft,justifycenter,justifyright,justifyfull";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupStructure = "bullist,numlist,outdent,indent";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupFont = "fontselect,fontsizeselect,forecolor,backcolor";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupClipboard = "cut,copy,paste";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupEmail = ""; // TODO
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupInsert = "image,emotions";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupLink = "link,unlink";
	sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupUndo = "undo,redo";
	sap.ui.richtexteditor.RichTextEditor.TinyMCEInitialized = true;
};

/**
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.initTinyMCE = function() {
	this.textAreaId = this.getId() + "-textarea";
};

/**
 * Saves the current control data and detaches the editor instance from the DOM element
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.onBeforeRenderingTinyMCE = function() {

};


/**
 * Restores the data and re-attaches the editor instance to the DOM element
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.onAfterRenderingTinyMCE = function() {
	if (!this._bEditorCreated) {
		// first rendering: instantiate the editor
		if(!sap.ui.richtexteditor.RichTextEditorRenderer.bTinyMCELicenseMissing){
			this.initTinyMCEAfterFirstRendering();
		}
		
		var $domRef = this.$();
		// timeout needed since it can't be determined when the correct afterRendering of the 
		// corresponding Popup occured so the Popup-id is added to the DOM-ref
		setTimeout(function(){
			var $pop = $domRef.closest("[data-sap-ui-popup]"); 
			// get the corresponding Popup-id
			var sId = $pop.attr("data-sap-ui-popup");
			if (sId) { 
				// if tinyMCE is within a Popup
				
				// create an own dispatcher to dispatch the open event manually
				var oDispatcher = new window.tinyMCE.util.Dispatcher();
				window.tinyMCE.activeEditor.windowManager.onOpen = oDispatcher;
				
				// add a listener to the dispatcher
				oDispatcher.add(function(oTiny, oFrame, oPopup){
					if (oPopup) {
						// since the focused Popup is always the corresponding iFrame the "ifr" has to be added to the focusable id
						var oObject = {
							id : oPopup.mce_window_id + "_ifr"
						};
						
						// register id of Popup-iFrame to Popup to enable this iFrame as focusable
						var sEventId = "sap.ui.core.Popup.addFocusableContent-" + sId;
						sap.ui.getCore().getEventBus().publish("sap.ui", sEventId, oObject);
					}
				});
				
			}
		}, 0);
	} else {
		// subsequent re-rendering: 
		// the saved content is restored
		this.setContentTinyMCE();

		// re-connect the editor instance to the DOM element 
		if (window.tinymce) {
					tinymce.execCommand('mceAddControl', false, this.textAreaId);
		}
	}
};


/**
 * Initializes the TinyMCE instance
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.initTinyMCEAfterFirstRendering = function() {
	// make sure static initialization has happened
	if (!sap.ui.richtexteditor.RichTextEditor.TinyMCEInitialized) {
		sap.ui.richtexteditor.RichTextEditor.initTinyMCEStatic();
	}
	
	// wait until the script is ready
	if (!window.tinymce) {
		jQuery.sap.delayedCall(10, this, "initTinyMCEAfterFirstRendering"); // "10" to avoid busy waiting
		return;
	}
	this._bEditorCreated = true; // do this as soon as we enter the init code with no chance of return

	// construct the toolbar button strings
	var groupFontStyle = this.getShowGroupFontStyle() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupFontStyle : "";
	var groupTextAlign = this.getShowGroupTextAlign() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupTextAlign : "";
	var groupFont = this.getShowGroupFont() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupFont : "";
	var groupClipboard = this.getShowGroupClipboard() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupClipboard : "";
	var groupStructure = this.getShowGroupStructure() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupStructure : "";
	var groupInsert = this.getShowGroupInsert() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupInsert : "";
	var groupLink = this.getShowGroupLink() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupLink : "";
	var groupUndo = this.getShowGroupUndo() ? sap.ui.richtexteditor.RichTextEditor.TinyMCE.GroupUndo : "";
	
	// clean up the toolbar button strings
	var advanced_buttons1 = groupFontStyle + ",|," + groupTextAlign + ",|," + groupFont;
	advanced_buttons1 = advanced_buttons1.replace(/,(,)+/g, ",").replace(/\|(,\|)+/g, "|").replace(/^,?\|,/, "").replace(/,\|,?$/, "");
	var advanced_buttons2 = groupClipboard + ",|," + groupStructure + ",|," + groupUndo + ",|," + groupInsert + ",|," + groupLink;
	advanced_buttons2 = advanced_buttons2.replace(/,(,)+/g, ",").replace(/\|(,\|)+/g, "|").replace(/^,?\|,/, "").replace(/,\|,?$/, "");
	if (!advanced_buttons1 || advanced_buttons1 == "") {
		advanced_buttons1 = advanced_buttons2;
		advanced_buttons2 = null;
	}
	
	var that = this;
	var sDir = (sap.ui.getCore().getConfiguration().getRTL() ? "rtl" : "ltr");
	
	var oLocale = new sap.ui.core.Locale(sap.ui.getCore().getConfiguration().getLanguage()),
		sLanguage = oLocale.getLanguage();
	if (sLanguage == "zh") {
		sLanguage += "-" + oLocale.getRegion().toLowerCase();
	}
	if (sLanguage == "sh") {
		sLanguage = "sr";
	}
	
	var oConfig = {
		mode : "exact",
		directionality : sDir, /* this only covers the editor content, not the UI */
		elements : this.getId() + '-textarea',
		theme : "advanced",
		language: sLanguage,
		plugins : "emotions,directionality,inlinepopups,tabfocus", /* autosave causes problems with missing selection, maybe after rerendering */
		// Theme options
		theme_advanced_buttons1 : advanced_buttons1,
		theme_advanced_buttons2 : advanced_buttons2,
		theme_advanced_buttons3 : null,
		theme_advanced_buttons4 : null,
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "none",
		onchange_callback : function(oCurrentInst) { 
			var sId = oCurrentInst.editorId.substr(0,oCurrentInst.editorId.lastIndexOf("-"));
			var oRTE = sap.ui.getCore().byId(sId);
			if (oRTE) {
				oRTE.onTinyMCEChange(oCurrentInst);
			} else {
				jQuery.sap.log.error("RichtTextEditor change called for unknown instance: " + sId);
			}
		}
	};
	
	oConfig.readonly = (this.getEditable() ? 0 : 1);
	
	oConfig.nowrap = !this.getWrapping();

	tinymce.init(oConfig);

	this.setContentTinyMCE();
	
	this.initWhenTinyMCEReady();
	
	this._tinyMCEPreserveHandler = function(sChannelId, sEventId, oData) {
		if ((that.getDomRef() && window.tinymce && jQuery(oData.domNode).find(jQuery.sap.byId(that.textAreaId)).length > 0) || (jQuery.sap.byId(that.textAreaId).length == 0)) {
			var inst = that.getNativeApiTinyMCE();
			if (inst) {
				that.setProperty("value", inst.getContent(), true); // required because rerendering newly creates the textarea, where tinymce stored the data
			}
			tinymce.execCommand('mceRemoveControl', false, that.textAreaId);
		}
	};
	
	sap.ui.getCore().getEventBus().subscribe("sap.ui","__preserveContent", this._tinyMCEPreserveHandler);
	sap.ui.getCore().getEventBus().subscribe("sap.ui","__beforePopupClose", this._tinyMCEPreserveHandler);
};


/**
 * Contains initialization code that only can be run once the TinyMCE editor is fully created (=has rendered its HTML)
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.initWhenTinyMCEReady = function() {
	// try later if editor not yet rendered
	if(!this.tinyMCEReady()) {
		jQuery.sap.delayedCall(100, this, "initWhenTinyMCEReady");
		return;
	}

	var inst = this.getNativeApiTinyMCE();
	if (this.getTooltip() && this.getTooltip().length > 0) {
		var sTooltip = jQuery.sap.escapeHTML(this.getTooltip_Text());
		inst.getBody().title = sTooltip;
		jQuery.sap.byId(this.textAreaId + "_ifr").attr("title", sTooltip);
	}

	var tableId = this.textAreaId + "_tbl";
	var $Editor = jQuery.sap.byId(tableId);
	this.$focusables = $Editor.find(":sapFocusable");
	$Editor.bind('keydown', jQuery.proxy(this, "_tinyMCEKeyboardHandler"));
	
	// set certain tooltips that are not configurable  TODO: must be made translatable
	jQuery.sap.byId(this.getId() + "-textarea_fontselect").attr("title", "Font");
	jQuery.sap.byId(this.getId() + "-textarea_fontsizeselect").attr("title", "Font Size");
	
   this.fireReady();
};

/**
 * Called on every keydown
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype._tinyMCEKeyboardHandler = function(event) {
	var key = event['keyCode'];
	switch (key){
  	case jQuery.sap.KeyCodes.TAB: /* 9 */
  		if (!this.$focusables.index(jQuery(event.target)) == 0) { // if not on very first element
	  		var index = this.$focusables.size() - 1; // this element moves the focus into the iframe
	  		this.$focusables.get(index).focus();
  		}
  		break;
  		
  	case jQuery.sap.KeyCodes.ARROW_LEFT:
  	case jQuery.sap.KeyCodes.ARROW_UP:
  		var newIndex = this.$focusables.index(jQuery(event.target)) - 1;
  		if (newIndex == 0) newIndex = this.$focusables.size() - 2;
  		this.$focusables.get(newIndex).focus();
  		break;
  		
  	case jQuery.sap.KeyCodes.ARROW_RIGHT:
  	case jQuery.sap.KeyCodes.ARROW_DOWN:
  		var newIndex = this.$focusables.index(jQuery(event.target)) + 1;
  		if (newIndex == this.$focusables.size() - 1) newIndex = 1;
  		this.$focusables.get(newIndex).focus();
  		break;
	}
};
	

/**
 * Checks whether TinyMCE has rendered its HTML
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.tinyMCEReady = function() {
	var iframeId = this.getId() + "-textarea_ifr";
	var iframe = jQuery.sap.domById(iframeId);
	return (iframe != null && iframe != undefined); // TODO
};

/**
 * TinyMCE-specific value setter that avoids re-rendering
 */
sap.ui.richtexteditor.RichTextEditor.prototype.setValueTinyMCE = function(sValue) {
	if (sValue || sValue == "") {
		if (this._bEditorCreated) { 
			jQuery.sap.byId(this.textAreaId).text(sValue);
			this.setContentTinyMCE();
		} else {
			this.setProperty("value", sValue, true);
			if (this.getDomRef()) {
				jQuery.sap.byId(this.textAreaId).val(sValue);
			}
		}
	}
};

/**
 * Event handler being called when the text in the editor has changed
 */
sap.ui.richtexteditor.RichTextEditor.prototype.onTinyMCEChange = function(oCurrentInst) {
	var oldVal = this.getValue(),
		newVal = oCurrentInst.getContent();
	
	if((oldVal != newVal) && !this.bExiting) {
		this.setProperty("value", newVal, true); // suppress rerendering
		this.fireChange({oldValue:oldVal,newValue:newVal});
	}
};


/**
 * After configuration has changed, this method can be used to trigger a complete re-rendering
 * that also re-initializes the editor instance from scratch. Caution: this is expensive, performance-wise!
 * @private
 */
sap.ui.richtexteditor.RichTextEditor.prototype.reinitializeTinyMCE = function() {
	if (this._bEditorCreated) {
		this._bEditorCreated = false; // need to re-initialize
		this.rerender();
		
		this.setContentTinyMCE();
	}
};

sap.ui.richtexteditor.RichTextEditor.prototype.exitTinyMCE = function() {
	this.bExiting = true;
	if (tinymce) {
		tinymce.execCommand('mceRemoveControl', false, this.textAreaId); // also includes "remove" and "destroy"
	}
	sap.ui.getCore().getEventBus().unsubscribe("sap.ui","__preserveContent", this._tinyMCEPreserveHandler);
	sap.ui.getCore().getEventBus().unsubscribe("sap.ui","__beforePopupClose", this._tinyMCEPreserveHandler);
};

sap.ui.richtexteditor.RichTextEditor.prototype.getNativeApiTinyMCE = function() {
	var inst = tinymce.getInstanceById(this.textAreaId);
	return inst;
};

sap.ui.richtexteditor.RichTextEditor.prototype.setContentTinyMCE = function() {
	var inst = this.getNativeApiTinyMCE(),
		value;
	
	if (inst) {
		value = this.getValue();
		if (value != null) {
			inst.setContent(value);
		}
	}
};