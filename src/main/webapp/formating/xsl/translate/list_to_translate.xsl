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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../ui/page.xsl"/>
    <xsl:include href="../utils/utils.xsl"/>
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="FileId" select="//context/FileId[1]"/>
    <xsl:variable name="ListOf" select="//context/ListOf"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="output" select="//context/query/outputs/path[@selected='yes']"/>
    <xsl:variable name="ServletView" select="//context//actions//menu[@id='View']/actionPerType[@id=$EntityType]/userRights[./text()=$UserRights]/@id"/>
    <xsl:variable name="ServletName" select="//context/ServletName"/>


    
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <div class="row actionsRow">
            <div class="col-sm-9 col-md-9 col-lg-9 actionsMenu">
                <ul class="nav nav-tabs">
                    <li>
                        <xsl:variable name="tag" select=" 'Proboli' "/>                               
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <a title="{$translated}" href="javascript:void(0);" onclick="">
                            <img src="formating/images/view.png" onmouseover="this.src = './formating/images/viewHover.png';" onmouseout="this.src = './formating/images/view.png';"/>
                        </a>
                    </li>                 
                </ul>
            </div>
        </div>        
        <div class="row context">
            <script type="text/javascript">
                $(document).ready(function(){
          
                $('#results tbody').on('click', 'tr', function () {
                var onclick = $(this).find('.invisible a').attr('id');                
                var a = $('.actionsMenu').find('a').attr('onclick', onclick);
                $(this).find('.invisible #radioBox').prop("checked", true); ;                

                } );
                
                });
             
            </script>  
            <div class="col-sm-12 col-md-12 col-lg-12">
                
                <h4 class="title">
                    <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id=$EntityType]/label/text()"/>
                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>        
                    <xsl:text> - </xsl:text>
                    <xsl:variable name="tag" select=" 'Metafrasi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                       
                    <xsl:value-of select="$translated"/>
                </h4>
                <h5 class="subtitle">
                    <b>
                        <xsl:variable name="tag" select=" 'EpilogiDeltiouApo' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                        <xsl:value-of select="$translated"/>
                        <xsl:text></xsl:text>
                        <xsl:variable name="tag" select=" 'LighWra' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                        (<xsl:text></xsl:text>
                        <xsl:value-of select="$translated"/>
                        <xsl:text></xsl:text>)   
                    </b>
                </h5>
                <form method="post" action="TranslateServlet?action=translate&amp;mode={$AdminMode}&amp;type={$EntityType}&amp;id={$FileId}">

                    <table id="results">
                        <thead>
                        
                            <tr class="contentHeadText"> 
                                <th style="display:none;"></th>                                                   
                                <xsl:for-each select="$output">
                                    <th>
                                        <strong>
                                            <xsl:variable name="tag" select=" ./text() "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>
                                        </strong>
                                    </th>
                                </xsl:for-each>             
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//result">                                
                                
                              
                                <tr class="resultRow">
                                    <xsl:variable name="ID" select="./FileId/text()"/>
                                    <xsl:variable name="servletView" select="concat(servlet,$ID)"/>
 
                                    <xsl:variable name="ServletViewNoLang">
                                        <xsl:call-template name="string-replace-all">
                                            <xsl:with-param name="text" select="$ServletView" />
                                            <xsl:with-param name="replace" select="'&amp;lang='" />
                                            <xsl:with-param name="by" select="''" />
                                        </xsl:call-template>
                                    </xsl:variable>
                     
                                    <td class="invisible">                                        
                                        <a id="previewPopUp('{concat($ServletViewNoLang,$ID,'&amp;lang=',$lang)}', '{$type}')"/>
                                        <input id="radioBox" type="radio" name="fromId" value="{$ID}"></input>
             
                                    </td>
                                    <xsl:for-each select="./*[name() != 'FileId' and name() !=  'info' and name() !=  'type']  ">
                                        <td>
                                            <xsl:for-each select="./*">

                                                <xsl:if test="position() > 1">
                                                    <br/>
                                                </xsl:if>
                                                <xsl:choose>
                                                    <xsl:when test="name() ='filename'">    
                                                        <xsl:variable name="uriId" select=".//text()"/>                                   
                                                        <xsl:value-of select="$uriId"/>
                                                    </xsl:when>
                                                    <xsl:when test="name() ='ShortDescription'">    
                                                        <xsl:variable name="description" select="./ShortDescription/text()"/>                                   
                                                        <xsl:variable name="short_description" select="substring($description,1,15)"/>                                   
                                                        <xsl:value-of select="$short_description"/>
                                                        <xsl:if test="$short_description!=''and $short_description!=$description" >
                                                            <xsl:value-of select="'...'"/>
                                                        </xsl:if>             
                                                    </xsl:when>
                                                    <xsl:when test="name() = 'ΨηφιακόΑρχείο' or name() = 'File' ">
                                                        <xsl:variable name="tag" select=" 'Proboli' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <xsl:variable name="mime" select="'Photos'"/>
                                           
                                                        <a href="FetchBinFile?mime={$mime}&amp;type={$EntityType}&amp;depository=disk&amp;file={encode-for-uri(./text())}" target="blank_">
                                                            <!--Samarita Servlet attempt-->                                                               
                                                            <img src="FetchBinFile?mime={$mime}&amp;size=small&amp;type={$EntityType}&amp;depository=disk&amp;file={encode-for-uri(./text())}" border="1" alt="{$translated}" width="50"></img>
                                                        </a>                                                     
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="./text()"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>

                                            </xsl:for-each>
                                        </td>
                                    </xsl:for-each>                        
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                    <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit" onclick="getObj('proccessing').style.display='block'">    
                        <xsl:value-of select="$translated"/>
                    </button>      
                </form>
                <div id="proccessing" style="font-size:10pt; display:none">
                    <xsl:variable name="tag" select=" 'SeExelixi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </div>
            </div>
        </div>
        

    </xsl:template>
</xsl:stylesheet>
