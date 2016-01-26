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
	
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
    <xsl:variable name="ListOf" select="//context/ListOf"/>
    <xsl:variable name="output" select="//context/query/outputs/path[@selected='yes']"/>
	
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:variable name="tag" select=" 'PromptMessage' "/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
        <script type="text/JavaScript">
            var str = '<xsl:value-of select="$translated"/>';
        </script>           
        <xsl:call-template name="actions"/>
        <div class="row context">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <table id="results">
                    <xsl:choose>
                        <xsl:when test="$ListOf!='Org'"> 
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
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//result">
                                    <xsl:variable name="ID" select="./Id/Id/text()"/>
                                    <tr class="resultRow">
                                        <td class="invisible" >
                                            <xsl:value-of select="./hiddenResults/FileId/text()"/>
                                        </td>  
                                  
                                        <xsl:for-each select="./*[name() != 'Id' and name()!='hiddenResults' ] ">
                                            <td>
                                                <xsl:for-each select="./*">
                                                    <xsl:if test="position() > 1">
                                                        <br/>
                                                    </xsl:if>
                                                    <xsl:value-of select="./text()"/>
                                                </xsl:for-each>
                                            </td>
                                        </xsl:for-each>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </xsl:when>
                        <xsl:otherwise>
                            <thead>
                                <tr class="contentHeadText">
                                    <th style="display:none;">                                                         
                                    </th>
                                    <xsl:for-each select="$output">
                                        <td>
                                            <strong>
                                                <xsl:variable name="tag" select=" ./text() "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>
                                            </strong>
                                        </td>
                                    </xsl:for-each>							
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//result">
                                    <xsl:variable name="ID" select="./Id/text()"/>
                                    <tr class="resultRow">
                                        <td class="invisible" >
                                            <xsl:value-of select="./hiddenResults/FileId/text()"/>
                                        </td>                                          
                                        <td>
                                            <xsl:value-of select="./name/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./GroupName/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./seat/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./country/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./information/text()"/>
                                        </td>						
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </xsl:otherwise>
                    </xsl:choose>
                </table>
            </div>
        </div>
  
    </xsl:template>
</xsl:stylesheet>
