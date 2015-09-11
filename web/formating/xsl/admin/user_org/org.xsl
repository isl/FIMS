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

    <xsl:variable name="AdminAction" select="//context/AdminAction"/>
    <xsl:variable name="Id" select="//context/Id"/>
    <xsl:variable name="Name" select="//context/Name"/>
    <xsl:variable name="initials" select="//context/initials"/>
    <xsl:variable name="country" select="//context/country"/>
    <xsl:variable name="information" select="//context/information"/>
     <xsl:variable name="LastName" select="//context/result/LastName/lastname"/>
    <xsl:variable name="FirstName" select="//context/result/FirstName/firstname"/>
    <xsl:variable name="Address" select="//context/result/Address/address"/>
    <xsl:variable name="Email" select="//context/result/Email/email"/> 
    <xsl:variable name="seat" select="//context/seat"/>
    <xsl:variable name="emailMsg" select="$locale/context/NotValidEmail/*[name()=$lang]"/>
    <xsl:variable name="notEmptyFields" select="$locale/context/notEmptyFields/*[name()=$lang]"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <td colSpan="{$columns}" vAlign="top" align="center" class="content">
            <form id="orgForm" method="post" action="AdminOrg?action={$AdminAction}&amp;mode=sys" style="margin-bottom:0px;" onsubmit="return validateAll();">
		<br/>	
                <table width="100%" class="contentText">
                    <tr>
                        <xsl:variable name="tag" select=" 'Επωνυμία' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <td width="20%" >
                            <xsl:value-of select="$translated"/>*
                        </td>
                        <td>
                            <input class="mandatary" type="text" id="name" name="name" style="width:200px" value="{$Name}"></input>
                            <input type="hidden" id="id" name="id" value="{$Id}"></input>
                        </td>
                    </tr>
                    <tr>
                        <xsl:variable name="tag" select=" 'Ακρώνυμο' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <td width="20%" >
                            <xsl:value-of select="$translated"/>*
                        </td>
                        <td>
                            <input  class="mandatary" type="text" id="initials" name="initials" style="width:200px" value="{$initials}"></input>
                        </td>
                    </tr>
                    <tr>
                        <xsl:variable name="tag" select=" 'Έδρα' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <td width="20%" >
                            <xsl:value-of select="$translated"/>
                        </td>
                        <td>
                            <input type="text" id="seat" name="seat" style="width:200px" value="{$seat}"></input>
                        </td>
                    </tr>
                    <tr>
                        <xsl:variable name="tag" select=" 'Κράτος' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <td width="20%" >
                            <xsl:value-of select="$translated"/>*
                        </td>
                        <td>
                            <input  class="mandatary" type="text" id="country" name="country" style="width:200px" value="{$country}"></input>
                        </td>
                    </tr>
                    <tr>
                        <xsl:variable name="tag" select=" 'Πληροφορίες' "/>
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <td width="20%" >
                            <xsl:value-of select="$translated"/>
                        </td>
                        <td>
                            <textarea name="information" id="information" rows="3" style="width:200px">
                                <xsl:value-of select="$information"/>
                            </textarea>
                        </td>
                    </tr>
                    <xsl:if test= "$AdminAction = 'insert' ">
                        <tr>
                            <td colspan="2">
                                <hr size="0"/>
                            </td>
                        </tr>
                        <tr>                        
                            <td>
                                <xsl:variable name="tag" select=" 'createAdmin' "/>
                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                <p style="white-space:nowrap; font-weight:bold;font-size:12px;text-decoration:underline;">
                                    <xsl:value-of select="$translated"/>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'username' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/> 
                            <td width="25%">
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="text" id="username" name="username" style="width:200px" value="{$Name}"></input>
                                <input type="hidden" id="id" name="id" value="{$Id}"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'password' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td>
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="password" name="password" style="width:200px"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'passwordV' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td>
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="password" name="passwordV" style="width:200px"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'lastname' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td >
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="text" id="lastname" name="lastname" style="width:200px" value="{$LastName}"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'firstname' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td >
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="text" id="firstname" name="firstname" style="width:200px" value="{$FirstName}"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'address' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td >
                                <xsl:value-of select="$translated"/>
                            </td>
                            <td>
                                <input type="text" id="address" name="address" style="width:200px" value="{$Address}"></input>
                            </td>
                        </tr>
                        <tr>
                            <xsl:variable name="tag" select=" 'email' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <td >
                                <xsl:value-of select="$translated"/>*
                            </td>
                            <td>
                                <input  class="mandatary" type="text" id="email" name="email" style="width:200px" value="{$Email}"></input>
                            </td>
                        </tr>
                    </xsl:if>
                    <tr>
                        <td></td>
                        <td>
                            <br/>
                            <input type="hidden" name="lang" value="{$lang}"/>
                            <xsl:variable name="tag" select=" 'Oloklirwsi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <input type="submit" class="button" id="finishButton" value="{$translated}"></input>	
                            <xsl:variable name="tag" select=" 'Epistrofi' "/>
                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                            <a id="backButton" href="javascript:window.history.go(-1);">
                                <xsl:value-of select="$translated"/>
                            </a>
                        </td>
                       
                    </tr>
                </table>
            </form>
            <br/>
            <script language="javascript">document.getElementById('name').focus();</script>
            <script language="javascript">
                if('<xsl:value-of select="$AdminAction"/>'=="view"){
                $finish=$("#finishButton").hide();
                $input=  $("input:text, textarea, #country");
                $input.attr("disabled",true);
                }else{
                $back=$("#backButton").hide();
                }   
                
                   function validateAll(){
                var value ="";
            
                $(".mandatary").each(function( index ) {
                var msg = '<xsl:value-of select="$notEmptyFields"/>';
                
                if($( this ).val()==''){ 
                    value ="false";

                alert(msg);
                return false;  
                }
                return true;                
                });
                    
                if(value=='false')
                return false;
                var email = $("#email").val();
                var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;  
                if(!email.match(mailformat))  
                {
                var msg = '<xsl:value-of select="$emailMsg"/>';
                alert(msg);  
                return false;
                
                }
                return true;
                }
            </script>
        </td>
    </xsl:template>
</xsl:stylesheet>