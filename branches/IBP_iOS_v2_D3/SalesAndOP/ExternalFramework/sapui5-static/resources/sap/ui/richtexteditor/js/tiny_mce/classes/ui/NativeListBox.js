/**
 * NativeListBox.js
 *
 * Copyright, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://www.tinymce.com/license
 * Contributing: http://www.tinymce.com/contributing
 */
(function(b){var D=b.DOM,E=b.dom.Event,c=b.each,d=b.util.Dispatcher,u;b.create('tinymce.ui.NativeListBox:tinymce.ui.ListBox',{NativeListBox:function(i,s){this.parent(i,s);this.classPrefix='mceNativeListBox'},setDisabled:function(s){D.get(this.id).disabled=s;this.setAriaProperty('disabled',s)},isDisabled:function(){return D.get(this.id).disabled},select:function(a){var t=this,e,f;if(a==u)return t.selectByIndex(-1);if(a&&typeof(a)=="function")f=a;else{f=function(v){return v==a}}if(a!=t.selectedValue){c(t.items,function(o,i){if(f(o.value)){e=1;t.selectByIndex(i);return false}});if(!e)t.selectByIndex(-1)}},selectByIndex:function(i){D.get(this.id).selectedIndex=i+1;this.selectedValue=this.items[i]?this.items[i].value:null},add:function(n,v,a){var o,t=this;a=a||{};a.value=v;if(t.isRendered())D.add(D.get(this.id),'option',a,n);o={title:n,value:v,attribs:a};t.items.push(o);t.onAdd.dispatch(t,o)},getLength:function(){return this.items.length},renderHTML:function(){var h,t=this;h=D.createHTML('option',{value:''},'-- '+t.settings.title+' --');c(t.items,function(i){h+=D.createHTML('option',{value:i.value},i.title)});h=D.createHTML('select',{id:t.id,'class':'mceNativeListBox','aria-labelledby':t.id+'_aria'},h);h+=D.createHTML('span',{id:t.id+'_aria','style':'display: none'},t.settings.title);return h},postRender:function(){var t=this,a,f=true;t.rendered=true;function o(e){var v=t.items[e.target.selectedIndex-1];if(v&&(v=v.value)){t.onChange.dispatch(t,v);if(t.settings.onselect)t.settings.onselect(v)}};E.add(t.id,'change',o);E.add(t.id,'keydown',function(e){var g;E.remove(t.id,'change',a);f=false;g=E.add(t.id,'blur',function(){if(f)return;f=true;E.add(t.id,'change',o);E.remove(t.id,'blur',g)});if(b.isWebKit&&(e.keyCode==37||e.keyCode==39)){return E.prevent(e)}if(e.keyCode==13||e.keyCode==32){o(e);return E.cancel(e)}});t.onPostRender.dispatch(t,D.get(t.id))}})})(tinymce);
