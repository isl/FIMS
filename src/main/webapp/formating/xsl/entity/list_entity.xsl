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
    <xsl:variable name="IsGuestUser" select="//context/IsGuestUser"/>
    <xsl:variable name="DocStatus" select="//context/DocStatus"/>
    <xsl:variable name="ServletName" select="//context/ServletName"/>
    <xsl:variable name="output" select="//context/query/outputs/path[@selected='yes']"/>
    <xsl:variable name="userOrg" select="//page/@userOrg"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="EntityCategory" select="//context/EntityCategory"/>


   
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:variable name="user" select="//page/@UserRights"/>
        <xsl:variable name="EntityType" select="//context/EntityType"/>
        <xsl:variable name="tag" select=" 'PromptMessage' "/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
        <script>
            var str = '<xsl:value-of select="$translated"/>';

            
        </script>

        <xsl:call-template name="actions"/> 
        <div class="row context">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id=$EntityType]/label/text()"/>
                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>        
                </h4>
                <h5 class="subtitle">
                    <b>
                        <xsl:variable name="systemName" select="//context/systemName/text()"/>

                        <xsl:variable name="tag" select=" 'tableContent' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                        <xsl:value-of select="$translated"/>:
                        <xsl:text></xsl:text>
                        <xsl:choose>
                            <xsl:when test="$DocStatus='published'">
                                <xsl:variable name="tag" select=" 'ProboliDimosieumenwn' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>
                            </xsl:when>
                            <xsl:when test="$DocStatus='unpublished'">
                                <xsl:variable name="tag" select=" 'ProboliMhDimosieumenwn' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>
                            </xsl:when>
                            <xsl:when test="$DocStatus='allunpublished' and $systemName='3M'">
                                <xsl:variable name="tag" select=" 'myMappings' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>
                            </xsl:when>
                            <xsl:when test="$DocStatus='' or $DocStatus='all'">
                                <xsl:variable name="tag" select=" 'Ola' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="tag" select=" $DocStatus "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>     
                                <xsl:value-of select="$translated"/>
                            </xsl:otherwise>
                        </xsl:choose>
                            
                    </b>
                </h5>  
                <table id="results">
                    <thead>
                  
                        <tr class="contentHeadText">
                            <th style="display:none;">                                                         
                            </th>
                        
                            <xsl:for-each select="$output">
                                <th>
                                    <strong>
                                        <xsl:variable name="tag" select=" ./text() "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>
                                    </strong>
                                </th>
                            </xsl:for-each>                
                            <th></th>  <!--for lock key,impotred doc and info -->                          
                        </tr>
                    </thead>
                    <tbody>

                        <xsl:for-each select="//result">
					
                            <xsl:variable name="pos">
                                <xsl:value-of select="./@pos"/>
                            </xsl:variable>
						
                            <tr class="resultRow">
                                <td class="invisible" >
                                    <xsl:value-of select="./hiddenResults/FileId/text()"/>
                                </td>                                                
                          
                                <xsl:for-each select="./*[name() != 'FileId' and name() !=  'info' and name()!='hiddenResults']">
                                    <xsl:choose>
                                        <xsl:when test="name() = 'info' and ./info/text() != '' ">
                                            <xsl:variable name="Info" select="./*[1]"/>
                                            <td>
                                                <xsl:variable name="tag" select=" 'Emfanisi' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <a id="showInfo_{$pos}" href="javascript:void(0)" onClick="showInfo('{$pos}')" onMouseOver="return escape('{$Info/text()}')">
                                                    <xsl:value-of select="$translated"/>
                                                </a>
                                                <div id="info_{$pos}" style="display:none">
                                                    <xsl:variable name="tag" select=" 'Apokripsi' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <a href="javascript:void(0)" onClick="hideInfo('{$pos}')">
                                                        <xsl:value-of select="$translated"/>
                                                    </a>
                                                    <br/>
                                                    <xsl:value-of select=" $Info/text()"/>
                                                </div>
                                            </td>
                                        </xsl:when>
                                        <xsl:when test="name() ='filename'">    
                                            <xsl:variable name="uriId" select="./filename/text()"/>                                   
                                            <td title="{concat($URI_Reference_Path,$uriId)}" >
                                                <xsl:value-of select="$uriId"/>
                                            </td>                                          
                                        </xsl:when>
                                        <xsl:when test="name() ='ShortDescription'">    
                                            <xsl:variable name="description" select="./ShortDescription/text()"/>                                   
                                            <td title="{$description}" >
                                                <xsl:variable name="short_description" select="substring($description,1,15)"/>                                   
                                                <xsl:value-of select="$short_description"/>
                                                <xsl:if test="$short_description!=''and $short_description!=$description" >
                                                    <xsl:value-of select="'...'"/>
                                                </xsl:if> 
                                            </td>                               
                                        </xsl:when>
                                        <xsl:when test="name() ='general_description'">    
                                            <xsl:variable name="general_description" select="./general_description/text()"/>                                   
                                            <td title="{$general_description}" >
                                                <xsl:variable name="short_description" select="substring($general_description,1,120)"/>                                   
                                                <xsl:value-of select="$short_description"/>
                                                <xsl:if test="$short_description!=''and $short_description!=$general_description" >
                                                    <xsl:value-of select="'...'"/>
                                                </xsl:if> 
                                            </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td>
                                                <xsl:for-each select="./*">
                                                    <xsl:if test="position() > 1">
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:if test=" name() = 'status' ">                                                   
                                                        <xsl:variable name="tag" select=" ./text() "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <xsl:value-of select="$translated"/>
                                                    </xsl:if>
                                                    <xsl:if test=" name() != 'status' ">
                                                        <xsl:value-of select="./text()"/>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>		  	
                                <td>
                                    <xsl:if test="$EntityCategory='secondary' and $IsGuestUser = 'false' and $user!='sysadmin'">
                                        <xsl:choose>
                                            <xsl:when test="./hiddenResults/organization/text()!=$userOrg or ./hiddenResults/hasPublicDependants/text()!='false' ">
                                                <xsl:variable name="tag" select="'CANNOT_EDIT'"/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <img  class="tooltipInfo" title="{$translated}" border="0"  src="formating/images/lock.png"/>
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>                                 
                                    <xsl:if test="$EntityCategory='primary' and $IsGuestUser = 'false' and $user!='sysadmin'">
                                        <xsl:choose>
                                            <xsl:when test="(./status/status/text()='published' or ./status/status/text()='pending' ) or ./hiddenResults/userHasWrite/text()!='true' ">
                                                <xsl:variable name="tag" select="'CANNOT_EDIT'"/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <img class="tooltipInfo" title="{$translated}" border="0"  src="./formating/images/lock.png"/>
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>
                                    <xsl:if test="$IsGuestUser = 'false' and $user!='sysadmin'">
                                        <xsl:choose>
                                            <xsl:when test="./hiddenResults/isImported/text()!='false' ">
                                                <xsl:variable name="tag" select="'imported'"/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <img class="tooltipInfo" title="{$translated}" border="0"  src="./formating/images/import.png"/>
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>
                                    <xsl:if test="./hiddenResults/versionId/text()&gt;1">
                                        <xsl:variable name="tag" select="'VersionId'"/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <img class="tooltipInfo" title="{concat($translated, ': ' , ./hiddenResults/versionId/text())}" border="0"  src="./formating/images/version.png"/>                                    
                                    </xsl:if>
                                    <xsl:if test=" $DocStatus != 'published' and $DocStatus != 'org' ">
                                        <xsl:if test=" $EntityCategory='primary'">
                                            <xsl:choose>
                                                <xsl:when test=" ./info/info/text() != '' ">
                                                    <xsl:variable name="tag" select=" 'info' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                                                 
                                                    <xsl:choose>
                                                        <xsl:when test=" ./info/info/text() = 'REJECTED_NO_COMMENT' ">
                                                            <xsl:variable name="tag" select="./info/info/text()"/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <a class="tooltipInfo" rel="tooltip" href="#" data-toggle="tooltip" title="{$translated}">                                                        
                                                                <img border="0" src="formating/images/info.png"/>	
                                                            </a>                                                        
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <a class="tooltipInfo" href="#" data-toggle="tooltip" title="{./info/info/text()}">                                                        
                                                                <img border="0" src="formating/images/info.png"/>	
                                                            </a>     
                                                        </xsl:otherwise>
                                                    </xsl:choose>                                                   
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:if>
                                </td>                                                                             
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
      
            </div>
        </div>	


    </xsl:template>
</xsl:stylesheet>
