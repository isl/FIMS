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
	
    <xsl:variable name="AdminAction" select="//context/AdminAction"/>
    <xsl:variable name="AdminMode" select="//context/AdminMode"/>
	
    <xsl:variable name="Organization" select="//context/result/Organization/Organization"/>
    <xsl:variable name="Id" select="//context/result/Id/Id"/>
    <xsl:variable name="Name" select="//context/result/Name/Name"/>
    <xsl:variable name="LastName" select="//context/result/LastName/lastname"/> 
    <xsl:variable name="FirstName" select="//context/result/FirstName/firstname"/>
    <xsl:variable name="Address" select="//context/result/Address/address"/>
    <xsl:variable name="Email" select="//context/result/Email/email"/> 
    <xsl:variable name="OrgId" select="//context/result/Group/group"/> 
    <xsl:variable name="Role" select="//context/result/Actions/Actions"/>
    <xsl:variable name="emailMsg" select="$locale/context/NotValidEmail/*[name()=$lang]"/>
    <xsl:variable name="notEmptyFields" select="$locale/context/notEmptyFields/*[name()=$lang]"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
        <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select="//leftmenu/menugroup/menu[@id='AdminUser']/label/text()"/>
                    <xsl:variable name="translated" select="$locale/leftmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                    <xsl:text> - </xsl:text>
                    <xsl:variable name="tag">
                        <xsl:choose>
                            <xsl:when test="$AdminAction='insert'">
                                <xsl:value-of select=" 'Eisagwgi' "/>
                            </xsl:when>
                            <xsl:when test="$AdminAction='edit'">
                                <xsl:value-of select=" 'Epexergasia' "/>
                            </xsl:when>
                            <xsl:when test="$AdminAction='view'">
                                <xsl:value-of select=" 'Proboli' "/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form action="AdminUser?action={$AdminAction}&amp;mode={$AdminMode}" method="post">
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'username'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="text" name="username" value="{$Name}" required="true"/>
                                <input type="hidden" id="id" name="id" value="{$Id}"></input>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'password'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="password" name="password" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'passwordV'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="password" name="passwordV" required="true"/>
                            </p>
                        </div>
                    </div>                    
                    <xsl:choose>
                        <xsl:when test="$Role='sysadmin'">
                        </xsl:when>
                        <xsl:when test="$AdminMode='' and $Role='admin'">
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="row">
                                <div class="col-sm-3 col-md-3 col-lg-3">
                                    <p>
                                        <b>
                                            <xsl:variable name="tag" select="'orgname'"/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>:
                                        </b>
                                    </p>
                                </div>
                                <div class="col-sm-9 col-md-9 col-lg-9">
                                    <p>                                    
                                        <xsl:variable name="tag" select=" 'AdminOrganization' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                          
                                        <select data-placeholder="{$translated}" style="width:45%;" class="chosen" name="orgId">                                
                                            <xsl:for-each select="//context/groups/group">
                                                <option value="{./id}">
                                                    <xsl:if test=" ./id = $OrgId ">
                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="./name"/>
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
                                            <xsl:variable name="tag" select="'userrole'"/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>:
                                        </b>
                                    </p>
                                </div>
                                <div class="col-sm-9 col-md-9 col-lg-9">
                                    <p>                                    
                                        <xsl:variable name="tag" select=" 'userrole' "/>
                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>                          
                                        <select data-placeholder="{$translated}" style="width:45%;" class="chosen" name="userrole">
                                            <xsl:variable name="tag" select=" 'sintaktis' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <option value="editor">
                                                <xsl:value-of select="$translated"/>
                                            </option>                                
                                            <xsl:variable name="tag" select=" 'episkeptis' "/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <option value="guest">
                                                <xsl:if test=" $Role = 'guest' ">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="$translated"/>
                                            </option>
                                            <xsl:choose>
                                                <xsl:when test="$AdminMode='sys'">
                                                    <xsl:variable name="tag" select=" 'admin' "/>
                                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                    <option value="admin">
                                                        <xsl:if test=" $Role = 'admin' ">
                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="$translated"/>
                                                    </option>
                                                </xsl:when>								
                                            </xsl:choose>
                                        </select>                                
                                    </p>
                                </div>
                            </div>                            
                        </xsl:otherwise>
                    </xsl:choose>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'lastname'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="text" name="lastname" value="{$LastName}" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'firstname'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="text" name="firstname" value="{$FirstName}" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'address'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="text" name="address" value="{$Address}"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'email'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:     
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-9 col-md-9 col-lg-9">
                            <p>
                                <input class="inputwidth" type="email" name="email" value="{$Email}" required="true"/>
                            </p>
                        </div>
                    </div>
                    <input type="hidden" name="lang" value="{$lang}"/>
                    <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <button id="finishButton" class="btn btn-default .btn-sm" style="margin-top:10px;" type="submit">    
                        <xsl:value-of select="$translated"/>
                    </button> 
                    <xsl:variable name="tag" select=" 'Epistrofi' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <a class="btn btn-default .btn-sm" id="backButton" href="javascript:window.history.go(-1);">
                        <xsl:value-of select="$translated"/>
                    </a>
                </form>
            </div>
        </div> 
        <script type="text/javascript">
            $(document).ready(function(){
             
            jQuery(".chosen").select2();
            if('<xsl:value-of select="$AdminAction"/>'=="view"){
            $finish=$("#finishButton").hide();
            $input=  $("input:text, input:password, input[type=email], textarea");
            $('select').prop('disabled', true).trigger("liszt:updated");
            $input.attr("disabled",true);
            }else{
            $back=$("#backButton").hide();

            }
            if('<xsl:value-of select="$AdminAction"/>'=="edit"){
            $("#username").attr('readonly','readonly');
            }

            });
        </script>          
    </xsl:template>
</xsl:stylesheet>