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
    <xsl:variable name="tableStyle" select="concat('tableStyle',$lang)"/>
    <xsl:variable name="EntityCategory" select="//context/EntityCategory"/>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../ui/page.xsl"/>
    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <link rel="stylesheet" type="text/css" href="formating/css/chosen_plugin/chosen.css"/>
        <script type="text/javascript" src="formating/javascript/chosen_plugin/chosen.jquery.js"></script>
        <script type="text/javascript" src="formating/javascript/chosen_plugin/chosen.jquery.min.js"></script>      
        <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
            $('.chzn-select').chosen();                 
            var zidx = 100;
            $('.chzn-container').each(function(){
            $(this).css('z-index', zidx);
            zidx-=1;
            });
            jQuery(".chosen").chosen();
            $('.select2').select2();
            $('#submitSearch').click(function() {
            
            $('#criteriaBody tr').each(function () {
            // reference all the stuff you need first
            var dataType = $(this).find('#dataTypes').val();

            if (dataType === "string") {
            $(this).find('.string_inputoper').prop('disabled', false);
            $(this).find('.string_inputoper').next().prop('disabled', false).trigger("liszt:updated");
            $(this).find('.time_inputoper').prop('disabled', true);
            $(this).find('.time_inputoper').next().prop('disabled', true).trigger("liszt:updated");    
            } else if (dataType === "time") {
            $(this).find('.string_inputoper').prop('disabled', true);
            $(this).find('.string_inputoper').next().prop('disabled', true).trigger("liszt:updated");
            $(this).find('.time_inputoper').prop('disabled', false);
            $(this).find('.time_inputoper').next().prop('disabled', false).trigger("liszt:updated");
            }
            });
            submitFormTo('searchForm', 'SearchResults');
            });

            $('#submitSave').click(function() {
            
            $('#criteriaBody tr').each(function () {
            // reference all the stuff you need first
            var dataType = $(this).find('#dataTypes').val();

            if (dataType === "string") {
            $(this).find('.string_inputoper').prop('disabled', false);
            $(this).find('.string_inputoper').next().prop('disabled', false).trigger("liszt:updated");
            $(this).find('.time_inputoper').prop('disabled', true);
            $(this).find('.time_inputoper').next().prop('disabled', true).trigger("liszt:updated");    
            } else if (dataType === "time") {
            $(this).find('.string_inputoper').prop('disabled', true);
            $(this).find('.string_inputoper').next().prop('disabled', true).trigger("liszt:updated");
            $(this).find('.time_inputoper').prop('disabled', false);
            $(this).find('.time_inputoper').next().prop('disabled', false).trigger("liszt:updated");
            }
            });
            submitFormTo('searchForm', 'SearchSave');
            });
            $('#criteriaBody tr').each(function () {
            // reference all the stuff you need first
            var dataType = $(this).find('#dataTypes').val();
            

            if (dataType === "string") {


            $(this).find('.string_inputoper').hide();
            $(this).find('.string_inputoper').next().show();
            $(this).find('.time_inputoper').hide();
            $(this).find('.time_inputoper').next().hide();
            $(this).find('.searchString').removeAttr('disabled');
            $(this).find('.timeString').attr('disabled','disabled');
            $(this).find('.searchString').show();
            $(this).find('.timeString').hide();
            $(this).find('.timeImg').hide();

            } else if (dataType === "time") {


            $(this).find('.string_inputoper').hide();
            $(this).find('.string_inputoper').next().hide();
            $(this).find('.time_inputoper').hide();
            $(this).find('.time_inputoper').next().show();
            $(this).find('.timeString').removeAttr('disabled');
            $(this).find('.searchString').attr('disabled','disabled');
            $(this).find('.searchString').hide();
            $(this).find('.timeString').show();
            $(this).find('.timeImg').show();

            }
            });

            
            $('.searchValues').change(function(i){
            var index = $(this).prop('selectedIndex');
            $oper = $(this).parent().children().eq(2);
            $oper.prop('selectedIndex',index);
            var dataType = $oper.val();
            $stingInput = $(this).parent().parent().children().eq(2).children().eq(0);
            $timeInput = $(this).parent().parent().children().eq(2).children().eq(2);
            $searchString = $(this).parent().parent().children().eq(3).children().eq(0);
            $timeString = $(this).parent().parent().children().eq(3).children().eq(1);
            $timeImg= $(this).parent().parent().children().eq(3).children().eq(2);

            if (dataType == "string") {


            $timeInput.hide();
            $timeInput.next().hide();


            $stingInput.hide();
            $stingInput.next().show();
            
            $searchString.removeAttr('disabled');
            $timeString.attr('disabled','disabled');
            $searchString.show();
            $timeString.hide();
            $timeImg.hide();
            
            } else if (dataType == "time") {


            $timeInput.hide();
            $timeInput.next().show();


            $stingInput.hide();
            $stingInput.next().hide();
            
            $timeString.removeAttr('disabled');
            $searchString.attr('disabled','disabled');
            $searchString.hide();
            $timeString.show();
            $timeImg.show();
            }
            });

            if($("#default").prop("checked")==true){
            $('#outputStrings').prop('disabled', true).trigger("liszt:updated");
            }
            
            $('.outputOptions').change(function(){
            if($("#default").prop("checked")==true){
            $('#outputStrings').prop('disabled', true).trigger("liszt:updated");
            }else{
            $('#outputStrings').prop('disabled', false).trigger("liszt:updated");
            }
            });

            });
        </script>
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'sunthethAnazhthsh' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form id="searchForm"  action="" method="post">
                    <xsl:if test="$EntityCategory='primary'">
                        <div class="row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select="'AdminStatus'"/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-9 col-md-9 col-lg-9">
                                <p>
                                    <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <select  data-placeholder="{$translated}" class="chzn-select" style="width:350px;"  multiple="multiple" name="extraStatus">                             
                                        <option value=""></option> 
                                        <xsl:for-each select="//context/statusType/status">
                                            <xsl:variable name="tag" select="./text()"/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <option  value="{./text()}">
                                                <xsl:value-of select="$translated"/>
                                            </option>
                                        </xsl:for-each>
                                    </select>                                                           
                                </p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3 col-md-3 col-lg-3">
                                <p>
                                    <b>
                                        <xsl:variable name="tag" select=" 'sintaktis' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <xsl:value-of select="$translated"/>:
                                    </b>
                                </p>
                            </div>
                            <div class="col-sm-9 col-md-9 col-lg-9">
                                <p>
                                    <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <select data-placeholder="{$translated}" name="user" style="width:350px;" class="chzn-select" multiple="multiple">
                                        <option value=""></option>
                                        <xsl:for-each select="//context/Users/group">
                                            <optgroup label="{string(./@name)}">
                                                <xsl:for-each select="./userInGroup">
                                                    <option value="{./text()}">
                                                        <xsl:value-of select="./text()"/>
                                                    </option>    
                                                </xsl:for-each>
                                            </optgroup>
                                        </xsl:for-each>
                                    </select>                                         
                                </p>
                            </div>
                        </div>
                        <xsl:if test="count(//context/Groups/groups)&gt;1">
                            <div class="row">
                                <div class="col-sm-3 col-md-3 col-lg-3">
                                    <p>
                                        <b>
                                            <xsl:variable name="tag" select=" 'AdminOrganization' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>: 
                                        </b>
                                    </p>
                                </div>
                                <div class="col-sm-9 col-md-9 col-lg-9">
                                    <p>
                                        <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <select data-placeholder="{$translated}" class="chzn-select" multiple="multiple" style="width:350px;" name="org">                             
                                            <option value=""></option>
                                            <xsl:for-each select="//context/Groups/groups">
                                                <option value="{string(./@id)}">
                                                    <xsl:value-of select="./text()"/>
                                                </option>                                   
                                            </xsl:for-each>
                                        </select>                                  
                                    </p>
                                </div>
                            </div>
                        </xsl:if>
                    </xsl:if>

                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select=" 'id' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input style="width: 53%;" class="inputwidth"  type="text" value="" name="code"/>                        
                            </p>
                        </div>
                    </div>
                    <input type="hidden" name="target" value="{//context/query/targets/path[@selected='yes']/@xpath}"/>
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <div class="searchBox">
                                <div class="row">
                                    <div class="col-sm-3 col-md-3 col-lg-3">

                                        <xsl:choose>
                                            <xsl:when test="//context/query/info/operator='or'">                                           
                                                <input type="radio" name="operator" value="and"/>AND 
                                                <xsl:text> </xsl:text>                                           
                                                <input type="radio" name="operator" value="or" style="margin-left:5px;" checked="checked"/>OR
                                            </xsl:when>
                                            <xsl:otherwise>                                            
                                                <input type="radio" name="operator" value="and" checked="checked"/>AND
                                                <xsl:text> </xsl:text>                                           
                                                <input type="radio" name="operator" style="margin-left:5px;" value="or"/>OR
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-11 col-md-11 col-lg-11">
                                        <table class="table" id="searchTable">
                                            <thead>
                                                <tr class="contentHeadText">
                                        
                                                    <xsl:variable name="tag" select=" 'EpiloghPediouKrithriou' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <th>
                                                        <xsl:value-of select="$translated"/>
                                                    </th>
                            
                                                    <xsl:variable name="tag" select=" 'Sinthiki' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <th>
                                                        <xsl:value-of select="$translated"/>
                                                    </th>
                            
                                                    <xsl:variable name="tag" select=" 'Timi' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <th>
                                                        <xsl:value-of select="$translated"/>
                                                    </th>                                        
                                                </tr>
                                            </thead>  				
                                            <tbody id="criteriaBody">
                                        
                                                <xsl:for-each select="//context/query/inputs/input">
                                                    <tr id="criterion">
                                                        <td style="display: none"> 
                                                            <input type="hidden" id="inputid" name="inputid" value="{./@id}"/>
                                                        </td>
                                                        <td>
                                                            <select   data-placeholder="{$translated}"  class="chosen searchValues" name="input">
                                                                <xsl:for-each select="./path">
                                                                    <option value="{./@xpath}">
                                                                        <xsl:if test="./@selected='yes'">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                        <xsl:value-of select="."/>
                                                                    </option>
                                                                </xsl:for-each>
                                                            </select>
                                                            <select id="dataTypes" name="input" disabled="disabled" style="display:none">

                                                                <xsl:for-each select="./path">
                                                                    <option value="{./@dataType}">
                                                                        <xsl:if test="./@selected='yes'">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                        <xsl:value-of select="./@dataType"/>
                                                                    </option>
                                                                </xsl:for-each>
                                                            </select>
                                                        </td>
                                                        <td>                                                
                                                            <xsl:variable name="operPos" select="position()"/>                                                
                                                            <select class="chosen string_inputoper"  name="inputoper" >                                                              


                                                                <xsl:for-each select="//types/string/operator">
                                                                    <option value="{./text()}">                                                              
                                                                        <xsl:if test="./text()=//input[position()=$operPos]/oper/text()">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                        <xsl:value-of select="@*[name(.)=$lang]"/>
                                                                    </option>
                                                                </xsl:for-each>
                                                   
                                                            </select>
                                                            <select class="chosen time_inputoper" name="inputoper">


                                                                <xsl:for-each select="//types/time/operator">
                                                                    <option value="{./text()}">                                                              
                                                                        <xsl:if test="./text()=//input[position()=$operPos]/oper/text()">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                        <xsl:value-of select="@*[name(.)=$lang]"/>
                                                                    </option>
                                                                </xsl:for-each>                                                   
                                                            </select>   
                                                        </td>
                               
                                                        <td  nowrap="nowrap">                                             
                                                            <input type="text" class="searchString" name="inputvalue" value="{./value}"/>
                                                            <input type="text"  class="timeString" style="display:none;width:120px;margin-right:5px;" name="inputvalue" onkeydown="timeCheck(this);" onkeyup="timeCheck(this);" value="{./value}"/>
                                                            <img class="timeImg" style="display:none; margin-right:10px;" src="formating/images/info.png" onclick="javascript:popUp('time_directives/HelpPage_{$lang}.html','helpPage',450,580);"></img>
                                                        </td> 
                                                        <td  nowrap="nowrap">
                                                            <xsl:variable name="tag" select=" 'ProsthikiKritiriou' "/>
                                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                            <input style="font-size: x-small;" type="button" class="btn btn-default .btn-xs" name="more" value="+" onclick="addCriterion('criteriaBody', 'criterion');" />
                                                            <xsl:choose>
                                                                <xsl:when test="position()&gt;1">
                                                                    <xsl:variable name="tag" select=" 'DiagrafiKritiriou' "/>
                                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                                    <input style=" margin-left: 4px;font-size: x-small;" type="button" class="btn btn-default .btn-xs" value="X" title="{$translated}" onClick="removeRow(this.parentNode.parentNode)"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:variable name="tag" select=" 'DiagrafiKritiriou' "/>
                                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                                    <input style=" margin-left: 4px;display:none;font-size: x-small;" type="button" class="btn btn-default .btn-xs" value="X" title="{$translated}" onClick="removeRow(this.parentNode.parentNode)"/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            
                                                        </td>                                                                                        
                                                    </tr>
                                                </xsl:for-each>
                                            </tbody>
                                        </table>
                                    </div>                            
                                </div>
                            </div>
                        </div>
                    </div>
                    

                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <div class="searchBox">
                                <div class="row">
                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                        <xsl:choose>
                                            <xsl:when test="//context/query/outputs/path/@xpath!='' ">     
                                                <input id="default" type="radio" name="default" class="outputOptions" />
                                                <xsl:variable name="tag" select=" 'defaultOutput' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>

                                                <xsl:text> </xsl:text>                                           
                                                <input class="outputOptions" type="radio" name="default" style="margin-left:5px;" checked="checked"/>
                                                <xsl:variable name="tag" select=" 'changeOutput' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <input id="default" type="radio" name="default" class="outputOptions" checked="checked"/>
                                                <xsl:variable name="tag" select=" 'defaultOutput' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>

                                                <xsl:text> </xsl:text>                                           
                                                <input class="outputOptions" type="radio" name="default" style="margin-left:5px;"/>
                                                <xsl:variable name="tag" select=" 'changeOutput' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                               
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-11 col-md-11 col-lg-11">
                                        <table class="table">
                                            <thead>
                                                <tr class="contentHeadText">
                                        
                                                    <xsl:variable name="tag" select=" 'EpiloghPediwnEksodou' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <th>
                                                        <xsl:value-of select="$translated"/>
                                                    </th>
                             
                                                </tr>
                                            </thead>  				
                                            <tbody>
                                                <xsl:choose>
                                                    <xsl:when test="//context/query/outputs/path/@selected='yes' ">                                                       
                                                        <tr>
                                                            <td>
                                                                <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                                <select  id="outputStrings" data-placeholder="{$translated}" name="output" class="chzn-select searchOutput" multiple="multiple">
                                                                    <xsl:for-each select="//context/query/outputs/path[@selected='yes']">
                                                                        <xsl:variable name="outXpath" select="./@xpath"/>
                                                                        <xsl:for-each select="//context/query/inputs/input[1]/path">
                                                                            <option value="{./@xpath}">
                                                                                <xsl:if test="$outXpath = ./@xpath">
                                                                                    <xsl:attribute name="selected">
                                                                                        <xsl:value-of select="selected"/>
                                                                                    </xsl:attribute>
                                                                                </xsl:if>
                                                                                <xsl:value-of select="."/>
                                                                            </option>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </select>                                                                                
                                                            </td>
                                                        </tr>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <tr>
                                                            <td>
                                                                <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                                <select  id="outputStrings"  data-placeholder="{$translated}" class="chzn-select searchOutput" multiple="multiple" name="output" >
                                                                    <xsl:for-each select="//context/query/inputs/input[1]/path[position() &gt; 1]">
                                                                        <option value="{./@xpath}">
                                                                            <xsl:value-of select="."/>
                                                                        </option>
                                                                    </xsl:for-each>
                                                                </select>                                                                          
                                                            </td>
                                                        </tr>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>                                        
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <xsl:variable name="tag" select=" 'Eperotisi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <input id="submitSearch" type="submit" class="btn btn-default .btn-sm" name="submit4search" value="{$translated}"  style="width:180"/> 
         
                        </div>
                    </div>
                    <input type="hidden" name="category" value="{//context/query/info/category}"/>
                    <input type="hidden" name="status" value="{//context/query/info/status}"/>
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                        
                            <div class="row savedQ">
                                <div class="col-sm-6 col-md-6 col-lg-6">
                                    <xsl:variable name="tag" select=" 'createQuery' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <h5 class="title" style="margin-top:20px;">
                                        <a class="saveQaccordion-toggle" data-toggle="collapse" href="#collapseCreateQ" aria-expanded="false" aria-controls="collapseCreateQ">
                                            <xsl:value-of select="$translated"/>
                                        </a>
                                    </h5>
                                </div>
                            </div>
                            <div class="collapse" id="collapseCreateQ">
                                <div class="searchBox">
                                    <div class="row">
                                        <div class="col-sm-3 col-md-3 col-lg-3">
                                            <xsl:variable name="tag" select=" 'Prosopikes' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <input align="center" type="radio" name="type" value="personal" checked="checked"/>                                  
                                            <xsl:value-of select="$translated"/>
                                            <xsl:variable name="tag" select=" 'Genikes' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <input style="margin-left:12px;"  type="radio" name="type" value="public"/>
                                            <xsl:value-of select="$translated"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-4 col-md-4 col-lg-4">
                                            <b>
                                                <xsl:variable name="tag" select=" 'MnimonikoOnomaEperwthshs' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>:
                                            </b>
                                        </div>
                                        <div class="col-sm-5 col-md-5 col-lg-5">

                                            <input style="width:100%" type="text" id="mnemonicName" name="mnemonicName" value="{//context/query/info/name/text()}"/>
                                        </div>
                                        <div class="col-sm-3 col-md-3 col-lg-3">
                                            
                                            <xsl:variable name="tag" select=" 'Apothikeusi' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <input id="submitSave" type="submit" class="btn btn-default .btn-sm" name="submit4save" value="{$translated}"/>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row savedQ">
                                <div class="col-sm-6 col-md-6 col-lg-6">
                                    <xsl:variable name="tag" select=" 'saveQuery' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <h5 class="title" style="margin-top:20px;">
                                        <a class="saveQaccordion-toggle" data-toggle="collapse" href="#collapseSaveQ" aria-expanded="false" aria-controls="collapseSaveQ">
                                            <xsl:value-of select="$translated"/>
                                        </a>
                                    </h5>
                                </div>
                            </div>
                            <div class="collapse" id="collapseSaveQ">
                                <div class="searchBox">
                        
                                    <div class="row">
                                        <div class="col-sm-4 col-md-4 col-lg-4">
                                            <b>
                                                <xsl:variable name="tag" select=" 'EpilexteApo8hkeymenhEperwtisi' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>:
                                            </b>
                                        </div>
                                        <div class="col-sm-5 col-md-5 col-lg-5">
                                            <xsl:variable name="tag" select=" 'Epilogi' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <select  style="width: 100%" data-placeholder="{$translated}" class="select2" name="qid">
                                                <xsl:variable name="tag" select=" 'Genikes' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <option value=""></option>
                                                <optgroup label="{$translated}">   
                                                                                             
                                                    <xsl:for-each select="//publicQueries">
                                                        <option value="{./@id}">
                                                            <xsl:if test="./@selected='yes'">
                                                                <xsl:attribute name="selected">
                                                                    <xsl:value-of select="selected"/>
                                                                </xsl:attribute>                                                   
                                                            </xsl:if>
                                                            <xsl:value-of select="."/>
                                                        </option>
                                                    </xsl:for-each>
                                                </optgroup>
                                                <xsl:variable name="tag" select=" 'Prosopikes' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <optgroup label="{$translated}">
                                               
                                                    <xsl:for-each select="//personalQueries">
                                                        <option value="{./@id}">
                                                            <xsl:if test="./@selected='yes'">
                                                                <xsl:attribute name="selected">
                                                                    <xsl:value-of select="selected"/>  
                                                                </xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:value-of select="."/>
                                                        </option>
                                                    </xsl:for-each>
                                                </optgroup>
                                            </select>
                                        </div>
                                        <div class="col-sm-3 col-md-3 col-lg-3">
                                            <xsl:variable name="tag" select=" 'Epilogi' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <input  type="submit" class="btn btn-default .btn-sm" name="submit4select" onClick="submitFormTo('searchForm', 'Search')" value="{$translated}"/>
                                            <xsl:if test="//context/isPersonal='true'">
                                                <xsl:variable name="tag" select=" 'Diagrafi' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:variable name="tag2" select=" 'Erwtimatiko' "/>
                                                <xsl:variable name="translated2" select="$locale/context/*[name()=$tag2]/*[name()=$lang]"/>
                                                <xsl:variable name="tag1" select=" 'DiagrafiPrompt' "/>
                                                <xsl:variable name="translated1" select="$locale/context/*[name()=$tag1]/*[name()=$lang]"/>
                                                <input style="margin-left:5px;" type="submit" class="btn btn-default .btn-sm" name="submit4delete" value="{$translated}" onClick="if (confirmAction('{$translated1}{$translated2}')) submitFormTo('searchForm', 'SearchDelete'); else return false;"/>
                                            </xsl:if>       
                                        </div>
                                    </div>
                                     
                                </div>
                            </div>
                            <input type="hidden" name="category" value="{//context/query/info/category}"/>
                            <input type="hidden" name="status" value="{//context/query/info/status}"/>
                        </div>
                    </div>
                </form>
            </div>
        </div>       
    </xsl:template>
 
</xsl:stylesheet>