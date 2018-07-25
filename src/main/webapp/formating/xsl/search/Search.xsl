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
    <xsl:variable name="EntityType" select="//context/EntityType"/>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../ui/page.xsl"/>
    <xsl:include href="../utils/utils.xsl"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <link rel="stylesheet" type="text/css" href="formating/css/chosen_plugin/chosen.css"/>
        <script type="text/javascript" src="formating/javascript/chosen_plugin/chosen.jquery.js"></script>
        <script type="text/javascript" src="formating/javascript/chosen_plugin/chosen.jquery.min.js"></script>      
        <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>

        <link rel="stylesheet" href="formating/css/angular-multi-select-tree-0.1.0.css"/>
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.5/angular.min.js"></script>
        <script type="text/javascript" src="formating/javascript/angular/app.js"></script>
        <script type="text/javascript" src="formating/javascript/angular/angular-multi-select-tree-0.1.0.js"></script>
        <script type="text/javascript" src="formating/javascript/angular/angular-multi-select-tree-0.1.0.tpl.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.20/angular-sanitize.min.js"/>

        <script type="text/javascript">

            $(document).ready(function () {
            $('.chzn-select').chosen();
            var zidx = 100;
            $('.chzn-container').each(function () {
            $(this).css('z-index', zidx);
            zidx -= 1;
            });


            $('.select2').select2();
            $('#submitSearch').click(function () {

            submitFormTo('searchForm', 'SearchResults');
            });

            $('#submitSave').click(function () {
            submitFormTo('searchForm', 'SearchSave');
            });



            if ($("#default").prop("checked") == true) {
            $('#outputTree').css('pointer-events', 'none');
            $("#style").val("throughTrans");        


            }

            $('.outputOptions').change(function () {
            if ($("#default").prop("checked") == true) {
            $("#style").val("throughTrans");
            $('#outputTree').css('pointer-events', 'none');
            } else {
            $('#outputTree').css('pointer-events', 'all');
            $("#style").val("");
            }
            });
            
       

            });
        </script>
        <div id="test" class="row" ng-app="searchApp" ng-controller="searchAppCtrl">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id=$EntityType]/label/text()"/>
                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>        
                    <xsl:text> - </xsl:text>
                    <xsl:variable name="tag" select=" 'sunthethAnazhthsh' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form id="searchForm"  action="" method="post">   
                    <input type="hidden" id="lang" value="{$lang}"/>         
                    <input type="hidden" name="target" value="{//context/query/targets/path[@selected='yes']/@xpath}"/>
                    <input type="hidden" id="xpaths" value="{//context/query/inputs/xpaths}"/>
                    <input type="hidden" id="dataTypes" value="{//context/query/inputs/dataTypes}"/>
                    <input type="hidden" id="labels" value="{//context/query/inputs/labels}"/>
                    <input type="hidden" id="vocabularies" value="{//context/query/inputs/vocTags}"/>


                    <xsl:for-each select="//context/query/inputs/selectedTags">
                        <input type="hidden" class="selectedInputs" value="{./text()}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/inputs/input/value">
                        <input type="hidden" class="value" value="{./text()}"/>
                    </xsl:for-each>
                    <xsl:for-each select="//context/query/outputs/path">
                        <input type="hidden" class="selectedOutputs" value="{./@xpath}"/>
                    </xsl:for-each>

                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <div class="searchBox">                     
                                <div class="row extraSearch">
                                    <div class="col-sm-6 col-md-6 col-lg-6">
                                        <xsl:variable name="tag" select=" 'MeKritiriaAnazitisis' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <h5 class="titleSearch">
                                            <xsl:value-of select="$translated"/>
                                        </h5>
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
                                                    <th>
                                                        <xsl:choose>
                                                            <xsl:when test="//context/query/info/operator='or'">                                           
                                                                <input ng-disabled="items.length&lt;2" type="radio" name="operator" value="and"/>AND 
                                                                <xsl:text> </xsl:text>                                           
                                                                <input ng-disabled="items.length&lt;2" type="radio" name="operator" value="or" style="margin-left:5px;" checked="checked"/>OR
                                                            </xsl:when>
                                                            <xsl:otherwise>                                            
                                                                <input ng-disabled="items.length&lt;2" type="radio" name="operator" value="and" checked="checked"/>AND
                                                                <xsl:text> </xsl:text>                                           
                                                                <input ng-disabled="items.length&lt;2" type="radio" name="operator" style="margin-left:5px;" value="or"/>OR
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </th>                                    
                                                </tr>
                                            </thead>  				
                                            <tbody id="criteriaBody">
                                        
                                                <tr class="criterion" ng-repeat="item in items  track by $index">
                                                    <td>
                                                        <xsl:variable name="tag" select=" 'Epilogi' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>

                                                        <multi-select-tree data-input-model="item.data"  
                                                                           data-output-model="item.selectedItem2" data-default-label="{$translated}"
                                                                           data-callback="setDataType(item)" 
                                                                           data-select-only-leafs="true"/>                                                            
                                    
                                                        <input type="hidden" name="input" ng-value="'/'+item.selectedItem2[0].id"/>
                                                        <input type="hidden" class="dataTypes" ng-value="item.selectedItem2[0].dataType"/>
                                                        <input type="hidden" name="inputLabels" ng-value="item.selectedItem2[0].name"/>
                                                    </td>

                                                    <td>                                                
                                                        <xsl:variable name="operPos" select="position()"/>    
                                                        <select data-ng-show="showConditionOr(showString(item.selectedItem2[0].showString), showVoc(item.selectedItem2[0].showVoc, item.selectedItem2[0]))" ng-disabled="!(showConditionOr(showString(item.selectedItem2[0].showString), showVoc(item.selectedItem2[0].showVoc,item.selectedItem2[0])))" class="string_inputoper"  name="inputoper" >                                                              
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
                                                        <select ng-show="showTime(item.selectedItem2[0].showTime)" ng-disabled="!showTime(item.selectedItem2[0].showTime)" class="time_inputoper"  name="inputoper">
                                                            <xsl:for-each select="//types/time/operator">
                                                                <xsl:variable name="oper" select="./text()"/>
                                                                <option value="{$oper}">
                                                                    <xsl:for-each select="//inputs/input/oper">                                                            
                                                                        <xsl:if test="./text()=$oper">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                    </xsl:for-each>
                                                                    <xsl:value-of select="@*[name(.)=$lang]"/>
                                                                </option>
                                                            </xsl:for-each>                                                   
                                                        </select>
                                                        
                                                        <select ng-show="showMath(item.selectedItem2[0].showMath)" ng-disabled="!showMath(item.selectedItem2[0].showMath)" class="time_inputoper"  name="inputoper">
                                                            <xsl:for-each select="//types/math/operator">
                                                                <xsl:variable name="oper" select="./text()"/>
                                                                <option value="{$oper}">
                                                                    <xsl:for-each select="//inputs/input/oper">                                                            
                                                                        <xsl:if test="./text()=$oper">
                                                                            <xsl:attribute name="selected">
                                                                                <xsl:value-of select="selected"/>
                                                                            </xsl:attribute>
                                                                        </xsl:if>
                                                                    </xsl:for-each>
                                                                    <xsl:value-of select="@*[name(.)=$lang]"/>
                                                                </option>
                                                            </xsl:for-each>                                                   
                                                        </select>      
                                                    </td>
                                                     
                                                    <td  nowrap="nowrap">                                             
                                                        <input data-ng-show="showConditionAnd(showString(item.selectedItem2[0].showString), !showVoc(item.selectedItem2[0].showVoc,item.selectedItem2[0]))" ng-disabled="!(showConditionAnd(showString(item.selectedItem2[0].showString), !showVoc(item.selectedItem2[0].showVoc, item.selectedItem2[0])))" type="text" class="searchString" name="inputvalue" ng-value="item.selectedItem2[0].valueString"/>
                                                        <input data-ng-show="showTime(item.selectedItem2[0].showTime)" ng-disabled="!showTime(item.selectedItem2[0].showTime)" type="text"  class="timeString" style="width:120px;margin-right:5px;" name="inputvalue" onkeydown="timeCheck(this);" onkeyup="timeCheck(this);" ng-value="item.selectedItem2[0].valueTime"/>
                                                        <img data-ng-show="showTime(item.selectedItem2[0].showTime)" ng-disabled="!showTime(item.selectedItem2[0].showTime)" class="timeImg" style=" margin-right:10px;" src="formating/images/info.png" onclick="javascript:popUp('time_directives/HelpPage_{$lang}.html','helpPage',450,580);"></img>
                                                        <input data-ng-show="showMath(item.selectedItem2[0].showMath)" ng-disabled="!showTime(item.selectedItem2[0].showMath)" type="number"  class="timeString" name="inputvalue" ng-value="item.selectedItem2[0].valueMath"/>

                                                        <select class="vocSelect" ng-show="showVoc(item.selectedItem2[0].showVoc, item.selectedItem2[0])" ng-disabled="!showVoc(item.selectedItem2[0].showVoc,item.selectedItem2[0])" name="inputvalue">
                                                            <option ng-repeat="term in item.selectedItem2[0].term  track by $index"  ng-value="term" ng-selected="vocSelected(term,item.selectedItem2[0].valueVoc)">
                                                                {{term}}
                                                            </option>
                                                        </select>   


                                                    </td> 
                                                    <td  nowrap="nowrap">
                                                        <xsl:variable name="tag" select=" 'ProsthikiKritiriou' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <input style="font-size: x-small;" type="button" class="btn btn-default .btn-xs" title="{$translated}" name="more" value="+" ng-click="addItem(item)"/>
                                                        <xsl:variable name="tag" select=" 'DiagrafiKritiriou' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <input ng-show="$index>0" style=" margin-left: 4px;font-size: x-small;" type="button" class="btn btn-default .btn-xs" value="X" title="{$translated}" ng-click="removeItem(item)"/>
                                                    </td>   
                                                </tr>  
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <div class="row extraSearch">
                                        <div class="col-sm-6 col-md-6 col-lg-6">
                                            <xsl:variable name="tag" select=" 'ExtraSearchKrithria' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <h5 class="titleSearch">
                                                <a class="extraSearchaccordion-toggle" data-toggle="collapse" href="#collapseExtraSearch" aria-expanded="false" aria-controls="collapseExtraSearch">
                                                    <xsl:value-of select="$translated"/>
                                                </a>
                                            </h5>
                                        </div>
                                    </div>
                                    <div class="collapse" id="collapseExtraSearch">                        
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
                                            <xsl:if test="//page/@UserRights='admin'">
                                                <div class="row">
                                                    <div class="col-sm-3 col-md-3 col-lg-3">
                                                        <p>
                                                            <b>
                                                                <xsl:variable name="tag" select=" 'sintaktis_deltiou' "/>
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
                                                                    <xsl:variable name="tag" select=" 'AdminOrganization_card' "/>
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
                                    </div>   
                            
                                </div>
                            </div>
                        </div>
                    </div>
                    
                   
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <div class="searchBox">
                                <div class="row extraSearch">
                                    <div class="col-sm-6 col-md-6 col-lg-6">
                                        <xsl:variable name="tag" select=" 'PediaEksodou' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                        <h5 class="titleSearch">
                                            <xsl:value-of select="$translated"/>
                                        </h5>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                        <xsl:choose>
                                            <xsl:when test="//context/query/outputs/path/@xpath!='' ">     
                                                <input id="default" type="radio" name="default" class="outputOptions" />
                                                <xsl:variable name="tag" select=" 'defaultOutput' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/>
                                                <input type="hidden" name="style" value="" id="style"/>
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
                                                <input type="hidden" name="style" value="" id="style"/>

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
                                                <tr>
                                                    <td>
                                                        <xsl:variable name="tag" select=" 'Epilogi_more' "/>
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                                                        
                                                        <multi-select-tree id="outputTree" data-input-model="output"  multi-select="true"
                                                                           data-output-model="selectedItem3" data-default-label="{$translated}"
                                                                           data-select-only-leafs="true"/>
                                                        <input ng-repeat="x in selectedItem3" type="hidden" name="output" ng-value="'/'+x.id"/>
                                                        <input ng-repeat="x in selectedItem3" type="hidden" name="labelsOutput" ng-value="x.name"/>

                                                    </td>
                                                </tr>                                             
                                            </tbody>
                                        </table>
                                    </div>
                                </div>                                        
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3" style="width:21%;">
                            <xsl:variable name="tag" select=" 'Eperotisi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <input id="submitSearch" type="submit" class="btn btn-default .btn-sm" name="submit4search" value="{$translated}"  style="width:180"/> 
         
                        </div>
                        <div class="col-sm-6 col-md-6 col-lg-6">
                            <xsl:variable name="tag" select=" 'clearAll' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <input id="submitClearSearch" ng-click="clearAll(selectedItem3);" class="btn btn-default .btn-sm" value="{$translated}"  style="width:180"/> 
         
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
                                    <h5 class="title" style="margin-top:40px; margin-bottom:15px;">
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
                                            <input style="margin-left:12px; margin-bottom:10px"  type="radio" name="type" value="public"/>
                                            <xsl:value-of select="$translated"/>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-bottom: 10px;">
                                        <div class="col-sm-4 col-md-4 col-lg-4>">
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
                                            <input id="submitSave" type="submit" class="btn btn-default .btn-sm" name="submit4save" value="{$translated}" style="padding: 2px 12px;"/>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row savedQ">
                                <div class="col-sm-6 col-md-6 col-lg-6">
                                    <xsl:variable name="tag" select=" 'saveQuery' "/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <h5 class="title">
                                        <a class="saveQaccordion-toggle" data-toggle="collapse" href="#collapseSaveQ" aria-expanded="false" aria-controls="collapseSaveQ">
                                            <xsl:value-of select="$translated"/>
                                        </a>
                                    </h5>
                                </div>
                            </div>
                            <div class="collapse" id="collapseSaveQ">
                                <div class="searchBox">
                        
                                    <div class="row"  style="margin-top: 10px;margin-bottom: 10px;">
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
                                            <input  style="padding: 2px 12px;" type="submit" class="btn btn-default .btn-sm" name="submit4select" onClick="submitFormTo('searchForm', 'Search')" value="{$translated}"/>
                                            <xsl:if test="//context/isPersonal='true'">
                                                <xsl:variable name="tag" select=" 'Diagrafi' "/>
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:variable name="tag2" select=" 'Erwtimatiko' "/>
                                                <xsl:variable name="translated2" select="$locale/context/*[name()=$tag2]/*[name()=$lang]"/>
                                                <xsl:variable name="tag1" select=" 'DiagrafiPrompt' "/>
                                                <xsl:variable name="translated1" select="$locale/context/*[name()=$tag1]/*[name()=$lang]"/>
                                                <input style="margin-left:5px;padding: 2px 12px;" type="submit" class="btn btn-default .btn-sm" name="submit4delete" value="{$translated}" onClick="if (confirmAction('{$translated1}{$translated2}')) submitFormTo('searchForm', 'SearchDelete'); else return false;"/>
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