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

<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" version="2.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../../ui/page.xsl"/>

    <xsl:variable name="AdminAction" select="//context/AdminAction"/>
    <xsl:variable name="VocFile" select="//context/VocFile"/>
    <xsl:variable name="VocFileName" select="//context/VocFileName"/>
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
    <xsl:variable name="EntityXMLFile" select="//context/EntityXMLFile"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>	
    <xsl:variable name="TermValue" select="//context/tValue"/>
    <xsl:variable name="TermId" select="//context/tId"/>
    <xsl:variable name="Msg" select="//context/Msg"/>
    

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:if test="$AdminAction='list'">
            <xsl:call-template name="actions"/>
        </xsl:if>
        <div class="row context">
            <script type="text/javascript">
                var ret=false;
                <xsl:variable name="tag" select=" 'NoTerm' "/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                var noTermStr = '<xsl:value-of select="$translated"/>';

                <xsl:variable name="tag" select=" 'TermExists' "/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                var termExistsStr = '<xsl:value-of select="$translated"/>';
                                
                <xsl:variable name="tag" select=" 'PromptMessage' "/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                var str = '<xsl:value-of select="$translated"/>';
            </script>
  
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:value-of select="$VocFileName"/>        
                </h4>
                <div  id="fileType" style="display:none;"> 
                    <xsl:value-of select="$VocFile"/> 
                </div>
                <table id="results">
                    <thead>
                        <tr class="contentHeadText">
                            <th style="display:none;">                                                         
                            </th>
                            <th>
                                <xsl:variable name="tag" select=" 'Oroi' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                         
                                <xsl:value-of select="$translated"/>                         
                            </th>
                               
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//Όρος">
                            <xsl:variable name="ID" select="./@id"/>
                            <tr class="resultRow">
                                <td class="invisible">
                                    <xsl:value-of select="./@id"/>
                                </td>                                  
                                <td>
                                    <input type="hidden" id="term" name="term" value="{./text()}"></input>
                                    <xsl:value-of select="./text()"/>
                                </td>                                   
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
                         
            </div>
        </div>
        <xsl:if test="$AdminAction ='insert' or $AdminAction =  'edit'">
            <div class="row">            
                <div class="col-sm-12 col-md-12 col-lg-12">
                    <h4 class="title">
                        <xsl:value-of select="$VocFileName"/>        
                    </h4>
                    <h5 class="subtitle">
                        <xsl:variable name="tag">
                            <xsl:choose>
                                <xsl:when test="$AdminAction='insert'">
                                    <xsl:value-of select=" 'Eisagwgi' "/>
                                </xsl:when>
                                <xsl:when test="$AdminAction='edit'">
                                    <xsl:value-of select=" 'Epexergasia' "/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>                            
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <xsl:value-of select="$translated"/>                            
                    </h5>
                    <form id="newTermForm" method="post" onsubmit="ret=addNewVocTerm(getObj('newterm').value, 'AdminVoc?action={$AdminAction}&amp;menuId={$EntityType}', noTermStr, termExistsStr); return ret;">

                        <div id="addNewTerm"  class="row">
                            <div class="col-sm-2 col-md-2 col-lg-2">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select=" 'NeosOros' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:                           
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-10 col-md-10 col-lg-10">
                                <p>
                                    <input id="newterm" class="inputwidth" type="text" name="newterm" value="{$TermValue}" required="true"/>
                                </p>
                            </div>               
                        </div>
                        <input type="hidden" name="EntityXMLFile" value="{$EntityXMLFile}"></input>
                        <input type="hidden" id="id" name="id"  value="{$TermId}"></input>
                        <input type="hidden" name="file" value="{$VocFile}"></input>
                        <xsl:variable name="tag" select=" 'Kataxwrisi' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                            <xsl:value-of select="$translated"/>
                        </button>        
                    </form>               
                </div>
            </div>
        </xsl:if>
        <script type="text/javascript">
            
            $(document).ready(function(){

            if('<xsl:value-of select="$AdminAction"/>'=="edit" || '<xsl:value-of select="$AdminAction"/>'=="insert"){                   
            $('.context').css('display','none'); 
            }
            });
        </script>
      
    </xsl:template>
</xsl:stylesheet>
