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

    <xsl:variable name="mnemonicName" select="//context/query/info/name/text()"/>
    <xsl:variable name="output" select="//context/query/outputs/path"/>
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
                <form id="saveForm" method="post" action="">

                    <p class="displayParagraph">
                        <b>
                            <xsl:choose>
                                <xsl:when test="//success/@return='1'">                                    
                                    <xsl:variable name="tag" select=" 'EperotisiApothikeutikeEpitixos' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>                             
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="tag" select=" 'EperotisiDenApothikeutikeEpitixos' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/> 
                                    <br></br>
                                    <xsl:variable name="tag" select="//success/text()"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/> 
                                </xsl:otherwise>
                            </xsl:choose>
                        </b>
                    </p>
                    <div class="displayButtons">
                        <xsl:if test="//success/@return='0'">
                            <xsl:variable name="tag" select=" 'Epistrofi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <input type="submit" class="btn btn-default .btn-sm displayButton" name="submit" value="{$translated}"  onClick="submitFormTo('saveForm', 'Search')"/>
                        </xsl:if>                    
                        <xsl:variable name="tag" select=" 'DimiourgiaNeas' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <input type="button" class="btn btn-default .btn-sm displayButton" name="new" value="{$translated}" onclick="location.href='Search?category={//context/query/info/category}'"/>
                    </div>
                           
                    <input type="hidden" name="qid" value="{//context/query/@id}"/>
                    <input type="hidden" name="mnemonicName" value="{//context/query/info/name/text()}"/>
                    <input type="hidden" name="category" value="{//context/query/info/category}"/>
                    <input type="hidden" name="operator" value="{//context/query/info/operator}"/>
                    <input type="hidden" name="source" value="{//context/query/info/source}"/>
                    <input type="hidden" name="status" value="{//context/query/info/status}"/>
                    <xsl:for-each select="//context/query/targets/path[@selected='yes']">
                        <input type="hidden" name="target" value="{./@xpath}"/>
                    </xsl:for-each>
                    <xsl:for-each select="$output">
                        <input type="hidden" name="output" value="{./@xpath}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/inputs/input/selectedXapths">
                        <input type="hidden" name="input" value="{./text()}"/>
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
                    <input type="hidden" name="mode" value="fromSave"/>
                </form>
            </div>
        </div>       
        
    </xsl:template>
</xsl:stylesheet>
