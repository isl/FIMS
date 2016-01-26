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

    <xsl:variable name="ErrorMsg" select="//context/ErrorMsg"/>
    <!--xsl:variable name="lang" select="//page/@language"/-->


    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <div class="row"> 
            <div class="col-md-8 col-lg-8 col-md-offset-4">                
                <div class="row account-wall">
                    <xsl:variable name="tag" select=" 'UserLogin' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <h4>                                    
                        <xsl:value-of select="$translated"/>
                    </h4>
                    <form action="Login" method="post" class="form-signin">
                        
                        <xsl:variable name="tag" select=" 'username' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <input type="text" class="form-control" placeholder="{$translated}" required="true"   name="username"/>
                        <xsl:variable name="tag" select=" 'password' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <input type="password" class="form-control" placeholder="{$translated}" required="true" name="password"/>
                        <xsl:if test="$ErrorMsg!=''">
                            <xsl:variable name="tag" select="$ErrorMsg"/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <p>
                                <h7 style="color:red;"> 
                                    <xsl:value-of select="$translated"/>
                                </h7>
                            </p>
                            
                        </xsl:if>
                        <xsl:variable name="tag" select=" 'SignIn' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <button class="btn btn-default .btn-sm" type="submit">                                    
                            <xsl:value-of select="$translated"/>
                        </button>
                        <ul id="login-list">
                            <xsl:if test="//context/signUp/text() = 'true'">
                                
                                <li>
                                    <xsl:variable name="tag" select=" 'SignUp' "/> 
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                                    <a href="SignUp?lang={$lang}"> 
                                        <xsl:value-of select="$translated"/>
                                    </a>
                                </li>
                            </xsl:if>
                            <li>
                                <xsl:variable name="tag" select=" 'ForgetPass' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <a href="ForgetPass?lang={$lang}">                            
                                    <xsl:value-of select="$translated"/>
                                </a>
                            </li>
                        </ul>
                        <span class="clearfix"/>
                    </form>
                </div>
            </div>
        </div>        
    </xsl:template>
</xsl:stylesheet>