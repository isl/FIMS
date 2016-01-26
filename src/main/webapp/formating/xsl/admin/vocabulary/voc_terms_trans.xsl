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
    <xsl:variable name="EntityType" select="//context/EntityType"/>	
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
    <xsl:variable name="EntityXMLFile" select="//context/EntityXMLFile"/>
	
    <xsl:variable name="TransId" select="//context/TransId"/>
    <xsl:variable name="Msg" select="//context/Msg"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
        <xsl:if test="$AdminAction='list_trans'">
            <xsl:call-template name="actions"/>
        </xsl:if>
        <div class="row context">
            <script type="text/javascript">                                           
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
                            <xsl:for-each select="//TransLang">
                                <th align="center" valign="middle">
                                    <xsl:variable name="tag" select="./text()"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <b>
                                        <xsl:value-of select="$translated"/>
                                    </b>
                                </th>
                            </xsl:for-each>                               
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//translation">
                            <xsl:variable name="ID" select="./@id"/>
                            <tr class="resultRow">
                                <td class="invisible">
                                    <xsl:value-of select="./@id"/>
                                </td>                                  
                                <xsl:for-each select="./*">
                                    <td>
                                        <input type="hidden" id="term_{name(.)}" name="term_{name(.)}" value="{./text()}"></input>
                                        <xsl:value-of select="./text()"/>
                                    </td>
                                </xsl:for-each>                                    
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
                         
            </div>
        </div>
        <xsl:if test="$AdminAction ='insert_trans' or $AdminAction =  'edit_trans'">
            <div class="row">            
                <div class="col-sm-12 col-md-12 col-lg-12">
                    <h4 class="title">
                        <xsl:value-of select="$VocFileName"/>        
                    </h4>
                    <h5 class="subtitle">
                        <xsl:variable name="tag">
                            <xsl:choose>
                                <xsl:when test="$AdminAction='insert_trans'">
                                    <xsl:value-of select=" 'Eisagwgi' "/>
                                </xsl:when>
                                <xsl:when test="$AdminAction='edit_trans'">
                                    <xsl:value-of select=" 'Epexergasia' "/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>                            
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <xsl:value-of select="$translated"/>                            
                    </h5>
                    <form id="newTermForm" method="post" action="AdminVoc?action={$AdminAction}&amp;menuId={$EntityType}">              
                        <xsl:for-each select="//VocTerms">
                            <div class="row">
                                <div class="col-sm-3 col-md-3 col-lg-3">
                                    <p>
                                        <b>
                                            <xsl:variable name="tag" select=" ./Lang "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>:
                                        </b>
                                    </p>
                                </div>
                                <div class="col-sm-9 col-md-9 col-lg-9">
                                    <xsl:variable name="TermSelected" select="./SelectedTerm"/>

                                    <xsl:variable name="tag" select=" 'Epilogi' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <select  data-placeholder="{$translated}" class="chosen" style="width:45%;" name="trans_{./Lang}">                             
                                        <option value="0"></option> 
                                        <xsl:for-each select="./Όρος">
                                            <option value="{./@id}">
                                                <xsl:if test=" ./@id = $TermSelected ">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="./text()"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>                                
                           
                                </div>
                            </div>
                        </xsl:for-each> 
                  
                        <input type="hidden" name="file" value="{$VocFile}"></input>
                        <input type="hidden"  name="id" value="{$TransId}"></input>
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

            if('<xsl:value-of select="$AdminAction"/>'=="edit_trans" || '<xsl:value-of select="$AdminAction"/>'=="insert_trans"){                   
            $('.context').css('display','none'); 
            }
            jQuery(".chosen").select2();
            if('<xsl:value-of select="$AdminAction"/>'=="edit_trans" || '<xsl:value-of select="$AdminAction"/>'=="insert_trans"){                   
            var elemID= document.getElementById('addNewTerm');    
            elemID.style.visibility='visible'; 
            }
            });
        </script>
       
    </xsl:template>
</xsl:stylesheet>
