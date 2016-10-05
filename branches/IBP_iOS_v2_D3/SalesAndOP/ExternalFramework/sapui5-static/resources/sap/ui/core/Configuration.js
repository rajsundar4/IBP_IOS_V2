/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.core.Configuration");jQuery.sap.require("sap.ui.base.Object");jQuery.sap.require("sap.ui.core.Locale");jQuery.sap.require("sap.ui.thirdparty.URI");(function(){sap.ui.base.Object.extend("sap.ui.core.Configuration",{constructor:function(C){this._oCore=C;function d(){var m;if(!!sap.ui.Device.os.android){m=navigator.userAgent.match(/\s([a-z]{2}-[a-z]{2})[;)]/i);if(m){return m[1]}}return navigator.language||navigator.userLanguage||navigator.browserLanguage}var f={"theme":{type:"string",defaultValue:"base"},"language":{type:"string",defaultValue:d()},"formatLocale":{type:"string",defaultValue:null},"accessibility":{type:"boolean",defaultValue:true},"animation":{type:"boolean",defaultValue:true},"rtl":{type:"boolean",defaultValue:null},"debug":{type:"boolean",defaultValue:false},"inspect":{type:"boolean",defaultValue:false},"originInfo":{type:"boolean",defaultValue:false},"noConflict":{type:"boolean",defaultValue:false,noUrl:true},"noDuplicateIds":{type:"boolean",defaultValue:true},"trace":{type:"boolean",defaultValue:false,noUrl:true},"modules":{type:"string[]",defaultValue:[],noUrl:true},"areas":{type:"string[]",defaultValue:null,noUrl:true},"onInit":{type:"code",defaultValue:undefined,noUrl:true},"uidPrefix":{type:"string",defaultValue:"__",noUrl:true},"ignoreUrlParams":{type:"boolean",defaultValue:false,noUrl:true},"weinreServer":{type:"string",defaultValue:"",noUrl:true},"weinreId":{type:"string",defaultValue:""},"preload":{type:"string",defaultValue:"auto"},"rootComponent":{type:"string",defaultValue:"",noUrl:true},"xx-rootComponentNode":{type:"string",defaultValue:"",noUrl:true},"application":{type:"string",defaultValue:""},"appCacheBuster":{type:"string[]",defaultValue:[]},"xx-appCacheBusterMode":{type:"string",defaultValue:"sync"},"xx-disableCustomizing":{type:"boolean",defaultValue:false,noUrl:true},"xx-loadAllMode":{type:"boolean",defaultValue:false,noUrl:true},"xx-test-mobile":{type:"boolean",defaultValue:false},"xx-preloadLibCss":{type:"string[]",defaultValue:[]},"xx-componentPreload":{type:"string",defaultValue:""},"xx-bindingSyntax":{type:"string",defaultValue:"simple",noUrl:true},"xx-designMode":{type:"boolean",defaultValue:false},"xx-accessibilityMode":{type:"boolean",defaultValue:false},"xx-supportedLanguages":{type:"string[]",defaultValue:[]},"xx-bootTask":{type:"function",defaultValue:undefined,noUrl:true},"xx-suppressDeactivationOfControllerCode":{type:"boolean",defaultValue:false}};var g={"xx-test":"1.15","flexBoxPolyfill":"1.14","sapMeTabContainer":"1.14","sapMeProgessIndicator":"1.14","sapMGrowingList":"1.14","sapMListAsTable":"1.14","sapMDialogWithPadding":"1.14"};this.oFormatSettings=new sap.ui.core.Configuration.FormatSettings(this);var h=this;function s(N,V){if(typeof V==="undefined"||V===null){return}switch(f[N].type){case"boolean":if(typeof V==="string"){if(f[N].defaultValue){h[N]=V.toLowerCase()!="false"}else{h[N]=V.toLowerCase()==="true"||V.toLowerCase()==="x"}}else{h[N]=!!V}break;case"string":h[N]=""+V;break;case"code":h[N]=typeof V==="function"?V:String(V);break;case"function":if(typeof V!=="function"){throw new Error("unsupported value")}h[N]=V;break;case"string[]":if(jQuery.isArray(V)){h[N]=V}else if(typeof V==="string"){h[N]=jQuery.map(V.split(/[ ,;]/),function($){return jQuery.trim($)})}else{throw new Error("unsupported value")}break;default:throw new Error("illegal state")}}function i(T){var r=/^\/sap\/public\/bc\/themes\//i,p,j,k;try{p=new URI().normalize();j=new URI(T,window.location.href).normalize();if(j.hostname()===p.hostname()){k=j.path();if(r.test(j.path())){return k+(k.slice(-1)==='/'?'':'/')+"UI5/"}else{return k}}}catch(e){}jQuery.sap.log.error("Invalid Theme Root URL: URL must point into the central theme repository on the same server - setting ignored")}for(var n in f){h[n]=f[n].defaultValue}var o=window["sap-ui-config"]||{};o.oninit=o.oninit||o["evt-oninit"];for(var n in f){s(n,o[n.toLowerCase()])}if(o.libs){h.modules=jQuery.map(o.libs.split(","),function($){return jQuery.trim($)+".library"}).concat(h.modules)}var P="compatversion";var D=o[P];var B=jQuery.sap.Version("1.14");this._compatversion={};function _(k){var v=!k?D||B.toString():o[P+"-"+k.toLowerCase()]||D||g[k]||B.toString();v=jQuery.sap.Version(v.toLowerCase()==="edge"?sap.ui.version:v);return jQuery.sap.Version(v.getMajor(),v.getMinor())}this._compatversion._default=_();for(var n in g){this._compatversion[n]=_(n)}if(!h.ignoreUrlParams){var u="sap-ui-";var U=jQuery.sap.getUriParameters();if(U.mParams['sap-locale']||U.mParams['sap-language']){var V=U.get('sap-locale')||U.get('sap-language');if(V===""){h['language']=f['language'].defaultValue}else{s('language',V)}}if(U.mParams['sap-accessibility']){var V=U.get('sap-accessibility');if(V==="X"||V==="x"){s('xx-accessibilityMode',true)}else{s('xx-accessibilityMode',false)}}if(U.mParams['sap-rtl']){var V=U.get('sap-rtl');if(V==="X"||V==="x"){s('rtl',true)}else{s('rtl',false)}}if(U.mParams['sap-theme']){var V=U.get('sap-theme');if(V===""){h['theme']=f['theme'].defaultValue}else{s('theme',V)}}for(var n in f){if(f[n].noUrl){continue}var V=U.get(u+n);if(V===""){h[n]=f[n].defaultValue}else{s(n,V)}}}this.derivedRTL=sap.ui.core.Locale._impliesRTL(h.language);var t=h.theme;var T;var I=t.indexOf("@");if(I>=0){T=i(t.slice(I+1));if(T){h.theme=t.slice(0,I);h.themeRoot=T}else{h.theme=(o.theme&&o.theme!==t)?o.theme:"base";I=-1}}h.theme=this._normalizeTheme(h.theme,T);var l=h['xx-supportedLanguages'];if(l.length===0||(l.length===1&&l[0]==='*')){l=[]}else if(l.length===1&&l[0]==='default'){l="ar,bg,ca,cs,da,de,el,en,es,et,fi,fr,hi,hr,hu,it,iw,ja,ko,lt,lv,nl,no,pl,pt,ro,ru,sh,sk,sl,sv,th,tr,uk,vi,zh_CN,zh_TW".split(/,/);if(l.length===1&&l[0].slice(0,1)==='@'){l=[]}}h['xx-supportedLanguages']=l;for(var n in f){if(h[n]!==f[n].defaultValue){jQuery.sap.log.info("  "+n+" = "+h[n])}}},getVersion:function(){if(this._version){return this._version}this._version=new jQuery.sap.Version(sap.ui.version);return this._version},getCompatibilityVersion:function(f){if(typeof(f)==="string"&&this._compatversion[f]){return this._compatversion[f]}return this._compatversion._default},getTheme:function(){return this.theme},_setTheme:function(t){this.theme=t;return this},_normalizeTheme:function(t,T){if(t&&T==null&&t.match(/^sap_corbu$/i))return"sap_goldreflection";return t},getLanguage:function(){return this.language},setLanguage:function(l){c(typeof l==="string"&&l,"sLanguage must be a BCP47 language tag or Java Locale id or null");var o=this.getRTL(),C;if(l!=this.language){C=this._collect();this.language=C.language=l;this.derivedRTL=sap.ui.core.Locale._impliesRTL(l);if(o!=this.getRTL()){C.rtl=this.getRTL()}this._endCollect()}return this},getLocale:function(){return new sap.ui.core.Locale(this.language)},getFormatLocale:function(){return this.formatLocale||this.language},setFormatLocale:function(f){c(f===null||typeof f==="string"&&f,"sFormatLocale must be a BCP47 language tag or Java Locale id or null");var C;if(f!=this.formatLocale){C=this._collect();this.formatLocale=C.formatLocale=f;this._endCollect()}return this},getSupportedLanguages:function(){return this["xx-supportedLanguages"]},getAccessibility:function(){return this.accessibility},getAnimation:function(){return this.animation},getRTL:function(){return this.rtl===null?this.derivedRTL:this.rtl},setRTL:function(r){c(r===null||typeof r==="boolean","bRTL must be null or a boolean");var C;if(r!=this.rtl){C=this._collect();this.rtl=C.rtl=this.getRTL();this._endCollect()}return this},getDebug:function(){return this.debug},getInspect:function(){return this.inspect},getOriginInfo:function(){return this.originInfo},getNoDuplicateIds:function(){return this.noDuplicateIds},getTrace:function(){return this.trace},getUIDPrefix:function(){return this.uidPrefix},getDesignMode:function(){return this["xx-designMode"]},getSuppressDeactivationOfControllerCode:function(){return this["xx-suppressDeactivationOfControllerCode"]},getWeinreServer:function(){var w=this.weinreServer;if(!w){w=window.location.protocol+"//"+window.location.hostname+":";w+=(parseInt(window.location.port,10)||8080)+1}return w},getWeinreId:function(){return this.weinreId},getApplication:function(){return this.application},getRootComponent:function(){return this.rootComponent},getAppCacheBuster:function(){return this.appCacheBuster},getAppCacheBusterMode:function(){return this["xx-appCacheBusterMode"]},getDisableCustomizing:function(){return this["xx-disableCustomizing"]},getPreload:function(){return this.preload},getComponentPreload:function(){return this['xx-componentPreload']||this.preload},getFormatSettings:function(){return this.oFormatSettings},_collect:function(){var C=this.mChanges||(this.mChanges={__count:0});C.__count++;return C},_endCollect:function(){var C=this.mChanges;if(C&&(--C.__count)===0){delete C.__count;this._oCore&&this._oCore.fireLocalizationChanged(C);delete this.mChanges}}});var M={"":{pattern:null},"1":{pattern:"dd.MM.yyyy"},"2":{pattern:"MM/dd/yyyy"},"3":{pattern:"MM-dd-yyyy"},"4":{pattern:"yyyy.MM.dd"},"5":{pattern:"yyyy/MM/dd"},"6":{pattern:"yyyy-MM-dd"}};var a={"":{pattern:null,dayPeriods:null},"0":{pattern:"HH:mm:ss",dayPeriods:null},"1":{pattern:"hh:mm:ss a",dayPeriods:["AM","PM"]},"2":{pattern:"hh:mm:ss a",dayPeriods:["am","pm"]},"3":{pattern:"KK:mm:ss a",dayPeriods:["AM","PM"]},"4":{pattern:"KK:mm:ss a",dayPeriods:["am","pm"]}};var b={"":{groupingSeparator:null,decimalSeparator:null}," ":{groupingSeparator:".",decimalSeparator:","},"X":{groupingSeparator:",",decimalSeparator:"."},"Y":{groupingSeparator:" ",decimalSeparator:","}};function c(C,m){if(!C){throw new Error(m)}}sap.ui.base.Object.extend("sap.ui.core.Configuration.FormatSettings",{constructor:function(C){this.oConfiguration=C;this.mSettings={};this.sLegacyDateFormat=undefined;this.sLegacyTimeFormat=undefined;this.sLegacyNumberFormatSymbolSet=undefined},getFormatLocale:function(){function f(t){var l=t.oConfiguration.language;if(!jQuery.isEmptyObject(t.mSettings)){if(l.indexOf("-x-")<0){l=l+"-x-sapufmt"}else if(l.indexOf("-sapufmt")<=l.indexOf("-x-")){l=l+"-sapufmt"}}return l}return new sap.ui.core.Locale(this.oConfiguration.formatLocale||f(this))},_set:function(k,v){var o=this.mSettings[k];if(v!=null){this.mSettings[k]=v}else{delete this.mSettings[k]}if((o==null!=v==null)||!jQuery.sap.equal(o,v)){var C=this.oConfiguration._collect();C[k]=v;this.oConfiguration._endCollect()}},getDatePattern:function(s){return this.mSettings["dateFormat-"+s]},setDatePattern:function(s,p){c(s=="short"||s=="medium"||s=="long"||s=="full","sStyle must be short, medium, long or full");this._set("dateFormat-"+s,p);return this},getTimePattern:function(s){return this.mSettings["timeFormat-"+s]},setTimePattern:function(s,p){c(s=="short"||s=="medium"||s=="long"||s=="full","sStyle must be short, medium, long or full");this._set("timeFormat-"+s,p);return this},getNumberSymbol:function(t){return this.mSettings["symbols-latn-"+t]},setNumberSymbol:function(t,s){c(t=="decimal"||t=="group"||t=="plusSign"||t=="minusSign","sType must be decimal, group, plusSign or minusSign");this._set("symbols-latn-"+t,s);return this},_setDayPeriods:function(w,t){this._set("dayPeriods-format-"+w,t);return this},getLegacyDateFormat:function(){return this.sLegacyDateFormat||undefined},setLegacyDateFormat:function(f){c(!f||M.hasOwnProperty(f),"sFormatId must be one of ['1','2','3','4','5','6'] or empty");var C=this.oConfiguration._collect();this.sLegacyDateFormat=C.legacyTimeFormat=f=f||"";this.setDatePattern("short",M[f].pattern);this.setDatePattern("medium",M[f].pattern);this.oConfiguration._endCollect();return this},getLegacyTimeFormat:function(){return this.sLegacyTimeFormat||undefined},setLegacyTimeFormat:function(f){c(!f||a.hasOwnProperty(f),"sFormatId must be one of ['0','1','2','3','4'] or empty");var C=this.oConfiguration._collect();this.sLegacyTimeFormat=C.legacyTimeFormat=f=f||"";this.setTimePattern("short",a[f].pattern);this.setTimePattern("medium",a[f].pattern);this._setDayPeriods("abbreviated",a[f].dayPeriods);this.oConfiguration._endCollect();return this},getLegacyNumberFormat:function(){return this.sLegacyNumberFormat||undefined},setLegacyNumberFormat:function(f){f=f?f.toUpperCase():"";c(!f||b.hasOwnProperty(f),"sFormatId must be one of [' ','X','Y'] or empty");var C=this.oConfiguration._collect();this.sLegacyNumberFormat=C.legacyNumberFormat=f;this.setNumberSymbol("group",b[f].groupingSeparator);this.setNumberSymbol("decimal",b[f].decimalSeparator);this.oConfiguration._endCollect()},getCustomLocaleData:function(){return this.mSettings}})}());
