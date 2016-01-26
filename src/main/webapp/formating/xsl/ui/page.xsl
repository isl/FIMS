<?xml version="1.0" encoding="UTF-8"?>
<!--

Copyright 2015 Institute of Computer Science,
Foundation for Research and Technology - Hellas

Licensed under the EUPL, Version 1.1 or - as soon they will be approved
by the European Commission - subsequent versions of the EUPL (the "Licence");
You may not use this work except in compliance with the Licence.
You may obtain a copy of the Licence at:

http://ec.europa.eu/idabc/eupl

Unless required by applicable law or agreed to in writing, software distributed
under the Licence is distributed on an "AS IS" basis,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the Licence for the specific language governing permissions and limitations
under the Licence.

Contact:  POBox 1385, Heraklio Crete, GR-700 13 GREECE
Tel:+30-2810-391632
Fax: +30-2810-391638
E-mail: isl@ics.forth.gr
http://www.ics.forth.gr/isl

Authors : Konstantina Konsolaki, Georgios Samaritakis

This file is part of the FIMS webapp.

 
-->

<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" version="2.0">
    <xsl:include href="header.xsl"/>
    <xsl:include href="footer.xsl"/>
    <xsl:include href="leftmenu.xsl"/>
    <xsl:include href="actionsMenu.xsl"/>

    <xsl:include href="head_html.xsl"/>
    <xsl:include href="vars.xsl"/>
    <xsl:include href="../storage/backup_popupMsg.xsl"/>
    <xsl:include href="../storage/restore_popupMsg.xsl"/>
   
    <xsl:template name="page">       
        <html>
            <xsl:if test=" $lang='ar'">
                <xsl:attribute name="class">rtl</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="head_html"/>               
            <body>                    
                <div class="container">
                    
                         
                    <xsl:choose>
                        <xsl:when test="$user!=''">
                            <div class="row col-wrap" id="header">
                                <xsl:call-template name="header"/>
                            </div>  
                            <div class="row col-wrap" id="content">
                                <div class="col-sm-2 col-md-2 col-lg-2 col"  id="leftmenu">
                                    <div class="well" id="leftWell">
                                        <xsl:call-template name="leftmenu"/>

                                    </div>
                                </div>    
                                <div class="col-sm-10 col-md-10 col-lg-10 rightContent col">
                                    <div class="well" id="rightWell">
                                        <xsl:call-template name="context"/>
                                    </div>
                                </div>  
                            </div>    
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="row" id="content">     
                                <div id="header">
                                    <xsl:call-template name="header"/>
                                </div>                   
                                <div class="col-sm-12 col-md-12 col-lg-12">
                                    <xsl:call-template name="context"/>
                                </div>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose> 
                    <div class="row col-wrap">
                        <div class="col-sm-12 col-md-12 col-lg-12" id="footer">
                            <xsl:call-template name="footer">
                            </xsl:call-template>
                        </div>
                    </div>    
                </div>                
                <xsl:call-template name="splashB"/>
                <xsl:call-template name="splashR"/>
            </body>
        </html>
        
        
        <script type="text/javascript">                
                    
            function enableLink($current,$item,id,file){
            var lang = '<xsl:value-of select="$lang"/>';
            var onclick= $item.getAttribute("onclick");
            var hasID=$item.getAttribute('id');
            var hasLang = (hasID.indexOf("lang=")>-1);
            if(onclick!=null){
            onclick=hasID;
            if(hasID.indexOf("id=")!=-1){                                
            onclick=hasID.replace("id=","id="+id);                                  
            }
                        
            if(hasLang){
            onclick=onclick.replace("lang=","lang="+lang); 
            }                                   
            if(file!=""){
            onclick=onclick.replace("file=","file="+file)
            }
            $current.attr('href',"javascript:void(0)");
            $item.onclick=function(){
            popUp(onclick, id, 900, 700);
            }
            }

            var href= $item.getAttribute('href'); 
            if(href!=null &amp;&amp; onclick==null){
            if(hasID!=""){
            href=hasID;
            var hasLang = (href.indexOf("lang=")>-1);
            if(href.indexOf("id=")!=-1){                                
            href=href.replace("id=","id="+id);                                   
            }
                                
            if(hasLang){
            href=href.replace("lang=","lang="+lang); 
            } 
            if(file!=""){
            href=href.replace("file=","file="+file);                                       
            }
            }
            $current.attr('href',href);
            }
            }                           
        </script>
     
    </xsl:template>
</xsl:stylesheet>
