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
    <!--xsl:variable name="systemRoot" select="//page/systemRoot"/-->
    <xsl:variable name="locale" select="document(concat('', '../../multi_lang.xml'))/locale"/>
    <xsl:variable name="lang" select="//page/@language"/>
    <xsl:variable name="name" select="$locale/header/name/*[name()=$lang]"/>
    <xsl:variable name="text" select="$locale/footer/text1/*[name()=$lang]"/>

    <xsl:variable name="tag" select="//page/@title"/>
    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
    <xsl:variable name="title" select="$translated"/>

    <xsl:variable name="UserRights" select="//page/@UserRights"/>
    <xsl:variable name="user" select="//page/@user"/>
    <xsl:variable name="fullname" select="//page/@fullname"/>
    <xsl:variable name="columns" select="count(//topmenu/menugroup/menu)+1"/>


    <xsl:variable name="formatingDir" select="'formating'"/>
    <xsl:variable name="type" select="//context/EntityType"/>
   

    <xsl:template name="vars">
    </xsl:template>
</xsl:stylesheet>
