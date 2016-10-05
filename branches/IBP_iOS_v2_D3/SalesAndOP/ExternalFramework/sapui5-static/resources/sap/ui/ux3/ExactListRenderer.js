/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
 * 
 * (c) Copyright 2009-2013 SAP AG. All rights reserved
 */
jQuery.sap.declare("sap.ui.ux3.ExactListRenderer");sap.ui.ux3.ExactListRenderer={};
sap.ui.ux3.ExactListRenderer.render=function(r,c){var a=r;var s=c.getSubLists();var A=c._getAtt();if(!A){return}var I=c._isTop();a.write("<div");a.writeControlData(c);a.addClass("sapUiUx3ExactLst");var b=false;var t=false;if(I){var B=c.getParent();if(B){if(B.hasOptionsMenu){b=B.hasOptionsMenu();if(b){a.addClass("sapUiUx3ExactLstTopActive")}}if(B.getShowTopList&&!B.getShowTopList()){a.addClass("sapUiUx3ExactLstTopHidden");t=true}}a.addClass("sapUiUx3ExactLstTop");a.addStyle("height",c.getTopHeight()+"px")}if(c._bCollapsed){a.addClass("sapUiUx3ExactLstCollapsed")}a.addClass("sapUiUx3ExactLstLvl_"+c._iLevel);a.writeClasses();a.writeStyles();a.write(">");if(t){a.write("<div id=\""+c.getId()+"-foc\" class=\"sapUiUx3ExactLstFoc\" tabindex=\"0\"></div>")}if(!c._bPopupOpened){a.write("<div id=\""+c.getId()+"-lst\" class=\"sapUiUx3ExactLstLst\"");if(c._bCollapsed&&c._oCollapseStyles&&c._oCollapseStyles["lst"]){a.write(" style=\""+c._oCollapseStyles["lst"]+"\"")}a.write(">");a.renderControl(c._lb);a.write("<a id=\""+c.getId()+"-exp\" class=\"sapUiUx3ExactLstExp\">"+this.getExpanderSymbol(false,false)+"</a>");a.write("</div>")}else{c._bRefreshList=true}a.write("<div id=\""+c.getId()+"-cntnt\" ");a.write("class=\"sapUiUx3ExactLstCntnt");if(s.length==0){a.write(" sapUiUx3ExactLstCntntEmpty")}a.write("\"");if(c._bCollapsed&&c._oCollapseStyles&&c._oCollapseStyles["cntnt"]){a.write(" style=\""+c._oCollapseStyles["cntnt"]+"\"")}a.write(">");for(var i=0;i<s.length;i++){a.renderControl(s[i])}a.write("</div>");a.write("<header id=\""+c.getId()+"-head\" class=\"sapUiUx3ExactLstHead\"");if(I&&b){a.write(" role=\"button\" aria-haspopup=\"true\"")}if(!I&&c._bCollapsed&&A){a.writeAttribute("role","region");a.writeAttribute("aria-expanded","false");a.writeAttributeEscaped("aria-label",c._rb.getText("EXACT_LST_LIST_COLL_ARIA_LABEL",[c._iLevel,A.getText()]))}a.write(" tabindex=\""+(I?"0":"-1")+"\">");if(I){a.write("<h3 id=\""+c.getId()+"-head-txt\" class=\"sapUiUx3ExactLstHeadTopTxt\"><span class=\"sapUiUx3ExactLstHeadTopTxtTxt\">");if(c.getTopTitle()){a.writeEscaped(c.getTopTitle())}a.write("</span>");if(b){a.write("<span class=\"sapUiUx3ExactLstHeadTopIco\"></span>")}a.write("</span></h3>")}else{a.write("<h3 id=\""+c.getId()+"-head-txt\" class=\"sapUiUx3ExactLstHeadTxt\"");if(A&&A.getTooltip_AsString()){a.writeAttributeEscaped("title",A.getTooltip_AsString())}else if(A&&A.getText()){a.writeAttributeEscaped("title",A.getText())}if(c._bCollapsed&&c._oCollapseStyles&&c._oCollapseStyles["head-txt"]){a.write(" style=\""+c._oCollapseStyles["head-txt"]+"\"")}a.write(">");if(A){a.writeEscaped(A.getText())}a.write("</h3>");a.write("<div id=\""+c.getId()+"-head-action\" class=\"sapUiUx3ExactLstHeadAct"+(c.getShowClose()?"":" sapUiUx3ExactLstHeadActNoClose")+"\">");a.write("<a id=\""+c.getId()+"-hide\" class=\"sapUiUx3ExactLstHide\" role=\"presentation\"");a.writeAttributeEscaped("title",c._rb.getText(c._bCollapsed?"EXACT_LST_LIST_EXPAND":"EXACT_LST_LIST_COLLAPSE"));a.write(">",this.getExpanderSymbol(!c._bCollapsed,true),"</a>");a.write("<a id=\""+c.getId()+"-close\" role=\"presentation\" class=\"sapUiUx3ExactLstClose\"");a.writeAttributeEscaped("title",c._rb.getText("EXACT_LST_LIST_CLOSE"));a.write(">X</a>");a.write("</div>")}a.write("</header>");a.write("<div id=\""+c.getId()+"-rsz\" class=\"sapUiUx3ExactLstRSz\"></div>");a.write("</div>")};
sap.ui.ux3.ExactListRenderer.getExpanderSymbol=function(e,h){if(h){if(sap.ui.getCore().getConfiguration().getRTL()){return e?"&#9654;":"&#9664;"}else{return e?"&#9664;":"&#9654;"}}else{return e?"&#9650;":"&#9660;"}};
