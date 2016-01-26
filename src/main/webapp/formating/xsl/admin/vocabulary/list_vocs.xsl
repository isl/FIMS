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
    <xsl:include href="../../ui/page.xsl"/>
	
    <xsl:variable name="AdminAction" select="//context/AdminAction"/>
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="ListOf" select="//context/ListOf"/>
    <xsl:variable name="VocsList" select="//context/VocsList/Vocabularies/*"/>
	
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    
    <xsl:template name="context">     
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <div class="panel-group" id="accordion">        
                    <xsl:for-each select="$VocsList"> <!-- gia ka8e omada le3ilogiwn -->
                        <div class="panel panel-default">
                            <div class="panel-heading vocPanel">
                                <h4 class="panel-title">                                    
                                    <a data-toggle="collapse" data-parent="#accordion" 
                                       href="#collapse{position()}">
                                        <xsl:value-of select="./displayname/*[name()=$lang]"/>
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse{position()}" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <xsl:for-each select="./*[name() != 'displayname']"> <!-- gia ka8e le3ilogio ths omadas -->
                                        <p class="vocLink">
                                            <a  href="AdminVoc?action={$AdminAction}&amp;mode={$AdminMode}&amp;file={./file}&amp;menuId={$EntityType}">
                                                <xsl:value-of select="./displayname/*[name()=$lang]"/>
                                            </a>
                                        </p>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each> 
                </div>              
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>