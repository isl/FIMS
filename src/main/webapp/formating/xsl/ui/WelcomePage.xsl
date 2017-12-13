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
    <xsl:include href="page.xsl"/>
    <xsl:include href="../utils/utils.xsl"/>
    <xsl:include href="../entity/view_dependancies.xsl"/>

    
    <xsl:variable name="DisplayError" select="//context/DisplayError"/>
    <xsl:variable name="Display" select="//context/Display[1]"/>
    <xsl:variable name="Unlock" select="//context/Unlock"/>
    <xsl:variable name="GoOnImport" select="//context/GoOnImport"/>
    <xsl:variable name="Owner" select="//context/Owner"/>
    <xsl:variable name="Welcome" select="//Welcome"/>
    <xsl:variable name="result"  select="//context/query/results"/>
    
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    
    <xsl:template name="context">
        <script type="text/javascript">
            $(document).ready(function(){
            h = $('#content').height();
            $('#displayRow').height(h);
            });
        </script>
        <div class="my-row special" id="displayRow">
            <div class="v-m text-center">
                
                <xsl:choose>
                    <xsl:when test="$Welcome='yes'">
                        <img id="welcomeImage" class="img-responsive"  src="{ concat('formating/images/welcomeImage_', $lang, '.png') }"></img> 
                    </xsl:when>
                    <xsl:otherwise>
                        <p class="displayParagraph">    
                            <b>
                                <xsl:call-template name="replaceNL_Translate">
                                    <xsl:with-param name="string" select="$Display"/>
                                </xsl:call-template>
                            </b>
                            <xsl:if test="$Display='IS_EDITED_BY_USER'">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$Owner"/>
                            </xsl:if>
                            <xsl:if test="contains($Display,'URI_ID')">
                                :<xsl:text> </xsl:text>
                                <xsl:for-each select="//context/codeValue">
                                    <b>
                                        <xsl:value-of select="./text()"/>
                                        <br></br>
                                    </b>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test=" $Unlock != 'false'">
                                <xsl:variable name="tag" select=" 'SinexeiaEpexergasiasMsg' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:call-template name="replaceNL">
                                    <xsl:with-param name="string" select="$translated"/>
                                </xsl:call-template>                              
                            </xsl:if>
                            <xsl:if test=" $GoOnImport != 'false'  ">
                                <xsl:variable name="tag" select=" 'SinexeiaEisagwgisMsg' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <font>
                                    <xsl:call-template name="replaceNL">
                                        <xsl:with-param name="string" select="$translated"/>
                                    </xsl:call-template>
                                </font>                               
                            </xsl:if>
                        </p>
                        <p class="displayButtons">
                            <xsl:variable name="tag" select=" 'Epistrofi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <xsl:choose>
                                <xsl:when test="//context/backPages!=''">
                                    <a class="btn btn-default .btn-sm displayButton" href="{//context/backPages}">
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a class="btn btn-default .btn-sm displayButton" href="javascript:window.history.go(-1);">
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>                    
                          
                            <xsl:choose>
                                <xsl:when test="$Unlock != 'false'">
                                    <xsl:variable name="tag" select=" 'SinexeiaEpexergasias' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <a class="btn btn-default .btn-sm displayButton" href="{$Unlock}">
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </xsl:when>
                                <xsl:when test="$GoOnImport != 'false'">
                                    <xsl:variable name="tag" select=" 'SinexeiaEisagwgis' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <a class="btn btn-default .btn-sm displayButton" href="{$GoOnImport}">
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </xsl:when>
                                <xsl:when test="$result != ''"> 
                                    <xsl:variable name="tag" select=" 'ViewDependencies' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <a class="btn btn-default .btn-sm displayButton" href="#" onclick="javascript: $('#displayRow').remove(); toggleVisibility(document.getElementsByClassName('dependants'));">
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </xsl:when>
                            </xsl:choose>
                        </p>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
        <xsl:if test="$result != ''">
            <xsl:call-template name="view_dependants"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>