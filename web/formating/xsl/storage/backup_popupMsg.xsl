<?xml version="1.0" encoding="UTF-8"?>
<!--
 COPYRIGHT (c) 20??-2014 by Institute of Computer Science,
 Foundation for Research and Technology - Hellas
 Contact:
 POBox 1385, Heraklio Crete, GR-700 13 GREECE
 Tel:+30-2810-391632
 Fax: +30-2810-391638
 E-mail: isl@ics.forth.gr
 http://www.ics.forth.gr/isl

 Authors : Konstantina Konsolaki, Georgios Samaritakis.

 This file is part of the FIMS webapp..

 FIMS webapp is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 FIMS webapp is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with FIMS webapp. If not, see &lt;http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:template name="splashB">
        <div id="pleasewaitScreenB" style="position:absolute;z-index:5;top:17%;left:38%;visibility:hidden;">
            <table bgcolor="#000000" border="1" bordercolor="#000000" cellpadding="0" cellspacing="0" height="200" width="300">
                <tr>
                    <td width="100%" height="100%" bgcolor="#FFFFFF" align="center" valign="middle">
                        <br/>                                                
                        <img src="formating/images/ajax-loader.gif"/>
                        <br/>
                        <br/>
                        <xsl:variable name="tag" select=" 'backupSplashMessage' "/> 
                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                        <font face="Helvetica,verdana,Arial" size="3" color="#000066">
                            <b>
                                <xsl:value-of select="$translated"/>
                            </b>
                        </font>
                        <br/>
                        <br/>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>
</xsl:stylesheet>