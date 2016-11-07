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
    <xsl:template name="header">
        
        <xsl:variable name="tag" select=" 'User_Manual' "/>
        <xsl:variable name="User_Manual" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/>  
        <xsl:variable name="tag" select=" 'Guest_Manual' "/>
        <xsl:variable name="Guest_Manual" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/> 
        <xsl:variable name="tag" select=" 'Admin_Manual' "/>
        <xsl:variable name="Admin_Manual" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/> 
        <xsl:variable name="tag" select=" 'SysAdmin_Manual' "/>
        <xsl:variable name="SysAdmin_Manual" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/>
        <xsl:variable name="topmenus" select="//topmenu/menugroup/menu"/>
        <xsl:variable name="image" select="string(//topmenu/menugroup/@img_src)"/>
        <xsl:variable name="contactEmail" select="//context/contactEmail/text()"/>
        <xsl:variable name="tag" select="'contactEmail'"/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
        <script language="JavaScript">

            $(document).ready(function () {
    
            $('#contact').qtip({
            content: {
            text: '<xsl:value-of select="$contactEmail"/>',
            title: '<xsl:value-of select="$translated"/>',
            button: 'Close'
            },
            hide: {
            event: false
            },
            style: {
            classes: 'qtip-dark',
      
            }
    
            });
    
            });   
        </script>
    
        <div class="col-xs-12" id="header">

            <ul class="nav navbar-nav nav navbar-right" id="myNavHeader">
      
                <xsl:if test="$contactEmail!=''">
                    <li class="headerDropDown">
                        <a href="#">
                            <img id="contact" src="formating/images/contact.png"/>
                        </a>
                    </li>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$user!=''">
                        <xsl:for-each select="$topmenus">   
                            <li class="headerDropDown">
                                <a href="#" data-toggle="dropdown" class="dropdown-toggle"> 
                                    <img src="{./@img_src}"/>    
                                    <xsl:text> </xsl:text>
                                    <xsl:if test="@id='settings'">
                                        <xsl:value-of select="$fullname"/>
                                    </xsl:if>
                                    <xsl:text> </xsl:text>    
                                    <span class="caret"></span>
                                </a>
                                <ul id="insideHeaderDrop" class="dropdown-menu" role="menu" aria-labelledby="menu1">
                                    <xsl:for-each select="./submenu/action">   
           
                                        <li role="presentation">
                                            <xsl:variable name="langArg">
                                                <xsl:choose>                                          
                                                    <xsl:when test="../@id='help' and @id='Help_all'">
                                                        <xsl:choose>
                                                            <xsl:when test="$lang='gr' or $lang='en'">
                                                                <xsl:value-of select="$lang"/> 
                                                                <xsl:text>/manual.pdf</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$lang"/>
                                                                <xsl:text>/manual.html</xsl:text>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                       <xsl:when test="../@id='help' and @id='Help'">
                                                                <xsl:text>/Help.pdf</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="''"/> 
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>  
                                            <a>
                                                <xsl:if test="../@id='help'">
                                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                                </xsl:if>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="./@href"/>
                                                    <xsl:value-of select="$langArg"/>
                                                </xsl:attribute>
                                
                                                <xsl:variable name="tag" select="."/>
                                                <xsl:variable name="translated" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>  
                                            </a>            
                                        </li>   
                                    </xsl:for-each>
                                                   
                                </ul>
                            </li>  
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="count(//context/Langs/Lang) &gt; 1">
                            <li class="headerDropDown" style="top:-3px;">
                                <a href="#" data-toggle="dropdown" class="dropdown-toggle"> 
                                    <xsl:variable name="tag" select=" $lang "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>
                                    (<xsl:value-of select="$lang"/>)<xsl:text> </xsl:text>
                                    <span class="caret"></span> 
                                </a>
                                <ul id="outsideHeaderDrop" class="dropdown-menu" role="menu" aria-labelledby="menu1">
                                    <xsl:for-each select="//context/Langs/Lang">
                                        <li role="presentation">
                                            <a href="SetLanguage?lang={./text()}">
                                                <xsl:variable name="tag" select="./text()"/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$tag]"/>
                                                <xsl:value-of select="$translated"/> (<xsl:value-of select="./text()"/>)
                                            </a>                            
                                        </li>
                       
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>  
        </div>
        <img class="img-responsive" src="{ concat('formating/images/header_', $lang, '.png') }"></img>
    </xsl:template>
</xsl:stylesheet>