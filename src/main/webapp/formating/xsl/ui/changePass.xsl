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
    <xsl:include href="../ui/page.xsl"/>

    <xsl:variable name="ErrorMsg" select="//context/ErrorMsg"/>
	
    <xsl:variable name="userAction" select="//context/userAction"/>
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
        <div class="row">
            <div class="col-sm-12 col-md-12 col-lg-12">
                <h4 class="title">
                    <xsl:variable name="tag" select=" 'changePass' "/>
                    <xsl:variable name="translated" select="$locale/topmenu/*[name()=$tag]/*[name()=$lang]"/>
                    <xsl:value-of select="$translated"/>
                </h4>
                <form method="post" action="ChangePass?action={$userAction}">
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'username'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth"  readonly="true" type="text" name="username" value="{$Name}"></input>
                                <input type="hidden" id="id" name="id" value="{$Id}"></input>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'oldPassword'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="password" name="oldpassword" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'newPassword'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="password" name="password" required="true"/>
                            </p>
                        </div>
                    </div> 
                          <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'passwordV'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="password" name="passwordV" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">                  
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'lastname'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="text" name="lastname" value="{$LastName}" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'firstname'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="text" name="firstname" value="{$FirstName}" required="true"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'address'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>:
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <p>
                                <input class="inputwidth" type="text" name="address" value="{$Address}"/>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4 col-md-4 col-lg-4">
                            <p>
                                <b>
                                    <xsl:variable name="tag" select="'email'"/>
                                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                    <xsl:value-of select="$translated"/>*
                                    <xsl:text>  </xsl:text>:     
                                </b>
                            </p>
                        </div>
                        <div class="col-sm-8 col-md-8 col-lg-8">
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
                    <xsl:variable name="tag" select=" 'Cancel' "/>
                    <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                    <a style="margin-top:10px;margin-left:10px;"  class="btn btn-default .btn-sm" href="javascript:window.history.go(-1);">
                        <xsl:value-of select="$translated"/>
                    </a>
                </form>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>