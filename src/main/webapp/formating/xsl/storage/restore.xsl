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
	
    <xsl:variable name="Action" select="//Action"/>
    <xsl:variable name="restoreFiles" select="//query/outputs/heading"/>
    <xsl:variable name="Space" select="//query/space/text()"/>
		
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:call-template name="actions"/>
        <div class="row context">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <script type="text/JavaScript">
                    <xsl:variable name="tag" select=" 'PromptMessage' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    var str = '<xsl:value-of select="$translated"/>';
                    <xsl:variable name="tag" select=" 'RestoreMSG' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    var strRestore = '<xsl:value-of select="$translated"/>';              
                </script>
                    <table id="results">
                        <thead>
                            <tr class="contentHeadText">
                                <th style="display:none;">                                                         
                                </th>
                                <th style="display:none;">                                                         
                                </th>
                                <th style="display:none;">                                                         
                                </th>
                                <xsl:for-each select="$restoreFiles">
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
                                <xsl:variable name="FileName" select="./filename/text()"/>
                                <xsl:variable name="RestoreMsgDate" select="./date/text()"/>
                                <xsl:variable name="RestoreMsgTime" select="./time/text()"/>
                                <tr class="resultRow" >
                                    <td class="invisible">
                                        <xsl:value-of select="$FileName"/>
                                    </td>
                                    <td id="date" class="invisible">
                                        <xsl:value-of select="$RestoreMsgDate"/>
                                    </td>
                                    <td id="time" class="invisible">
                                        <xsl:value-of select="$RestoreMsgTime"/>
                                    </td>
                               
                                    <xsl:for-each select="./*[name() != 'filename']">
                                        <td>                                           
                                            <xsl:value-of select="./text()"/>
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