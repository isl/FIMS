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
    <xsl:include href="../../ui/page.xsl"/>
    <xsl:include href="../../paging/SearchPaging.xsl"/>
	
    <xsl:variable name="ListMode" select="//context/ListMode"/>
    <xsl:variable name="DocStatus" select="//context/DocStatus"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="ServletName" select="//context/ServletName"/>
    <xsl:variable name="output" select="//context/query/outputs/path[@selected='yes']"/>
    <xsl:variable name="queryPages" select="//stats/@queryPages"/>
    <xsl:variable name="end" select="//stats/@end"/>
    <xsl:variable name="start" select="//stats/@start"/>
    <xsl:variable name="count" select="//stats/@count"/>
    <xsl:variable name="currentP" select="//stats/@currentP"/>
    <xsl:variable name="pageLoop" select="//pageLoop/lista"/>
    <xsl:variable name="showPages" select="//showPages/show"/>
    <xsl:variable name="userOrg" select="//page/@userOrg"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="EntityCategory" select="//context/EntityCategory"/>
    <xsl:variable name="IsGuestUser" select="//context/IsGuestUser"/>

    <xsl:variable name="step">
        <xsl:value-of select="//stats/@step"/>
    </xsl:variable>	
	
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:variable name="user" select="//page/@UserRights"/>
        <xsl:variable name="EntityType" select="//context/EntityType"/>
        <xsl:variable name="tag" select=" 'PromptMessage' "/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
        <script type="text/JavaScript">    
            var str = '<xsl:value-of select="$translated"/>';
        </script>
        <td colSpan="{$columns}" vAlign="top"  class="content">
            <xsl:call-template name="actions"/>
            <br/>
            <xsl:if test="count(//result)&gt;0">  
				
				
                <table id="results" class="sortable" border="0" align="center" cellspacing="1">
                    <thead>
                        <tr align="center" valign="middle" class="contentHeadText">
                            <!--td>
                                <xsl:variable name="tag" select=" 'Auxwn' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <strong>
                                    <xsl:value-of select="$translated"/>
                                </strong>
                            </td-->
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
					
                            <tr id="resultRow" align="center" valign="middle" class="resultRow">
                                <td class="invisible" >
                                    <xsl:value-of select="./hiddenResults/FileId/text()"/>
                                </td>   
                                <!--td>
                                    <strong>
                                        <xsl:value-of select="$pos"/>
                                    </strong>
                                </td-->
                                <xsl:for-each select="./*[name() != 'FileId' and name() != 'info' and name()!='hiddenResults']">
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
                                                <!--td id="action" class="action" onmouseover="highlight(this, true)" onmouseout="highlight(this, false)"-->
                                                <img border="0"  src="./formating/images/lock.png"/>
                                                <!--/td-->
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>                                 
                                    <xsl:if test="$EntityCategory='primary' and $IsGuestUser = 'false' and $user!='sysadmin'">
                                        <xsl:choose>
                                            <xsl:when test="(./status/status/text()='published' or ./status/status/text()='pending' ) or ./hiddenResults/userHasWrite/text()!='true' ">
                                                <!--td id="action" class="action" onmouseover="highlight(this, true)" onmouseout="highlight(this, false)"-->
                                                <img border="0"  src="./formating/images/lock.png"/>
                                                <!--/td-->
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>
                                    <xsl:if test="$IsGuestUser = 'false' and $user!='sysadmin'">
                                        <xsl:choose>
                                            <xsl:when test="./hiddenResults/isImported/text()!='false' ">
                                                <!--td id="action" class="action" onmouseover="highlight(this, true)" onmouseout="highlight(this, false)"-->
                                                <img border="0"  src="./formating/images/import.png"/>
                                                <!--/td-->
                                            </xsl:when>                                        
                                        </xsl:choose>                                    
                                    </xsl:if>
                                    <xsl:if test=" $DocStatus != 'published' and $DocStatus != 'org' ">
                                        <xsl:if test=" $EntityCategory='primary'">
                                            <xsl:choose>
                                                <xsl:when test=" ./info/info/text() != '' ">
                                                    <xsl:variable name="tag" select=" 'info' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <!--td id="action" class="action" onmouseover="highlight(this, true)" onmouseout="highlight(this, false)" title="{$translated}"-->
                                                    <a class="action" href="javascript:showInfoWin('{$EntityType}', '{./FileId/text()}')">
                                                        <img border="0" src="./formating/images/info.gif"/>												
                                                    </a>
                                                    <!--/td-->
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:if>
                                </td>                                              
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>             
            </xsl:if>            
        </td>
    </xsl:template>
</xsl:stylesheet>
