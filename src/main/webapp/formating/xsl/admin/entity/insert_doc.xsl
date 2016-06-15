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

    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="AdminAction" select="//context/AdminAction"/>
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>	
    <xsl:variable name="Organization" select="//context/result/Organization/Organization"/>
    <xsl:variable name="OrgId" select="//context/result/Group/group"/> 
  
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
        
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id=$EntityType]/label/text()"/>
                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>        
                    <xsl:text> - </xsl:text>
                    <xsl:variable name="tag" select=" 'Eisagwgi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form action="AdminEntity?type={$EntityType}&amp;action=insert&amp;mode={$AdminMode}" method="post">
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="concat ('PrimaryInsertField',$EntityType) "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="text" name="mainCurrentName"/>
                            </p>
                        </div>
                    </div>
                    <xsl:if test="count(//context/groups/group)&gt;1">
                        <div class="row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select="'Επωνυμία'"/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-9 col-md-9 col-lg-9">
                                <p>                                    
                                    <xsl:variable name="tag" select=" 'AdminOrganization' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                          
                                    <select data-placeholder="{$translated}" style="width:45%;" class="chosen" name="orgId">                                
                                        <xsl:for-each select="//context/groups/group">
                                            <option value="{./id}">
                                                <xsl:if test=" ./id = $OrgId ">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="./name"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>                                
                                </p>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:if test="count(//context/Langs/Lang)&gt;1">
                        <div class="row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select="'Deltiolang'"/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-9 col-md-9 col-lg-9">
                                <p>    
                                    <select data-placeholder="{$translated}" style="width:45%;" class="chosen" name="lang">                                
                                        <xsl:for-each select="//context/Langs/Lang">                                        
                                            <xsl:variable name="tag" select="./text()"/>                                  
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <option value="{./text()}">
                                                <xsl:if test=" $tag = $lang  ">
                                                    <xsl:attribute name="selected">true</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="$translated"/>
                                            </option>  
                                        </xsl:for-each>
                                    </select>                                
                                </p>
                            </div>
                        </div> 
                    </xsl:if>
                    <xsl:if test="count(//context/schemata/schema)&gt;0">
                        <div class="row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select="'target_schema'"/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-9 col-md-9 col-lg-9">
                                <p>    
                                    <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <select  data-placeholder="{$translated}" class="chzn-select" multiple="multiple" style="width:45%;" tabindex="4" id="target_schema" name="target_schema">                             
                                        <option value=""></option> 
                                        <xsl:for-each select="//context/schemata/schema/target_info">                                       
                                            <option  value="{./@id}">
                                                <xsl:value-of select="concat(./target_schema/text(),' ',./target_schema/@version)"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>                                
                                </p>
                            </div>
                        </div> 
                    </xsl:if> 
                    <input type="hidden" name="lang" value="{$lang}"/>
                    <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                        <xsl:value-of select="$translated"/>
                    </button>                      
                </form>
            </div>
            <script type="text/javascript">
                $(document).ready(function(){
                $('.chzn-select').select2();                 
          
                jQuery(".chosen").select2();

                });
            </script>
        </div>       
    </xsl:template>
</xsl:stylesheet>