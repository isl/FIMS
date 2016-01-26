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

    <xsl:variable name="ErrorMsg" select="//context/ErrorMsg"/>
	
    <xsl:variable name="FileId" select="//context/FileId"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="AdminAction" select="//context/AdminAction"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'AporipsiDimosieusis' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form action="AdminEntity?type={$EntityType}&amp;action=rejectpublish&amp;id={$FileId}" method="post">
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'Sxolio'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <textarea rows="3" name="comment"></textarea>
                            </p>
                        </div>
                    </div>
                    <input type="hidden" name="lang" value="{$lang}"/>
                    <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                        <xsl:value-of select="$translated"/>
                    </button>         
                </form>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>