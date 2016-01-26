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
    <xsl:template name="leftmenu">
        <xsl:variable name="EntityType" select="//context/EntityType"/>
        <xsl:variable name="user" select="//page/@UserRights"/>
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">

                <nav>
                    <ul class="nav">
                        <xsl:for-each select="//leftmenu/menugroup[menu/userRights=$user]">
                            <xsl:variable name="tag" select="./label"/>
                            <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>                          
                            <li class="nav-header">
                                <xsl:value-of select="$translated"/>
                            </li>
                            <xsl:for-each select="./menu[userRights=$user]">
                                <xsl:variable name="tag" select="./label"/>
                                <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>                        
                                <li>
                                    <xsl:choose>
                                        <xsl:when test="count(./submenu)=0">
                                            <xsl:choose>
                                                <xsl:when test="./@id=$EntityType">
                                                    <a class="selected"> 
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="string(./userRights[text()=$user]/@href)"/>
                                                        </xsl:attribute>   
                                                        <xsl:attribute name="target">
                                                            <xsl:value-of select="string(./userRights[text()=$user]/@target)"/>
                                                        </xsl:attribute>                                  
                                                        <xsl:value-of select="$translated"/>
                                                    </a>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="string(./userRights[text()=$user]/@href)"/>
                                                        </xsl:attribute> 
                                                        <xsl:attribute name="target">
                                                            <xsl:value-of select="string(./userRights[text()=$user]/@target)"/>
                                                        </xsl:attribute>                                     
                                                        <xsl:value-of select="$translated"/>
                                                    </a>   
                                                </xsl:otherwise>                                            
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>                                            
                                            <a href="#" id="btn-{position()}" data-toggle="collapse" data-target="#submenu{position()}" aria-expanded="false">
                                                <xsl:value-of select="$translated"/>
                                                <span class="caret"/>                          
                                            </a>
                                            <ul class="collapse nav submenu" id="submenu{position()}" role="menu" aria-labelledby="btn-{position()}">
                                                <xsl:for-each select="./submenu[userRights=$user]">  
                                                    <xsl:variable name="tag" select="./label"/>
                                                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>   
                                                    <li>
                                                        <xsl:choose>
                                                            <xsl:when test="./@id=$EntityType">    
                                                                <script>$('.submenu').addClass('in');</script>                                      
                                                                <a class="selected">
                                                                    <xsl:attribute name="href">
                                                                        <xsl:value-of select="string(./userRights[text()=$user]/@href)"/>
                                                                    </xsl:attribute>                                    
                                                                    <xsl:value-of select="$translated"/>
                                                                </a>     
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <a>
                                                                    <xsl:attribute name="href">
                                                                        <xsl:value-of select="string(./userRights[text()=$user]/@href)"/>
                                                                    </xsl:attribute>                                    
                                                                    <xsl:value-of select="$translated"/>
                                                                </a>     
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                                                                        
                                                    </li>                                               
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:otherwise>
                                    </xsl:choose>   
                                </li>                                
                            </xsl:for-each>
                            <xsl:if test="position()!=last()">
                                <li style="padding-bottom:20px;"></li>
                            </xsl:if>  
                        </xsl:for-each>
                    </ul>
                </nav>
            </div>
        </div>      
    </xsl:template>
</xsl:stylesheet>