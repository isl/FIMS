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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:include href="../ui/page.xsl"/>
    <xsl:include href="../utils/utils.xsl"/>
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:variable name="FileName" select="//context/FileName"/>
        <xsl:variable name="Display" select="//context/Display"/>
        <script type="text/javascript">
            $(document).ready(function(){
            h = $('#content').height();
            $('#displayRow').height(h);
            });
        </script>
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">

                <h4 class="title">
                    <xsl:variable name="tag" select=" 'ImportVoc' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <h5 class="subtitle">
                    <xsl:variable name="tag" select=" 'SelectTXTFile' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h5>
                <form action="ImportVocabulary?menuId=AdminVoc&amp;file={$FileName}&amp;type=AdminVoc" method="post" enctype="multipart/form-data">
                    <div class="row">
                                
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <input type="file" accept=".txt" name="file" />                        
                            </p>
                        </div>
                    </div>
                    <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                        <xsl:value-of select="$translated"/>
                    </button>  
                    <xsl:variable name="tag" select=" 'Epistrofi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <a class="btn btn-default .btn-sm" style="margin-top:10px; margin-left:10px;" href="javascript:window.history.go(-1);">
                        <xsl:value-of select="$translated"/>
                    </a>                     
                </form>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
