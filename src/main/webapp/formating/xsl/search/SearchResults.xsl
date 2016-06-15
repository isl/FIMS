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

<xsl:stylesheet xmlns:url="http://whatever/java/java.net.URLEncoder" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" version="2.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../ui/page.xsl"/>

    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="SearchMode" select="//context/SearchMode"/>
    <xsl:variable name="output" select="//context/query/outputs/path"/>
    <xsl:variable name="ServletName" select="//context/ServletName"/>
    <xsl:variable name="DocStatus" select="//context/DocStatus"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="EntityCategory" select="//context/EntityCategory"/>
    <xsl:variable name="userOrg" select="//page/@userOrg"/>
    <xsl:variable name="photoType" select="//context/photoType"/>
    <xsl:variable name="IsGuestUser" select="//context/IsGuestUser"/>
    
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

        <xsl:if test="count(//result)&gt;0">
            <xsl:call-template name="actions"/>

            <div class="row context">
                <div class="col-sm-12 col-md-12 col-lg-12">
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">

                            <h4 class="title">
                                <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id=$EntityType]/label/text()"/>
                                <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:value-of select="$translated"/>        
                                <xsl:text> - </xsl:text>
                                <xsl:variable name="tag" select=" 'ApotelesmaEperotisis' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                       
                                <xsl:value-of select="$translated"/>
                            </h4>
                            
                        </div>
                    </div>

                    <xsl:if test="$SearchMode!=''">
                        <xsl:if test="$DocStatus!='' and $DocStatus!='all'">    
                            <xsl:variable name="systemName" select="//context/systemName/text()"/>

                            <p  class="searchResults">
                                <b>
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
                                        <xsl:when test="$DocStatus='unpublished'">
                                            <xsl:variable name="tag" select=" 'ProboliMhDimosieumenwn' "/>
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
                            </p>                    
                        </xsl:if>
                        <p  class="searchResults">
                            <strong>
                                <xsl:variable name="tag" select=" 'MeKritiriaAnazitisis' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                             
                                <xsl:value-of select="$translated"/> :
                            </strong>
                            <xsl:for-each select="//context/query/inputs/input">
                                <xsl:variable name="operatorRealname" select="oper/text()"/>
                               
                                <xsl:value-of select="inputLabel/text()"/>
                                
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="//types/*/operator[text()=$operatorRealname]/@*[name(.)=$lang]"/>
                                <xsl:text> </xsl:text>
                                '
                                <xsl:value-of select="value/text()"/>
                                <xsl:text> </xsl:text>
                                '
                                <xsl:if test="position()!=last()">
                                    ,
                                </xsl:if>
                            </xsl:for-each>	
                        </p>
                        <xsl:if test="//context/query/info/operator!=''">
                            <p  class="searchResults">
                                <strong>
                                    <xsl:variable name="tag" select=" 'Telestis' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                             
                                    <xsl:value-of select="$translated"/> :
                                </strong>                            
                                <xsl:value-of select="//context/query/info/operator"/>
                            </p>
                        </xsl:if>
                        <!--                        <p  class="searchbottom searchResults">
                            <xsl:variable name="tag" select=" 'execTime' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <strong>
                                <xsl:value-of select="$translated"/> :  
                            </strong>
                            <xsl:value-of select="//querytime/text()"/> sec.
                        </p>-->
                    </xsl:if>
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">

                            <table id="results">
                                <thead>
                                    <tr align="center" valign="middle" class="contentHeadText">
                                        <th style="display:none;">                                                         
                                        </th>
                                        <xsl:for-each select="$output">
                                            <th>
                                                <xsl:choose>
                                                    <xsl:when test="$SearchMode=''">
                                                        <strong>
                                                            <!-- ===== edw mia diafora, den pernaei apo translation ===== -->
                                                            <xsl:value-of select="./text()"/>
                                                        </strong>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <strong>
                                                            <!-- =====simple search pernaei apo translation ===== -->
                                                            <xsl:variable name="tag" select="./text()"/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <xsl:value-of select="$translated"/>
                                                        </strong>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </th>
                                        </xsl:for-each>
                                        <xsl:for-each select="//adminParts/title">
                                            <xsl:if test="./text()!='info'">
                                                <th>
                                                    <xsl:variable name="tag" select="./text() "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <strong>
                                                        <xsl:value-of select="$translated"/>
                                                    </strong>
                                                </th>
                                            </xsl:if>

                                        </xsl:for-each>
                             
                                        <th>
                                            <xsl:variable name="tag" select=" 'URI_ID' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <strong>
                                                <xsl:value-of select="$translated"/>
                                            </strong>
                                        </th>
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
                                                <xsl:value-of select="./FileId/text()"/>
                                            </td>
                                    
                                            <xsl:for-each select="./*[name() != 'FileId' and name() !=  'info' and name()!='hiddenResults']"> 
                                                <xsl:choose>
                                                    <xsl:when test=" name() = 'info' and ./info/text() != '' ">
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
                                                    <xsl:when test="name() = 'ΨηφιακόΑρχείο' or name() = 'File' ">
                                                        <xsl:variable name="tag" select=" 'Proboli' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <xsl:variable name="mime" select=".//type/type/text()"/>
                                                        <xsl:variable name="filename" select="./*[1]/text()"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$mime!=''">
                                                                <td>
                                                                    <xsl:choose>
                                                                        <!--xsl:when test=" preceding-sibling::*[1]/*[1]/text() = 'Φωτογραφία' or preceding-sibling::*[1]/*[1]/text() = 'Σχέδιο'  "-->
                                                                        <xsl:when test="$mime = 'Photos'">
                                                                            <xsl:choose>
                                                                                <xsl:when test=" ./*[1]/text() != '' ">
                                                                                    <a href="FetchBinFile?mime={$mime}&amp;type={$photoType}&amp;depository=disk&amp;file={encode-for-uri(./*[1]/text())}"  target="blank_">
                                                                                        <img src="FetchBinFile?mime={$mime}&amp;size=small&amp;type={$photoType}&amp;depository=disk&amp;file={encode-for-uri(./*[1]/text())}" border="1" alt="{$translated}" width="50"></img>
                                                                                    </a>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <img src="FetchBinFile?mime={$mime}&amp;type={$photoType}&amp;depository=disk&amp;file=empty_photo.gif" alt="{$translated}" width="50"></img>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:if test=" ./*[1]/text() != '' ">
                                                                                <a href="FetchBinFile?mime={$mime}&amp;type={$photoType}&amp;depository=disk&amp;file={encode-for-uri(./*[1]/text())}" alt="{$translated}" target="blank_">
                                                                                    <xsl:value-of select="$translated"/>
                                                                                </a>
                                                                                <!--a href="uploads/Archive/{./*[1]/text()}" alt="{$translated}" target="blank_"><xsl:value-of select="$translated"/></a-->
                                                                            </xsl:if>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </td>
                                                            </xsl:when>       
                                                            <xsl:otherwise>
                                                                <td>
                                                                    <a href="FetchBinFile?mime=Photos&amp;type={$photoType}&amp;depository=disk&amp;file={encode-for-uri(./*[1]/text())}" target="blank_">
                                                                        <!--Samarita Servlet attempt-->                                                               
                                                                        <img src="FetchBinFile?mime=Photos&amp;type={$photoType}&amp;size=small&amp;depository=disk&amp;file={encode-for-uri(./*[1]/text())}" border="1" alt="{$translated}" width="50"></img>
                                                                    </a>
                                                                </td>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
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
                                                            <img class="tooltipInfo" title="{$translated}" border="0"  src="formating/images/lock.png"/>
                                                        </xsl:when>                                        
                                                    </xsl:choose>                                    
                                                </xsl:if>                                 
                                                <xsl:if test="$EntityCategory='primary' and $IsGuestUser = 'false' and $user!='sysadmin'">
                                                    <xsl:choose>
                                                        <xsl:when test="(./status/status/text()='published' or ./status/status/text()='pending' ) or ./hiddenResults/userHasWrite/text()!='true' ">
                                                            <xsl:variable name="tag" select="'CANNOT_EDIT'"/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <img class="tooltipInfo" title="{$translated}" border="0"  src="formating/images/lock.png"/>
                                                        </xsl:when>                                        
                                                    </xsl:choose>                                    
                                                </xsl:if>
                                                <xsl:if test="./hiddenResults/versionId/text()&gt;1">
                                                    <xsl:variable name="tag" select="'VersionId'"/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <img class="tooltipInfo" title="{concat($translated, ': ' , ./hiddenResults/versionId/text())}" border="0"  src="./formating/images/version.png"/>                                    
                                                </xsl:if>
                                                <xsl:if test="$IsGuestUser = 'false' and $user!='sysadmin'">
                                                    <xsl:choose>
                                                        <xsl:when test="./hiddenResults/isImported/text()!='false' ">
                                                            <xsl:variable name="tag" select="'imported'"/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <img class="tooltipInfo" title="{$translated}" border="0"  src="formating/images/import.png"/>
                                                        </xsl:when>                                        
                                                    </xsl:choose>                                    
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
                            <xsl:call-template name="searchButton"/>

                        </div>
                    </div>       
                </div>
            </div>                 
        </xsl:if>					
        <xsl:if test="count(//result)&lt;1 or //success/@return!='1'">
            <script type="text/javascript">
                $(document).ready(function(){
                h = $('#content').height();
                $('#displayRow').height(h);
                });
            </script>
            <div class="my-row special" id="displayRow">
                <div class="v-m text-center">

                    <p class="displayParagraph">
                        
                        <xsl:choose>
                            <xsl:when test="count(//result)&lt;1">
                                <xsl:variable name="tag" select=" 'DenBrethikanArxeia' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <b>
                                    <xsl:value-of select="$translated"/>
                                </b>
                            </xsl:when>
                            <xsl:when test="//success/@return!='1'">
                                <xsl:variable name="tag" select="//success/text()"/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <b>
                                    <xsl:value-of select="$translated"/>
                                </b>
                            </xsl:when>
                        </xsl:choose>                         
                    </p> 
                    <div class="displayButtons">
                        <xsl:call-template name="searchButton"/>
                    </div>
                </div>
            </div>
        </xsl:if>
          
    </xsl:template>
    
    <xsl:template name="searchButton">
      
        <xsl:choose>
            <xsl:when test="$SearchMode=''">
                <form id="searchResultsForm" method="post" action="">
                    <xsl:variable name="tag" select=" 'Epistrofi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <input type="submit" class="btn btn-default .btn-sm displayButton" name="return" value="{$translated}" onClick="submitFormTo('searchResultsForm', 'Search?status=all')"/>
                    <input type="hidden" name="qid" value="{//context/query/@id}"/>
                    <input type="hidden" name="mnemonicName" value="{//context/query/info/name/text()}"/>
                    <input type="hidden" name="category" value="{//context/query/info/category}"/>
                    <input type="hidden" name="operator" value="{//context/query/info/operator}"/>

                    <input type="hidden" name="status" value="{//context/query/info/status}"/>
                    <xsl:for-each select="//context/query/inputs/input/selectedXapths">
                        <input type="hidden" name="input" value="{./text()}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/targets/path[@selected='yes']">
                        <input type="hidden" name="target" value="{./@xpath}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/inputs/input/value">
                      
                        <input type="hidden" name="inputvalue" value="{./text()}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/inputs/input/oper">                      
                        <input type="hidden" name="inputoper" value="{./text()}"/>
                    </xsl:for-each>
                    <xsl:for-each select="$output">
                        <input type="hidden" name="output" value="{./@xpath}"/>
                    </xsl:for-each>
                    <input type="hidden" name="mode" value="fromResults"/>
                </form>	
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="tag" select=" 'Epistrofi' "/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                <a class="btn btn-default .btn-sm displayButton" href="javascript:window.history.go(-1);">
                    <xsl:value-of select="$translated"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
