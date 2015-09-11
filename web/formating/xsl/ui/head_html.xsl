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
    <xsl:template name="head_html">
        <xsl:param name="title"/>
        <xsl:param name="javascript"/>
        <xsl:param name="css"/>
        <head>
            <title>
                <xsl:value-of select="//context/systemName/text()"/>
            </title>
            <script type="text/JavaScript" src="{$formatingDir}/javascript/storage/storage.js"></script>
            <script language="JavaScript">
                <xsl:attribute name="src">
                    <xsl:value-of select="$javascript"/>
                </xsl:attribute>
            </script>
            <link rel="stylesheet" type="text/css">
                <xsl:attribute name="href">
                    <xsl:value-of select="$css"/>
                </xsl:attribute>
            </link>
            <!-- jQuery -->
            <script type="text/javascript" charset="utf8" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
            <!-- DataTables CSS -->
            <link rel="stylesheet" type="text/css" href="{$formatingDir}/css/jquery.dataTables.css"></link>
            <!-- DataTables -->
            <script type="text/javascript" charset="utf8" src="{$formatingDir}/javascript/jquery/jquery.dataTables.js"></script>           
			
            <script language="JavaScript">

                <xsl:variable name="tag" select=" 'EpileksteProta' "/>
                var AlertEpileksteProta = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>' ; 
                <xsl:variable name="tag" select=" 'EgirosAri8mosSelidas' "/>
                var EgirosAri8mosSelidas = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>' ; 
                <xsl:variable name="tag" select=" 'nofreespace' "/>
                var nofreespace = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]" disable-output-escaping="yes"/>' ;
                <xsl:variable name="tag" select=" 'backupMsg' "/>
                var backupMsg = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>' ;    
                var lang = '<xsl:value-of select="$lang"/>';
                $(document).ready(function(){
                                   
                jQuery.browser = {};
                (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                jQuery.browser.msie = true;
                jQuery.browser.version = RegExp.$1;
                }
                })();
                var wid = $(".content").width() +40;                
                $("#topDrop").css("width",wid);
                
                if( $('#results').length>0){
                <xsl:variable name="tag" select=" 'filterResults' "/>
                var searchString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'Next' "/>
                var nextString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'Prev' "/>
                var prevString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'showing' "/>
                var showingString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'to' "/>
                var toString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'of' "/>
                var ofString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'entries' "/>
                var entriesString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'results' "/>
                var resultsString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'filtered' "/>
                var filteredString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                <xsl:variable name="tag" select=" 'DenBrethikanArxeia' "/>
                var DenBrethikanArxeiadString = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
                //remove last column if empty
     
                var $table = $('#results');
                var thead = $table[0].tHead, tbody = $table[0].tBodies[0];
                var colsLen = tbody.rows[0].cells.length, rowsLen = tbody.rows.length;
                var hideNode = function(node) { if (node) node.style.display = "none"; };
                for (var j = 0; j &lt; colsLen; ++j) {
                var counter = 0;
                for (var i = 0; i &lt; rowsLen; ++i) {
                if (tbody.rows[i].cells[j].childNodes.length == 0) ++counter;
                }
                if (counter == rowsLen) {
                for (var i = 0; i &lt; rowsLen; ++i) {
                hideNode(tbody.rows[i].cells[j]);
                }
                hideNode(thead.rows[0].cells[j]);
                }
                }
  
                $('#results').dataTable( {
                "oLanguage": {
                "sSearch": searchString,
                "sInfo": showingString + " _START_ " +toString +" _END_ " + ofString + " _TOTAL_ " + resultsString,
                "sInfoEmpty": showingString + " 0 " + toString + " 0 " + ofString + " 0 " +resultsString,
                "sLengthMenu": showingString +" _MENU_ "+ entriesString,
                "sInfoFiltered": "(" + filteredString + " " + ofString + " _MAX_ "+ resultsString + ")",
                "sZeroRecords": DenBrethikanArxeiadString,
                "oPaginate": {
                "sPrevious": prevString,
                "sNext": nextString,
                }
                }
                
            
                } );
                }
                });
                
            </script> 
            
        

			
            <script language="JavaScript" src="formating/javascript/utils/scripts.js"/>
               
			
        </head>
    </xsl:template>
</xsl:stylesheet>
