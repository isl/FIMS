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
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../ui/page.xsl"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="FileId" select="//context/FileId"/>
    <xsl:variable name="ListOf" select="//context/ListOf"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="output" select="//context/query/outputs/path"/>
    <xsl:variable name="ServletView" select="//context//actions//menu[@id='View']/actionPerType[@id=$EntityType]/userRights[./text()=$UserRights]/@id"/>




    
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <script type="text/javascript">
            var lang = '<xsl:value-of select="$lang"/>';
            var servlet = '<xsl:value-of select="$ServletView"/>';
            var hasLang = (servlet.indexOf("lang=")>-1);
            if(hasLang){
            servlet=servlet.replace("lang=","lang="+lang); 
            }
            $(document).ready(function(){
          
            $('#results tbody').on('click', 'tr', function () {
            var tds = $(this).find('td');
            var id = tds[0].innerHTML;
            var a = $('.actionsMenu').find('a');
            $.each(a, function (index, item){ 
            var hasID = item.getAttribute('id');
            var onclick = item.getAttribute('onclick');
            if(onclick!=null){
            onclick =hasID;
            onclick = onclick.replace("collectionID=", "collectionID=" + id);
            $(this).attr('onclick',onclick)
            }
            var href = item.getAttribute('href');
            if(href!=null &amp;&amp; onclick==null){
            href =hasID;
            href = href.replace("collectionID=", "collectionID=" + id);
            $(this).attr('href',href)
            }
         
            });

            });
            });

            
        </script>    
        <div class="row">
            <div class="col-sm-9 col-md-9 col-lg-9 actionsMenu">
                <ul class="nav nav-tabs">
                    <li>
                        <xsl:variable name="tag" select=" 'Proboli' "/>                               
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <a title="{$translated}" id="previewPopUp(servlet+'{$FileId}'+'&amp;versions=yes&amp;collectionID='+'{./versionId/text()}'+'&amp;entityType={$EntityType}'+'&amp;xmlId={$FileId}', '{$EntityType}')"  href="javascript:void(0)" onClick="previewPopUp(servlet+'{$FileId}'+'&amp;versions=yes&amp;collectionID='+'{./versionId/text()}'+'&amp;entityType={$EntityType}'+'&amp;xmlId={$FileId}', '{$EntityType}')">
                            <img border="0" src="formating/images/view.png" onmouseover="this.src = './formating/images/viewHover.png';" onmouseout="this.src = './formating/images/view.png';"/>
                        </a>
                    </li>
                    <li>
                         <xsl:variable name="tag" select=" 'EksagwghXML' "/>                               
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <a title="{$translated}" id="ExportVersions?id={$FileId}&amp;type={$EntityType}&amp;collectionID={./versionId/text()}" href="ExportVersions?id={$FileId}&amp;type={$EntityType}&amp;collectionID={./versionId/text()}">
                            <img border="0" src="formating/images/export.png" onmouseover="this.src = './formating/images/exportHover.png';" onmouseout="this.src = './formating/images/export.png';"/>
                        </a>   
                    </li>
                </ul>
            </div>
        </div>        
        <div class="row context">
            <div class="col-sm-12 col-md-12 col-lg-12">
                
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'Versions' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                       
                    <xsl:value-of select="$translated"/>
                </h4>
                <h5 class="subtitle">
                    <b>
                        <xsl:variable name="tag" select=" 'record' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                        <xsl:value-of select="$translated"/>:
                    </b>
                    <xsl:text></xsl:text>    
                    <xsl:value-of select="//context/nameValue"/>
                </h5>
                
                <table id="results">
                    <thead>
                        <tr class="contentHeadText">
                            <td style="display:none;">                                                         
                            </td>                        
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
                            <xsl:variable name="ID" select="./FileId/text()"/>
                            <tr class="resultRow"> 
                                <td class="invisible" >
                                    <xsl:value-of select="./versionId/text()"/>
                                </td>                               
                                <xsl:for-each select="./*">                                
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="name()='versionId'">
                                                <xsl:variable name="tag" select=" 'version' "/>                               
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                                                <xsl:value-of select="$translated"/>                                  
                                                <xsl:value-of select="./text()"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                                 
                                    </td>
                                </xsl:for-each>                      
                            </tr>
                        </xsl:for-each>
                    </tbody>

                </table>
            </div>
        </div>      
   
    </xsl:template>
</xsl:stylesheet>
