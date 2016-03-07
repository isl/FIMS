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
    <xsl:template name="footer">
        <xsl:variable name="espaLogo" select="//context/espaLogo/text()"/>

        <div class="row">
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2 footerCopy">
                <img style="float:left;" class="img-responsive" src="formating/images/copyright.png"></img>
                <p class="footerText">
                    <xsl:variable name="tag" select=" 'text2' "/>
                    <xsl:variable name="translated" select="$locale/footer/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>     
                    <xsl:variable name="tag" select=" 'text3' "/>
                    <xsl:variable name="translated" select="$locale/footer/*[name()=$tag]/*[name()=$lang]"/>
              
                    <xsl:value-of select="$translated"/>
                </p>
            
            </div>
            <xsl:if test="$locale/footer/*[name()='text5']/*[name()=$lang]!=''">  
                <div class="col-xs-4 col-sm-4  col-md-2 col-lg-2 footerCopy">               
                    <img style="float:left;" class="img-responsive" src="formating/images/creativeCommons.png"></img>
                    <p class="footerText">
                        <xsl:variable name="tag" select=" 'text5' "/>
                        <xsl:variable name="translated" select="$locale/footer/*[name()=$tag]/*[name()=$lang]"/>
                        <xsl:value-of select="$translated"/> 
                    </p>
                </div>
          
            </xsl:if>
        </div>
        <div class="row">
            <xsl:choose>
                <xsl:when test="$espaLogo='true'">
                    <div class="col-xs-3 col-sm-3 col-md-3 col-lg-4 ">
                        <xsl:choose>
                            <xsl:when test="$lang!='en' and $lang!='gr'">
                                <img class="img-responsive" src="formating/images/espa_en.png"></img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img class="img-responsive" src="{ concat('formating/images/espa_', $lang, '.png') }"></img>
                            </xsl:otherwise>
                        </xsl:choose>                         
                    </div> 
                    <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 col-xs-offset-1  col-md-offset-1 col-lg-offset-1" id="forth_img_col">
                        <xsl:choose>
                            <xsl:when test="$lang!='en' and $lang!='gr'">
                                <a href="http://www.ics.forth.gr/"  target="_blank">
                                    <img class="img-responsive" id="forthImg" src="formating/images/forth_en.png"></img>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="http://www.ics.forth.gr/" target="_blank">
                                    <img class="img-responsive" id="forthImg" src="{ concat('formating/images/forth_', $lang, '.png') }"></img>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>                         
                    </div>
                </xsl:when>
                <xsl:otherwise>                    
                    <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 col-xs-offset-3 col-md-offset-5 col-lg-offset-5">
                        <xsl:choose>
                            <xsl:when test="$lang!='en' and $lang!='gr'">
                                <a href="http://www.ics.forth.gr/" target="_blank">
                                    <img class="img-responsive" id="forthImg" src="formating/images/forth_en.png"></img>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="http://www.ics.forth.gr/" target="_blank">
                                    <img class="img-responsive" id="forthImg" src="{ concat('formating/images/forth_', $lang, '.png') }"></img>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>                         
                    </div>
                </xsl:otherwise>
            </xsl:choose>
             
                                     
                    
            <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                <xsl:choose>
                    <xsl:when test="$lang!='en' and $lang!='gr'">
                        <a href="http://www.ics.forth.gr/isl" target="_blank">
                            <img class="img-responsive" src="formating/images/isl_en.png"></img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="http://www.ics.forth.gr/isl" target="_blank">
                            <img class="img-responsive" src="{ concat('formating/images/isl_', $lang, '.png') }"></img>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>                         
            </div>
             <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                <xsl:choose>
                    <xsl:when test="$lang!='en' and $lang!='gr'">
                        <a href="https://www.ics.forth.gr/isl/index_main.php?l=e&amp;c=252" target="_blank">
                            <img class="img-responsive" src="formating/images/cci_en.png"></img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="https://www.ics.forth.gr/isl/index_main.php?c=252" target="_blank">
                            <img class="img-responsive" src="{ concat('formating/images/cci_', $lang, '.png') }"></img>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>                         
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>