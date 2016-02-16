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
    <xsl:include href="./page.xsl"/>
    <xsl:include href="../utils/utils.xsl"/>

    <xsl:variable name="schemaVersion" select="//context/schemaVersion"/>
    <xsl:variable name="systemVersion" select="//context/systemVersion"/>
  
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        
        <div class="row" style="line-height: 1;">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'About' "/>
                    <xsl:variable name="translated" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                
                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12 subtitle">
                        <p class="nowrap">
                            <b>
                                <xsl:variable name="tag" select="'contact'"/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:value-of select="$translated"/>        
                            </b>
                        </p>
                    </div>

                
                    <div class="row">
                        <div class="col-sm-2 col-md-2 ol-lg-2 col-md-offset-1  subtitle">
                            <p class="nowrap">
                                <b>
                                    <xsl:variable name="tag" select="'tel'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p class="nowrap">
                                +30-2810-391632/31
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 col-md-2 ol-lg-2 col-md-offset-1  subtitle">
                            <p class="nowrap">
                                <b>
                                    Fax:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p class="nowrap">
                                +30-2810-391638
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 col-md-2 ol-lg-2 col-md-offset-1  subtitle">
                            <p class="nowrap">
                                <b>
                                    <xsl:variable name="tag" select="'email'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p class="nowrap">
                                isl@ics.forth.gr
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2 col-md-2 ol-lg-2 col-md-offset-1  subtitle">
                            <p class="nowrap">
                                <b>
                                    <xsl:variable name="tag" select="'address'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p class="nowrap">
                                <xsl:variable name="tag" select="'forthAddress'"/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:call-template name="replaceNL">
                                    <xsl:with-param name="string" select="$translated"/>
                                </xsl:call-template>   
                            </p>
                        </div>
                    </div>
                                        

                  
                </div>
                <div class="row" style="margin-top: 15px;">
                    <div class="col-sm-3 col-md-3 col-lg-3 subtitle">
                        <p class="nowrap">
                            <b>
                                <xsl:variable name="tag" select="'systemVersion'"/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:value-of select="$translated"/>:
                            </b>
                        </p>
                    </div>
                    <div class="col-sm-9 col-md-9 col-lg-9">
                        <p class="nowrap">
                            <xsl:value-of select="$systemVersion"/>

                        </p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-3 col-md-3 col-lg-3 subtitle">
                        <p class="nowrap">
                            <b>
                                <xsl:variable name="tag" select="'schemaVersion'"/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <xsl:value-of select="$translated"/>:
                            </b>
                        </p>
                    </div>
                    <div class="col-sm-9 col-md-9 col-lg-9">
                        <p class="nowrap">
                            <xsl:value-of select="$schemaVersion"/>

                        </p>
                    </div>
                </div>
            </div>     
        </div>  
    </xsl:template>
</xsl:stylesheet>