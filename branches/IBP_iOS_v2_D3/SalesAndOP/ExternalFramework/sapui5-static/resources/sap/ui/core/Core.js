/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.core.Core");jQuery.sap.require("jquery.sap.dom");jQuery.sap.require("jquery.sap.events");jQuery.sap.require("jquery.sap.mobile");jQuery.sap.require("jquery.sap.properties");jQuery.sap.require("jquery.sap.resources");jQuery.sap.require("jquery.sap.script");jQuery.sap.require("sap.ui.Global");jQuery.sap.require("sap.ui.base.EventProvider");jQuery.sap.require("sap.ui.base.DataType");jQuery.sap.require("sap.ui.core.Configuration");jQuery.sap.require("sap.ui.core.ElementMetadata");jQuery.sap.require("sap.ui.core.Element");jQuery.sap.require("sap.ui.core.Control");jQuery.sap.require("sap.ui.core.FocusHandler");jQuery.sap.require("sap.ui.core.ResizeHandler");jQuery.sap.require("sap.ui.core.RenderManager");jQuery.sap.require("sap.ui.core.UIArea");jQuery.sap.require("sap.ui.core.ThemeCheck");jQuery.sap.require("sap.ui.core.Component");jQuery.sap.require("sap.ui.core.tmpl.Template");jQuery.sap.require("sap.ui.app.Application");jQuery.sap.require("sap.ui.Device");sap.ui.base.EventProvider.extend("sap.ui.core.Core",{constructor:function(){if(sap.ui.getCore&&sap.ui.getCore()){return sap.ui.getCore()}var t=this,l=jQuery.sap.log,M="sap.ui.core.Core";sap.ui.base.EventProvider.apply(this);this.bBooted=false;this.bInitialized=false;this.aPlugins=[];this.mLibraries={};this.mResourceBundles={};this.mUIAreas={};this.oModels={};this.oEventBus=null;this.oApplication=null;this.mElements={};this.mObjects={"component":{},"template":{}};this.oRootComponent=null;this.aInitListeners=[];this.bInitLegacyLib=false;l.info("Creating Core",null,M);this.oConfiguration=new sap.ui.core.Configuration(this);if(this.oConfiguration["xx-bindingSyntax"]==="complex"){sap.ui.base.ManagedObject.bindingParser=sap.ui.base.BindingParser.complexParser}if(this.oConfiguration["xx-designMode"]==true){sap.ui.base.BindingParser._keepBindingStrings=true}sap.ui.core.ElementMetadata.prototype.register=function(k){t.registerElementClass(k)};sap.ui.core.Element.prototype.register=function(){t.registerElement(this)};sap.ui.core.Element.prototype.deregister=function(){t.deregisterElement(this)};sap.ui.core.Component.prototype.register=function(){t.registerObject(this)};sap.ui.core.Component.prototype.deregister=function(){t.deregisterObject(this)};sap.ui.core.tmpl.Template.prototype.register=function(){t.registerObject(this)};sap.ui.core.tmpl.Template.prototype.deregister=function(){t.deregisterObject(this)};sap.ui.app.Application.prototype.register=function(){t.setApplication(this)};var m=this.oConfiguration.modules;if(this.oConfiguration.getDebug()){m.unshift("sap-ui-debug")}var i=jQuery.inArray("sap.ui.core.library",m);if(i!=0){if(i>0){m.splice(i,1)}m.unshift("sap.ui.core.library")}l.info("Declared modules: "+m,M);var c=window["sap-ui-config"];if(this.oConfiguration.themeRoot){c=c||{};c.themeroots=c.themeroots||{};c.themeroots[this.oConfiguration.getTheme()]=this.oConfiguration.themeRoot}if(c){if(c.themeroots){for(var a in c.themeroots){var d=c.themeroots[a];if(typeof d==="string"){this.setThemeRoot(a,d)}else{for(var e in d){if(e.length>0){this.setThemeRoot(a,[e],d[e])}else{this.setThemeRoot(a,d[e])}}}}}}this.sTheme=this.oConfiguration.getTheme();jQuery(document.documentElement).addClass("sapUiTheme-"+this.sTheme);l.info("Declared theme "+this.sTheme,null,M);if(this.oConfiguration.getRTL()){jQuery(document.documentElement).attr("dir","rtl");l.info("RTL mode activated",null,M)}var $=jQuery("html");var b=sap.ui.Device.browser;var f=b.name;if(f===b.BROWSER.CHROME){jQuery.browser.safari=false;jQuery.browser.chrome=true}else if(f===b.BROWSER.SAFARI){jQuery.browser.safari=true;jQuery.browser.chrome=false;if(b.mobile){f="m"+f}}if(f){jQuery.browser.fVersion=b.version;jQuery.browser.mobile=b.mobile;f=f+Math.floor(b.version);$.attr("data-sap-ui-browser",f);l.debug("Browser-Id: "+f,null,M)}$.attr("data-sap-ui-os",sap.ui.Device.os.name+sap.ui.Device.os.versionStr);var o=null;switch(sap.ui.Device.os.name){case sap.ui.Device.os.OS.IOS:o="sap-ios";break;case sap.ui.Device.os.OS.ANDROID:o="sap-android";break;case sap.ui.Device.os.OS.BLACKBERRY:o="sap-bb";break;case sap.ui.Device.os.OS.WINDOWS_PHONE:o="sap-winphone";break}if(o){$.addClass(o)}if(this.oConfiguration.getWeinreId()){l.info("Starting WEINRE Remote Web Inspector");document.write("<script src=\"");document.write(this.oConfiguration.getWeinreServer()+"/target/target-script-min.js#"+this.oConfiguration.getWeinreId());document.write("\"></script>")}sap.ui.getCore=jQuery.sap.getter(this.getInterface());sap.ui.core.RenderManager.initHTML5Support();this.oRenderManager=new sap.ui.core.RenderManager();var s=jQuery.sap.syncPoint("UI5 Document Ready",function(O,F){t.handleLoad()});var D=s.startTask("document.ready");var C=s.startTask("preload and boot");jQuery(function(){l.trace("document is ready");s.finishTask(D)});var S=jQuery.sap.syncPoint("UI5 Core Preloads and Bootstrap Script",function(O,F){l.trace("Core loaded: open="+O+", failures="+F);t._boot();s.finishTask(C)});var g=this.oConfiguration["xx-bootTask"];if(g){var h=S.startTask("custom boot task");g(function(k){S.finishTask(h,typeof k==="undefined"||k===true)})}var u=new jQuery.sap.Version(this.oConfiguration.getCompatibilityVersion("flexBoxPolyfill"));if(u.compareTo("1.16")>=0){jQuery.support.useFlexBoxPolyfill=false}else if(!jQuery.support.flexBoxLayout&&!jQuery.support.newFlexBoxLayout&&!jQuery.support.ie10FlexBoxLayout){jQuery.support.useFlexBoxPolyfill=true}else{jQuery.support.useFlexBoxPolyfill=false}var B=S.startTask("bootstrap script");this.boot=function(){if(this.bBooted){return}this.bBooted=true;S.finishTask(B)};var p=this.oConfiguration.preload;if(window["sap-ui-debug"]){p=""}if(p==="auto"){p=(window["sap-ui-optimized"]&&!this.oConfiguration['xx-loadAllMode'])?"sync":""}this.oConfiguration.preload=p;if(p==="sync"||p==="async"){var A=p!=="sync";jQuery.each(m,function(i,k){if(k.match(/\.library$/)){jQuery.sap.preloadModules(k+"-preload",A,S)}})}var j=this.oConfiguration.getAppCacheBuster();if(j&&j.length>0){jQuery.sap.require("sap.ui.core.AppCacheBuster");sap.ui.core.AppCacheBuster.boot(S)}},metadata:{publicMethods:["boot","isInitialized","isThemeApplied","attachInitEvent","attachInit","getRenderManager","createRenderManager","getConfiguration","setRoot","createUIArea","getUIArea","getUIDirty","getElementById","getCurrentFocusedControlId","getControl","getComponent","getTemplate","lock","unlock","isLocked","attachEvent","detachEvent","applyChanges","getEventBus","applyTheme","setThemeRoot","attachThemeChanged","detachThemeChanged","getStaticAreaRef","registerPlugin","unregisterPlugin","getLibraryResourceBundle","byId","getLoadedLibraries","loadLibrary","initLibrary","includeLibraryTheme","setModel","getModel","hasModel","isMobile","attachControlEvent","detachControlEvent","attachIntervalTimer","detachIntervalTimer","attachParseError","detachParseError","fireParseError","attachValidationError","detachValidationError","fireValidationError","attachFormatError","detachFormatError","fireFormatError","attachValidationSuccess","detachValidationSuccess","fireValidationSuccess","attachLocalizationChanged","detachLocalizationChanged","attachLibraryChanged","detachLibraryChanged","isStaticAreaRef","createComponent","getRootComponent","getApplication"]}});sap.ui.core.Core.M_EVENTS={ControlEvent:"ControlEvent",UIUpdated:"UIUpdated",ThemeChanged:"ThemeChanged",LocalizationChanged:"localizationChanged",LibraryChanged:"libraryChanged",ValidationError:"validationError",ParseError:"parseError",FormatError:"formatError",ValidationSuccess:"validationSuccess"};
sap.ui.core.Core.prototype._boot=function(){this.lock();var c=this.oConfiguration['xx-preloadLibCss'];if(c.length>0){var a=c[0].slice(0,1)==="!";if(a){c[0]=c[0].slice(1)}if(c[0]==="*"){c.splice(0,1);var p=0;jQuery.each(this.oConfiguration.modules,function(i,b){var m=b.match(/^(.*)\.library$/);if(m){c.splice(p,0,m[1])}})}if(!a){this.includeLibraryTheme("sap-ui-merged",undefined,"?l="+c.join(","))}}var t=this;jQuery.each(this.oConfiguration.modules,function(i,b){var m=b.match(/^(.*)\.library$/);if(m){t.loadLibrary(m[1])}else{jQuery.sap.require(b)}});this.unlock()};
sap.ui.core.Core.prototype.applyTheme=function(t,T){t=this.oConfiguration._normalizeTheme(t,T);if(T){this.setThemeRoot(t,T)}if(t&&this.sTheme!=t){var c=this.sTheme;this._updateThemeUrls(t);this.sTheme=t;this.oConfiguration._setTheme(t);jQuery(document.documentElement).removeClass("sapUiTheme-"+c).addClass("sapUiTheme-"+t);if(this.oThemeCheck){this.oThemeCheck.fireThemeChangedEvent(false,true)}}};
sap.ui.core.Core.prototype._updateThemeUrls=function(t){var a=this,r=this.oConfiguration.getRTL()?"-RTL":"";jQuery("link[id^=sap-ui-theme-]").each(function(){var l=this.id.slice(13),L=this.href.slice(this.href.lastIndexOf("/")+1),s="library",h,p;if((p=l.indexOf("-["))>0){s+=l.slice(p+2,-1);l=l.slice(0,p)}if(L===(s+".css")||L===(s+"-RTL.css")){L=s+r+".css"}h=a._getThemePath(l,t)+L;if(h!=this.href){this.href=h;jQuery(this).removeAttr("sap-ui-ready")}})};
sap.ui.core.Core.prototype._getThemePath=function(l,t){if(this._mThemeRoots){var p=this._mThemeRoots[t+" "+l]||this._mThemeRoots[t];if(p){p=p+l.replace(/\./g,"/")+"/themes/"+t+"/";jQuery.sap.registerModulePath(l+".themes."+t,p);return p}}return jQuery.sap.getModulePath(l+".themes."+t,"/")};
sap.ui.core.Core.prototype.setThemeRoot=function(t,l,T){if(!this._mThemeRoots){this._mThemeRoots={}}if(T===undefined){T=l;l=undefined}T=T+(T.slice(-1)=="/"?"":"/");if(l){for(var i=0;i<l.length;i++){var a=l[i];this._mThemeRoots[t+" "+a]=T}}else{this._mThemeRoots[t]=T}return this};
sap.ui.core.Core.prototype.init=function(){if(this.bInitialized){return}var a=jQuery.sap.log,M="sap.ui.core.Core.init()";this.boot();a.info("Initializing",null,M);this.oFocusHandler=new sap.ui.core.FocusHandler(document.body,this);this.oResizeHandler=new sap.ui.core.ResizeHandler(this);this.oThemeCheck=new sap.ui.core.ThemeCheck(this);a.info("Initialized",null,M);this.bInitialized=true;a.info("Starting Plugins",null,M);this.startPlugins();a.info("Plugins started",null,M);var c=this.oConfiguration;if(c.areas){for(var i=0,l=c.areas.length;i<l;i++){this.createUIArea(c.areas[i])}c.areas=undefined}if(c.onInit){if(typeof c.onInit==="function"){c.onInit()}else{jQuery.sap.globalEval(c.onInit)}c.onInit=undefined}this.oThemeCheck.fireThemeChangedEvent(true);var r=c.getRootComponent();if(r){a.info("Loading Root Component: "+r,null,M);var C=sap.ui.component({name:r});this.oRootComponent=C;var R=c["xx-rootComponentNode"];if(R&&C instanceof sap.ui.core.UIComponent){var o=jQuery.sap.domById(R);if(o){a.info("Creating ComponentContainer for Root Component: "+r,null,M);var b=new sap.ui.core.ComponentContainer({component:C,propagateModel:true});b.placeAt(o)}}}else{var A=c.getApplication();if(A){a.warning("The configuration 'application' is deprecated. Please use the configuration 'component' instead! Please migrate from sap.ui.app.Application to sap.ui.core.Component.");a.info("Loading Application: "+A,null,M);jQuery.sap.require(A);var d=jQuery.sap.getObject(A);var e=new d();}}var g=this.aInitListeners;this.aInitListeners=undefined;if(g&&g.length>0){a.info("Fire Loaded Event",null,M);jQuery.each(g,function(i,f){f()})}this._rerenderAllUIAreas()};
sap.ui.core.Core.prototype.handleLoad=function(){var w=this.isLocked();if(!w){this.lock()}this.init();if(!w){this.unlock()}};
sap.ui.core.Core.prototype.isInitialized=function(){return this.bInitialized};
sap.ui.core.Core.prototype.isThemeApplied=function(){return sap.ui.core.ThemeCheck.themeLoaded};
sap.ui.core.Core.prototype.attachInitEvent=function(f){if(this.aInitListeners){this.aInitListeners.push(f)}};
sap.ui.core.Core.prototype.attachInit=function(f){if(this.aInitListeners){this.aInitListeners.push(f)}else{f()}};
sap.ui.core.Core.prototype.lock=function(){this.bLocked=true};
sap.ui.core.Core.prototype.unlock=function(){this.bLocked=false};
sap.ui.core.Core.prototype.isLocked=function(){return this.bLocked};
sap.ui.core.Core.prototype.getConfiguration=function(){return this.oConfiguration};
sap.ui.core.Core.prototype.getRenderManager=function(){return this.createRenderManager()};
sap.ui.core.Core.prototype.createRenderManager=function(){return(new sap.ui.core.RenderManager()).getInterface()};
sap.ui.core.Core.prototype.getCurrentFocusedControlId=function(){if(!this.isInitialized()){throw new Error("Core must be initialized")}return this.oFocusHandler.getCurrentFocusedControlId()};
sap.ui.core.Core.prototype.loadLibrary=function(l,u){if(!this.mLibraries[l]){var m=l+".library",a;if(u){jQuery.sap.registerModulePath(l,u)}if(this.oConfiguration['xx-loadAllMode']&&!jQuery.sap.isDeclared(m)){a=m+"-all";jQuery.sap.log.debug("load all-in-one file "+a);jQuery.sap.require(a)}else if(this.oConfiguration.preload==='sync'||this.oConfiguration.preload==='async'){jQuery.sap.preloadModules(m+"-preload",false)}jQuery.sap.require(m);if(!this.mLibraries[l]){jQuery.sap.log.warning("library "+l+" didn't initialize itself");this.initLibrary(l)}if(this.oThemeCheck&&this.isInitialized()){this.oThemeCheck.fireThemeChangedEvent(true)}}return this.mLibraries[l]};
sap.ui.core.Core.prototype.createComponent=function(c,u,i,s){if(typeof c==="string"){c={name:c,url:u};if(typeof i==="object"){c.settings=i}else{c.id=i;c.settings=s}}return sap.ui.component(c)};
sap.ui.core.Core.prototype.getRootComponent=function(){return this.oRootComponent};
sap.ui.core.Core.prototype.initLibrary=function(l){var L=typeof l==="string",o=L?{name:l}:l,s=o.name,a=jQuery.sap.log,M="sap.ui.core.Core.initLibrary()";if(L){a.warning("[Deprecated] library "+s+" uses old fashioned initLibrary() call (rebuild with newest generator)")}if(!s||this.mLibraries[s]){return}a.debug("Analyzing Library "+s,null,M);this.mLibraries[s]=o=jQuery.extend({dependencies:[],types:[],interfaces:[],controls:[],elements:[]},o);function r(){var p=jQuery.sap.properties({url:sap.ui.resource(s,"library.properties")});o.version=p.getProperty(s+"[version]");var D=p.getProperty(s+"[dependencies]");a.debug("Required Libraries: "+D,null,M);o.dependencies=(D&&D.split(/[,;| ]/))||[];var k=p.getKeys(),b=/(.+)\.(type|interface|control|element)$/,m;for(var i=0;i<k.length;i++){var E=p.getProperty(k[i]);if(m=E.match(b)){o[m[2]+"s"].push(k[i])}}}if(L){r()}for(var i=0;i<o.dependencies.length;i++){var d=o.dependencies[i];a.debug("resolve Dependencies to "+d,null,M);if(!this.mLibraries[d]){a.warning("Dependency from "+s+" to "+d+" has not been resolved by library itself",null,M);this.loadLibrary(d)}}sap.ui.base.DataType.registerInterfaceTypes(o.interfaces);var e=o.controls.concat(o.elements);for(var i=0;i<e.length;i++){sap.ui.lazyRequire(e[i],"new extend getMetadata")}if(!o.noLibraryCSS&&jQuery.inArray(s,this.oConfiguration['xx-preloadLibCss'])<0){this.includeLibraryTheme(s)}o.sName=o.name;o.aControls=o.controls;if(!jQuery.sap.isDeclared(s+".library")){a.warning("Library Module "+s+".library"+" not loaded automatically",null,M);jQuery.sap.require(s+".library")}this.fireLibraryChanged({name:s,stereotype:"library",operation:"add",metadata:o})};
sap.ui.core.Core.prototype.includeLibraryTheme=function(l,v,q){if((l!="sap.ui.legacy")&&(l!="sap.ui.classic")){if(!v){v=""}var r=(this.oConfiguration.getRTL()?"-RTL":"");var L,s=l+(v.length>0?"-["+v+"]":v);if(l&&l.indexOf(":")==-1){L="library"+v+r}else{L=l.substring(l.indexOf(":")+1)+v;l=l.substring(0,l.indexOf(":"))}var c=this._getThemePath(l,this.sTheme)+L+".css"+(q?q:"");jQuery.sap.log.info("Including "+c+" -  sap.ui.core.Core.includeLibraryTheme()");jQuery.sap.includeStyleSheet(c,"sap-ui-theme-"+s);if(sap.ui.core.theming&&sap.ui.core.theming.Parameters){sap.ui.core.theming.Parameters._addLibraryTheme(c)}}};
sap.ui.core.Core.prototype.getLoadedLibraries=function(){return jQuery.extend({},this.mLibraries)};
sap.ui.core.Core.prototype.setRoot=function(d,c){if(c){c.placeAt(d,"only")}};
sap.ui.core.Core.prototype.createUIArea=function(d){var t=this;if(!d){throw new Error("oDomRef must not be null")}if(typeof(d)==="string"){var i=d;d=jQuery.sap.domById(d);if(!d){throw new Error("DOM element with ID '"+i+"' not found in page, but application tries to insert content.")}}if(!d.id||d.id.length==0){d.id=jQuery.sap.uid()}var I=d.id;if(!this.mUIAreas[I]){this.mUIAreas[I]=new sap.ui.core.UIArea(this,d);jQuery.each(this.oModels,function(n,m){t.mUIAreas[I].oPropagatedProperties.oModels[n]=m});this.mUIAreas[I].propagateProperties(true)}else{this.mUIAreas[I].setRootNode(d)}return this.mUIAreas[I]};
sap.ui.core.Core.prototype.getUIArea=function(o){var i="";if(typeof(o)=="string"){i=o}else{i=o.id}if(i){return this.mUIAreas[i]}return null};
sap.ui.core.Core.prototype.addInvalidatedUIArea=function(u){this.rerenderAllUIAreas()};
sap.ui.core.Core.prototype.getLibraryResourceBundle=function(l,L){l=l||"sap.ui.core";L=L||this.getConfiguration().getLanguage();var k=l+"/"+L;if(!this.mResourceBundles[k]){var u=sap.ui.resource(l,'messagebundle.properties');this.mResourceBundles[k]=jQuery.sap.resources({url:u,locale:L})}return this.mResourceBundles[k]};
sap.ui.core.Core.prototype.rerenderAllUIAreas=function(){if(!this._sRerenderTimer){jQuery.sap.log.info("registering timer for delayed re-rendering");this._sRerenderTimer=jQuery.sap.delayedCall(0,this,"_rerenderAllUIAreas")}};
sap.ui.core.Core.prototype._rerenderAllUIAreas=function(){jQuery.sap.measure.start("rerenderAllUIAreas","Rerendering of all UIAreas");if(this._sRerenderTimer){jQuery.sap.clearDelayedCall(this._sRerenderTimer);this._sRerenderTimer=undefined}var u=false;var U=this.mUIAreas;for(var i in U){u=U[i].rerender()||u}if(u){this.fireUIUpdated()}jQuery.sap.measure.end("rerenderAllUIAreas")};
sap.ui.core.Core.prototype.getUIDirty=function(){return!!this._sRerenderTimer};
sap.ui.core.Core.prototype.attachUIUpdated=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.UIUpdated,f,l)};
sap.ui.core.Core.prototype.detachUIUpdated=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.UIUpdated,f,l)};
sap.ui.core.Core.prototype.fireUIUpdated=function(p){this.fireEvent(sap.ui.core.Core.M_EVENTS.UIUpdated,p)};
sap.ui.core.Core.prototype.attachThemeChanged=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.ThemeChanged,f,l)};
sap.ui.core.Core.prototype.detachThemeChanged=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.ThemeChanged,f,l)};
sap.ui.core.Core.prototype.fireThemeChanged=function(p){jQuery.sap.scrollbarSize(true);if(sap.ui.core.theming&&sap.ui.core.theming.Parameters){sap.ui.core.theming.Parameters.reset(true)}var e=sap.ui.core.Core.M_EVENTS.ThemeChanged;var E=jQuery.Event(e);E.theme=p?p.theme:null;jQuery.each(this.mElements,function(i,o){o._handleEvent(E)});this.fireEvent(e,p)};
sap.ui.core.Core.prototype.attachLocalizationChanged=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.LocalizationChanged,f,l)};
sap.ui.core.Core.prototype.detachLocalizationChanged=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.LocalizationChanged,f,l)};
sap.ui.core.Core.prototype.fireLocalizationChanged=function(c){var t=this,e=sap.ui.core.Core.M_EVENTS.LocalizationChanged,b=jQuery.Event(e,{changes:c}),a=sap.ui.base.ManagedObject._handleLocalizationChange,d=[];jQuery.each(c,function(k,v){d.push(k)});jQuery.sap.log.info("localization settings changed: "+d.join(","),null,"sap.ui.core.Core");jQuery.each(this.oModels,function(N,m){if(m&&m._handleLocalizationChange){m._handleLocalizationChange()}});function n(p){jQuery.each(this.mUIAreas,function(){a.call(this,p)});jQuery.each(this.mObjects["component"],function(){a.call(this,p)});jQuery.each(this.mElements,function(){a.call(this,p)})}n.call(this,1);n.call(this,2);if(c.rtl!=undefined){jQuery(document.documentElement).attr("dir",c.rtl?"rtl":"ltr");this._updateThemeUrls(this.sTheme);jQuery.each(this.mUIAreas,function(){this.invalidate()});jQuery.sap.log.info("RTL mode "+c.rtl?"activated":"deactivated")}jQuery.each(this.mElements,function(i,E){this._handleEvent(b)});this.fireEvent(e,{changes:c})};
sap.ui.core.Core.prototype.attachLibraryChanged=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.LibraryChanged,f,l)};
sap.ui.core.Core.prototype.detachLibraryChanged=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.LibraryChanged,f,l)};
sap.ui.core.Core.prototype.fireLibraryChanged=function(p){this.fireEvent(sap.ui.core.Core.M_EVENTS.LibraryChanged,p)};
sap.ui.core.Core.prototype.applyChanges=function(){this._rerenderAllUIAreas()};
sap.ui.core.Core.prototype.registerElementClass=function(m){var n=m.getName(),l=m.getLibraryName()||"",L=this.mLibraries[l],c=sap.ui.core.Control.prototype.isPrototypeOf(m.getClass().prototype),C=false;if(!L){L=this.mLibraries[l]={dependencies:[],types:[],interfaces:[],controls:[],elements:[]}}if(c){if(jQuery.inArray(n,L.controls)<0){L.controls.push(n);C=true}}else{if(jQuery.inArray(n,L.elements)<0){L.elements.push(n);C=true}}if(C){jQuery.sap.log.debug("Class "+m.getName()+" registered for library "+m.getLibraryName());this.fireLibraryChanged({name:m.getName(),stereotype:m.getStereotype(),operation:"add",metadata:m})}};
sap.ui.core.Core.prototype.registerElement=function(e){var o=this.byId(e.getId());if(o&&o!==e){if(this.oConfiguration.getNoDuplicateIds()){jQuery.sap.log.error("adding element with duplicate id '"+e.getId()+"'");throw new Error("Error: adding element with duplicate id '"+e.getId()+"'")}else{jQuery.sap.log.warning("adding element with duplicate id '"+e.getId()+"'")}}this.mElements[e.getId()]=e};
sap.ui.core.Core.prototype.deregisterElement=function(e){delete this.mElements[e.getId()]};
sap.ui.core.Core.prototype.registerObject=function(o){var i=o.getId(),t=o.getMetadata().getStereotype(),a=this.getObject(t,i);if(a&&a!==o){jQuery.sap.log.error("adding object \""+t+"\" with duplicate id '"+i+"'");throw new Error("Error: adding object \""+t+"\" with duplicate id '"+i+"'")}this.mObjects[t][i]=o};
sap.ui.core.Core.prototype.deregisterObject=function(o){var i=o.getId(),t=o.getMetadata().getStereotype();delete this.mObjects[t][i]};
sap.ui.core.Core.prototype.byId=function(i){return i==null?undefined:this.mElements[i]};
sap.ui.core.Core.prototype.getControl=sap.ui.core.Core.prototype.byId;sap.ui.core.Core.prototype.getElementById=sap.ui.core.Core.prototype.byId;
sap.ui.core.Core.prototype.getObject=function(t,i){return i==null?undefined:this.mObjects[t]&&this.mObjects[t][i]};
sap.ui.core.Core.prototype.getComponent=function(i){return this.getObject("component",i)};
sap.ui.core.Core.prototype.getTemplate=function(i){return this.getObject("template",i)};
sap.ui.core.Core.prototype.getStaticAreaRef=function(){var s="sap-ui-static";var S=jQuery.sap.domById(s);if(!S){var l=this.getConfiguration().getRTL()?"right":"left";S=jQuery("<DIV/>",{id:s}).css("visibility","hidden").css("height","0").css("width","0").css("overflow","hidden").css("float",l).prependTo(document.body)[0];this.createUIArea(S).bInitial=false}return S};
sap.ui.core.Core.prototype.isStaticAreaRef=function(d){return d&&(d.id==="sap-ui-static")};
sap.ui.core.Core._I_INTERVAL=200;sap.ui.core.ResizeHandler.prototype.I_INTERVAL=sap.ui.core.Core._I_INTERVAL;
sap.ui.core.Core.prototype.attachIntervalTimer=function(f,l){if(!this.oTimedTrigger){jQuery.sap.require("sap.ui.core.IntervalTrigger");this.oTimedTrigger=new sap.ui.core.IntervalTrigger(sap.ui.core.Core._I_INTERVAL)}this.oTimedTrigger.addListener(f,l)};
sap.ui.core.Core.prototype.detachIntervalTimer=function(f,l){if(this.oTimedTrigger){this.oTimedTrigger.removeListener(f,l)}};
sap.ui.core.Core.prototype.attachControlEvent=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.ControlEvent,f,l)};
sap.ui.core.Core.prototype.detachControlEvent=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.ControlEvent,f,l)};
sap.ui.core.Core.prototype.fireControlEvent=function(p){this.fireEvent(sap.ui.core.Core.M_EVENTS.ControlEvent,p)};
sap.ui.core.Core.prototype._handleControlEvent=function(e,u){var E=jQuery.Event(e.type);jQuery.extend(E,e);E.originalEvent=undefined;this.fireControlEvent({"browserEvent":E,"uiArea":u})};
sap.ui.core.Core.prototype.getApplication=function(){return this.oApplication};
sap.ui.core.Core.prototype.setApplication=function(a){this.oApplication=a;jQuery.each(this.oModels,function(n,m){a.oPropagatedProperties.oModels[n]=m});a.propagateProperties(true);return this};
sap.ui.core.Core.prototype.registerPlugin=function(p){if(!p){return}for(var i=0,l=this.aPlugins.length;i<l;i++){if(this.aPlugins[i]===p){return}}this.aPlugins.push(p);if(this.bInitialized&&p&&p.startPlugin){p.startPlugin(this)}};
sap.ui.core.Core.prototype.unregisterPlugin=function(p){if(!p){return}var P=-1;for(var i=this.aPlugins.length;i--;i>=0){if(this.aPlugins[i]===p){P=i;break}}if(P==-1){return}if(this.bInitialized&&p&&p.stopPlugin){p.stopPlugin(this)}this.aPlugins.splice(P,1)};
sap.ui.core.Core.prototype.startPlugins=function(){for(var i=0,l=this.aPlugins.length;i<l;i++){var p=this.aPlugins[i];if(p&&p.startPlugin){p.startPlugin(this,true)}}};
sap.ui.core.Core.prototype.stopPlugins=function(){for(var i=0,l=this.aPlugins.length;i<l;i++){var p=this.aPlugins[i];if(p&&p.stopPlugin){p.stopPlugin(this)}}};
sap.ui.core.Core.prototype.setModel=function(m,n){if(!m&&this.oModels[n]){delete this.oModels[n];if(this.oApplication){delete this.oApplication.oPropagatedProperties.oModels[n];this.oApplication.propagateProperties(n)}jQuery.each(this.mUIAreas,function(i,u){delete u.oPropagatedProperties.oModels[n];u.propagateProperties(n)})}else if(m&&m!==this.oModels[n]){this.oModels[n]=m;if(this.oApplication){this.oApplication.oPropagatedProperties.oModels[n]=m;this.oApplication.propagateProperties(n)}jQuery.each(this.mUIAreas,function(i,u){u.oPropagatedProperties.oModels[n]=m;u.propagateProperties(n)})}else{}return this};
sap.ui.core.Core.prototype.getModel=function(n){return this.oModels[n]};
sap.ui.core.Core.prototype.hasModel=function(){return!jQuery.isEmptyObject(this.oModels)};
sap.ui.core.Core.prototype.getEventBus=function(){if(!this.oEventBus){jQuery.sap.require("sap.ui.core.EventBus");this.oEventBus=new sap.ui.core.EventBus()}return this.oEventBus};
sap.ui.core.Core.prototype.attachValidationError=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.ValidationError,f,l);return this};
sap.ui.core.Core.prototype.detachValidationError=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.ValidationError,f,l);return this};
sap.ui.core.Core.prototype.attachParseError=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.ParseError,f,l);return this};
sap.ui.core.Core.prototype.detachParseError=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.ParseError,f,l);return this};
sap.ui.core.Core.prototype.attachFormatError=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.FormatError,f,l);return this};
sap.ui.core.Core.prototype.detachFormatError=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.FormatError,f,l);return this};
sap.ui.core.Core.prototype.attachValidationSuccess=function(f,l){this.attachEvent(sap.ui.core.Core.M_EVENTS.ValidationSuccess,f,l);return this};
sap.ui.core.Core.prototype.detachValidationSuccess=function(f,l){this.detachEvent(sap.ui.core.Core.M_EVENTS.ValidationSuccess,f,l);return this};
sap.ui.core.Core.prototype.fireParseError=function(a){this.fireEvent(sap.ui.core.Core.M_EVENTS.ParseError,a);return this};
sap.ui.core.Core.prototype.fireValidationError=function(a){this.fireEvent(sap.ui.core.Core.M_EVENTS.ValidationError,a);return this};
sap.ui.core.Core.prototype.fireFormatError=function(a){this.fireEvent(sap.ui.core.Core.M_EVENTS.FormatError,a);return this};
sap.ui.core.Core.prototype.fireValidationSuccess=function(a){this.fireEvent(sap.ui.core.Core.M_EVENTS.ValidationSuccess,a);return this};
sap.ui.core.Core.prototype.isMobile=function(){return sap.ui.Device.browser.mobile};
if(!window.sap.ui.getCore){(function(){new sap.ui.core.Core()}())}
sap.ui.setRoot=function(d,c){sap.ui.getCore().setRoot(d,c)};
