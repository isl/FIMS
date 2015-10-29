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
        <td colSpan="{$columns}" vAlign="top" class="content">
            <xsl:call-template name="actions"/>
            <br/>
            <script type="text/JavaScript">
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
            <div align="center" class="divA" >
                <xsl:value-of select="$VocFileName"/>               
            </div>
            <br/>
            <div  id="fileType" style="display:none;"> 
                <xsl:value-of select="$VocFile"/> 
            </div>
            <form id="newTermFrm" method="post" onsubmit="ret= addNewVocTerm(getObj('newterm').value, 'AdminVoc?action={$AdminAction}&amp;menuId={$EntityType}', noTermStr, termExistsStr); alertMsg(ret);  return ret;">
                <div style="text-align:center;" align="center">
                    <br/>
                    <table border="0" id="results" class="results" cellspacing="2">
                        <thead>
                            <tr align="center" class="contentHeadText">
                                <th style="display:none;">                                                         
                                </th>
                                <th align="center" valign="middle">
                                    <xsl:variable name="tag" select=" 'Oroi' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <b>
                                        <xsl:value-of select="$translated"/>
                                    </b>
                                </th>
                               
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//Όρος">
                                <xsl:variable name="ID" select="./@id"/>
                                <tr id="resultRow" align="left" valign="middle" class="resultRow">
                                    <td class="invisible">
                                        <xsl:value-of select="./@id"/>
                                    </td>
                                  
                                    <td align="center" valign="middle">
                                        <input type="hidden" id="term" name="term" value="{./text()}"></input>
                                        <xsl:value-of select="./text()"/>
                                    </td>                                   
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
                <br/>				
                <input type="hidden" name="EntityXMLFile" value="{$EntityXMLFile}"></input>
                <div id="addNewTerm" align="center" style="visibility:hidden;">
                    <table border="0">
                        <tr>
                            <xsl:variable name="tag" select=" 'NeosOros' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td class="divA" style="padding-right:10px;">
                                <xsl:value-of select="$translated"/>
                            </td>
                            <td vAlign="top">
                                <input type="text" id="newterm" name="newterm" style="width:250px;margin-right:10px;" value="{$TermValue}"></input>
                                <input type="hidden" id="id" name="id" style="width:250px" value="{$TermId}"></input>
                                <input type="hidden" name="file" value="{$VocFile}" class="button"></input>
                                <xsl:variable name="tag" select=" 'Kataxwrisi' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <input style="text-align:center;" type="submit" value="{$translated}" class="button"></input>
                            </td>
                        </tr>
                    </table>
                </div>
                <script language="javascript">getObj('newterm').focus();</script>
            </form>   
            <script type="text/javascript">
                function alertMsg(ret){
                if(ret){
                
                if('<xsl:value-of select="$AdminAction"/>'=="insert"){                            
                <xsl:variable name="tag" select="'TERM_ADD_SUCCESS'"/>  
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                var msg='<xsl:value-of select="$translated"/>';
                alert(msg);
                }else if('<xsl:value-of select="$AdminAction"/>'=="edit"){
                <xsl:variable name="tag" select="'TERM_UPDATE_SUCCESS'"/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                var msg='<xsl:value-of select="$translated"/>';
                alert(msg);
                }                       
                }
                }
                if('<xsl:value-of select="$AdminAction"/>'=="edit" || '<xsl:value-of select="$AdminAction"/>'=="insert"){                   
                var elemID= document.getElementById('addNewTerm');    
                elemID.style.visibility='visible'; 
                }
            </script>                              
        </td>
    </xsl:template>
</xsl:stylesheet>
