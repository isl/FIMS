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
    <xsl:include href="../ui/page.xsl"/>
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:variable name="IsGuestUser" select="//context/IsGuestUser"/>
    <xsl:variable name="DocStatus" select="//context/DocStatus"/>
    <xsl:variable name="ServletName" select="//context/ServletName"/>
    <xsl:variable name="output" select="//context/query/outputs/path[@selected='yes']"/>
    <xsl:variable name="userOrg" select="//page/@userOrg"/>
    <xsl:variable name="URI_Reference_Path" select="//context/URI_Reference_Path"/>
    <xsl:variable name="EntityCategory" select="//context/EntityCategory"/>

	
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <xsl:variable name="user" select="//page/@UserRights"/>
        <xsl:variable name="EntityType" select="//context/EntityType"/>
        <xsl:variable name="tag" select=" 'PromptMessage' "/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>

        <script type="text/JavaScript">
            var str = '<xsl:value-of select="$translated"/>';        
        </script>
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'compare' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                   
                    <xsl:value-of select="$translated"/>
                </h4>
                <h5 class="subtitle">
                    <xsl:variable name="tag" select=" 'SelectCompareFiles' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                   
                    <xsl:value-of select="$translated"/>
                </h5>
                <form id="compareForm" onsubmit="javascript:createCompareUrl();return false;" method="post">
                     
                    <table id="resultsMultiple">
                        <thead>
                            <tr class="contentHeadText">
                                <th style="display:none;">                                                         
                                </th>
                        
                                <xsl:for-each select="$output">
                                    <th>
                                        <strong>
                                            <xsl:variable name="tag" select=" ./text() "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>
                                        </strong>
                                    </th>
                                </xsl:for-each>                        
                       
                            </tr>
                        </thead>
                           <tbody>

                            <xsl:for-each select="//result">
					
                                <xsl:variable name="pos">
                                    <xsl:value-of select="./@pos"/>
                                </xsl:variable>
                                <xsl:variable name="id" select=" ./hiddenResults/FileId/text() "/>
	
                                <tr id="resultRow" align="center" valign="middle" class="resultRow {$id} "  >
                                    <td class="invisible" >
                                        <xsl:value-of select="./hiddenResults/FileId/text()"/>
                                    </td>                                                
                          
                                    <xsl:for-each select="./*[name() != 'FileId' and name() !=  'info' and name()!='hiddenResults']">
                                        <xsl:choose>
                                    
                                            <xsl:when test="name() ='filename'">    
                                                <xsl:variable name="uriId" select="./filename/text()"/>                                   
                                                <td title="{concat($URI_Reference_Path,$uriId)}" >
                                                    <xsl:value-of select="$uriId"/>
                                                </td>                                          
                                            </xsl:when>
                                            <xsl:when test="name() ='ShortDescription'">    
                                                <xsl:variable name="description" select="./ShortDescription/text()"/>                                   
                                                <td title="{$description}" >
                                                    <xsl:variable name="short_description" select="substring($description,1,15)"/>                                   
                                                    <xsl:value-of select="$short_description"/>
                                                    <xsl:if test="$short_description!=''and $short_description!=$description" >
                                                        <xsl:value-of select="'...'"/>
                                                    </xsl:if> 
                                                </td>                               
                                            </xsl:when>
                                            <xsl:when test="name() ='general_description'">    
                                                <xsl:variable name="general_description" select="./general_description/text()"/>                                   
                                                <td title="{$general_description}" >
                                                    <xsl:variable name="short_description" select="substring($general_description,1,120)"/>                                   
                                                    <xsl:value-of select="$short_description"/>
                                                    <xsl:if test="$short_description!=''and $short_description!=$general_description" >
                                                        <xsl:value-of select="'...'"/>
                                                    </xsl:if> 
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>
                                                    <xsl:for-each select="./*">
                                                        <xsl:if test="position() > 1">
                                                            <br/>
                                                        </xsl:if>
                                                        <xsl:if test=" name() = 'status' ">                                                   
                                                            <xsl:variable name="tag" select=" ./text() "/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <xsl:value-of select="$translated"/>
                                                        </xsl:if>
                                                        <xsl:if test=" name() != 'status' ">
                                                            <xsl:value-of select="./text()"/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>                          
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                    
                </form>
            </div>
        </div>
        <!--td colSpan="{$columns}" vAlign="top"  class="content">
            <xsl:if test="count(//result)&gt;0">                          
                 
                <br/>  
                <p align="center" class="contentText">
                    <xsl:variable name="tag" select=" 'SelectCompareFiles' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <font size="4">
                        <strong>
                            <xsl:value-of select="$translated"/>
                        </strong>
                    </font>
                </p>
                <form  method="post" id="criterionForm" onsubmit="javascript:createCompareUrl();return false;">
       
                                        <xsl:variable name="tag" select=" 'compare' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <div style="float:right">
                        <input style="margin-top:20px;margin-bottom:20px;" type="submit" class="button" value="{$translated}"></input>
                        <a  style="padding-left:9px; font-size:10px;"   href="javascript:window.history.go(-1);">
                            <xsl:variable name="tag" select=" 'operator_or' "/> 
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                            <xsl:value-of select="$translated"/>
                            <xsl:text> </xsl:text>
                            <xsl:variable name="tag" select=" 'Epistrofi' "/> 
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                            <xsl:value-of select="$translated"/>
                        </a>
                    </div>
                </form>
            </xsl:if>
            
        </td-->
        <script>
            $(document).ready(function() {
            
            <xsl:variable name="tag" select=" 'compare' "/>
            var compare = '<xsl:value-of select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>';
            
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
            var table = $('#resultsMultiple').DataTable( {
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
            
            $('#resultsMultiple tbody').on( 'click', 'tr', function () {
            if(  table.rows('.selected').data().length &lt; 2){                      

            $(this).toggleClass('selected');
            }else if( $(this).hasClass('selected') ){
            $(this).toggleClass('selected');
            }
            
            if(  $('.deleteButton').length>0){               
            $('.compareRow').remove();

            }
                
           
                 
            if(table.rows('.selected').data().length == 2 || table.rows('.selected').data().length == 1){
                
            var ids= $.map(table.rows('.selected').data(), function (item) {
            return item[0];
            });
                 
            <!--            $div = $('<div style="font-size:10pt;color:#620705;float:left;"  id="compareFiles">'+'</div>'); -->
            $row = $('<div class="row compareRow"></div>');
            $col1 = $('<div class="col-sm-6 col-md-6 col-lg-6 panelCol"></div>');
            $col2 = $('<div class="col-sm-6 col-md-6 col-lg-6 compareCol"></div>');

            $panel = $('<div class="panel panel-default text-center comparePanel">
                <div class="panel-body comparePanelBody"></div>
            </div>');

            $delete1 = $('<button type="button" class="btn btn-default btn-sm deleteButton"></button>');
            $span1 =$('<span class="glyphicon glyphicon-remove deleteIcon"/>');
            $delete2 = $('<button type="button" class="btn btn-default btn-sm deleteButton"></button>');
            $span2 =$('<span class="glyphicon glyphicon-remove deleteIcon"/>');
            $compareButton = $('<button class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">'+compare+'</button> ');
                
            if(ids.length==1){
            $delete1.attr('id', ids[0]);  
            $delete1.attr('value', ids[0]);  
            $delete1.text(ids[0]);
            $row.append($col1);
            $col1.append($panel);
            $row.insertBefore( "#resultsMultiple_wrapper" );
            $delete1.append($span1);  
            $('.comparePanelBody').append($delete1); 
   
            }else if(ids.length==2){  
            $delete1.attr('id', ids[0]);  
            $delete1.attr('value', ids[0]);  
            $delete1.text(ids[0]);
            $row.append($col1);
            $col1.append($panel);
            $row.insertBefore("#resultsMultiple_wrapper" );
            $delete1.append($span1);  
            $('.comparePanelBody').append($delete1); 
          
            $delete2.attr('id', ids[1]);  
            $delete2.attr('value', ids[1]);  
            $delete2.text(ids[1]);
            $delete2.append($span2); 
            $('.comparePanelBody').append($delete2);
            $row.append($col2);
            $col2.append($compareButton);
             
             
            }
     
            $delete1.click(function(){
            var cId= $(this).attr('id');
            $delete1.remove();            
            table.$('tr.'+cId).removeClass('selected');
            var tmpIds= $.map(table.rows('.selected').data(), function (item) {
            return item[0];
            });
            
            if(tmpIds.length==0){
            $row.remove();
            }else if(tmpIds.length==1){
                if($compareButton.length>0){
                $compareButton.remove();
            }
            }
            });    
              
              
            $delete2.click(function(){
            var cId= $(this).attr('id');
            $delete2.remove();
            table.$('tr.'+cId).removeClass('selected');
            var tmpIds= $.map(table.rows('.selected').data(), function (item) {
            return item[0];
            });
            if(tmpIds.length==0){
            $row.remove();
            }else if(tmpIds.length==1){
                if($compareButton.length>0){
                $compareButton.remove();
            }
            }
            });
                
              

            }
            
            } );
         
            } );
            
            function createCompareUrl(){
            

               
            var table = $('#resultsMultiple').DataTable();

            if( table.rows('.selected').data().length == 2){
            var id1;
            var id2;
            var i=1;
            $.map(table.rows('.selected').data(), function (item) {
            if(i==1){
            id1 =item[0];
            i++;
            }else{
            id2 = item[0];
            }        
            });
                 
            $('#resultsMultiple .selected .invisible').each(function()
            {
                      
            });
            var url = '/Maze/multmappings.html?id1='+id1+'&amp;id2='+id2;
            centeredPopup(url,'win_new','800','600','yes');      
            }else{
            return false;
            }
            }
        </script>
    </xsl:template>
</xsl:stylesheet>
