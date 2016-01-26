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

    <xsl:output method="html"/>
    <xsl:template name="view_dependants">          
        <xsl:variable name="result"  select="//context/query/results"/>
   
                      
        <xsl:if test=" $result != ''  ">
            <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>                                                    
            <xsl:variable name="output" select="//context//query/outputs/path"/>
            <xsl:variable name="VocFileName"  select="//context/VocFileName"/>
            <xsl:variable name="TermName"  select="//context/termvalue"/>
            <script type="text/javascript">

                $(document).ready(function(){
          
                $('#results tbody').on('click', 'tr', function () {
                var onclick = $(this).find('.invisible a').attr('id');
                var a = $('.actionsMenu').find('a').attr('onclick', onclick);
                } );
                if( window.opener ){ //popup case
                $('#closeButton').css('display','');;
                }else{
                $('#backButton').css('display','');;

                }
              
                });
            </script>
            <div id="dependants" style="display:none;">            
                <div class="row">
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
                    <div class="col-sm-12 col-md-12 col-lg-12">
                
                        <h4 class="title">
                            <xsl:variable name="tag" select=" 'DependenciesTitle' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                       
                            <xsl:value-of select="$translated"/>
                            <xsl:if test="$VocFileName!=''">
                                <xsl:text></xsl:text>
                                -
                                <xsl:text></xsl:text>
                                <xsl:value-of select="$VocFileName"/>
                            </xsl:if>
                        </h4>                   
                        <h5 class="subtitle">
                            <b>
                                <xsl:variable name="tag" select=" 'record' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>:
                            </b>
                            <xsl:text></xsl:text>    
                            <xsl:value-of select="$TermName"/>
                        </h5>  
                        <table id="results">
                            <thead>
                                <tr  class="contentHeadText">                                                  
                                    <xsl:for-each select="$output">
                                        <th>
                                            <strong>
                                                <xsl:variable name="tag" select=" ./text() "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>
                                            </strong>
                                        </th>
                                    </xsl:for-each>
                                    <th style="display:none"></th>

                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//result">
                                    <tr class="resultRow">
                                        <td>                                                
                                            <xsl:value-of select="./name/text()"/>
                                        </td>
                                        <td title="{concat($URI_Reference_Path,./uri_id/text())}">                                                
                                            <xsl:value-of select="./uri_id/text()"/>
                                        </td>
                                        <xsl:variable name="type" select="./type/text()"/>                               
                                        <xsl:variable name="id" select="./id/text()"/>                               
                                        <xsl:variable name="tag" select=" 'Proboli' "/>                               
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:variable name="ServletView" select="//context//actions//menu[@id='View']/actionPerType[@id=$type]/userRights[./text()=$UserRights]/@id"/>
                      
                                        <xsl:variable name="ServletViewNoLang">
                                            <xsl:call-template name="string-replace-all">
                                                <xsl:with-param name="text" select="$ServletView" />
                                                <xsl:with-param name="replace" select="'&amp;lang='" />
                                                <xsl:with-param name="by" select="''" />
                                            </xsl:call-template>
                                        </xsl:variable>
                     
                                        <td class="invisible">                                        
                                            <a id="previewPopUp('{concat($ServletViewNoLang,$id,'&amp;lang=',$lang)}', '{$type}')"/>             
                                        </td>
                                       
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:variable name="tag" select=" 'Epistrofi' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <a id="backButton" style="display:none;" class="btn btn-default .btn-sm displayButton" href="javascript:window.history.go(-2);">
                            <xsl:value-of select="$translated"/>
                        </a>
                        <xsl:variable name="tag" select=" 'Kleisimo' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <a id="closeButton" style="display:none;margin-bottom: 20px;" class="btn btn-default .btn-sm displayButton" href="javascript:window.close();" >
                            <xsl:value-of select="$translated"/>
                        </a>
                        
                    </div>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>