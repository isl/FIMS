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
    <xsl:include href="page.xsl"/>
    <xsl:variable name="emailMsg" select="$locale/context/NotValidEmail/*[name()=$lang]"/>
    <xsl:include href="../utils/utils.xsl"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>        
    </xsl:template>    
    <xsl:template name="context">
        <div class="row"> 
            <div class="col-md-8 col-lg-8 col-md-offset-4">
               
                <div class="row account-wall">
                    <xsl:variable name="tag" select=" 'ForgetPass'"/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <h4>                                    
                        <xsl:value-of select="$translated"/>
                    </h4>   
                    <h8>
                        <xsl:variable name="tag" select=" 'EmailPrompt' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <xsl:value-of select="$translated"/>
                    </h8>                  
                    <form action="ForgetPass" method="post" class="form-signin">
                        <xsl:variable name="tag" select=" 'email' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <input type="email" class="form-control" placeholder="{$translated}*" required="true"   name="email"/>
                        <xsl:variable name="tag" select=" 'Oloklirwsi' "/> 
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                        <input type="hidden" name="lang" value="{$lang}"/>
                        <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                            <xsl:value-of select="$translated"/>
                        </button>                                
                        <span class="clearfix"/>
                    </form>
                    <xsl:if test="//context/Display!=''">
                        <p>
                            <h7 style="color:red;"> 
                                <xsl:call-template name="replaceNL_Translate">
                                    <xsl:with-param name="string" select="//context/Display"/>
                                </xsl:call-template>                                       
                            </h7>
                        </p>                     
                    </xsl:if>        
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>