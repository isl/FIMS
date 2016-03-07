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
    <xsl:template name="actions">
        <xsl:variable name="userOrg" select="//page/@userOrg"/>
        <xsl:variable name="user" select="//page/@UserRights"/>
        <xsl:variable name="username" select="//page/@user"/>
        <xsl:variable name="EntityType" select="//context/EntityType"/>
        <xsl:variable name="VocFile" select="//context/VocFile"/>

        <xsl:variable name="DocStatus" select="//context/DocStatus"/>
        <xsl:variable name="TargetCol" select="//context/TargetCol"/>
        <xsl:variable name="root" select="//context/query/Root"/>
        <div class="row">
            <div class="col-sm-7 col-md-8 col-lg-9 actionsMenu">
                <ul class="nav nav-tabs">
                    <xsl:for-each select="//actions/menugroup[menu//actionPerType[@id=$EntityType]/userRights=$user and @id!='Anazitisi']">
                        <xsl:choose>
                            <xsl:when test="count(./menu/submenu)=0">
                            
                                <xsl:for-each select="./menu[actionPerType[@id=$EntityType]/userRights=$user]">
                                    <li>
                                        <xsl:call-template name="enableLinks">
                                            <xsl:with-param name="id" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@id"/>
                                            <xsl:with-param name="href" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@href"/>
                                            <xsl:with-param name="onclick" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@onclick"/>
                                            <xsl:with-param name="image" select="string(./@img_src)"/>
                                            <xsl:with-param name="help" select="string(./@help)"/>
                                            <xsl:with-param name="hasText" select="'no'"/>

                                        </xsl:call-template> 
                                    </li>              
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <li class="moreDropDown">
                                    <div class="dropdown">                
                                        <a href="#" data-toggle="dropdown" class="dropdown-toggle"> 
                                            <xsl:variable name="tag" select="./label"/>
                                            <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                            <xsl:value-of select="$translated"/>
                                            <span class="caret moreCaret"></span> 
                                        </a>
                                        <xsl:variable name="menusNum" select="count(./menu[submenu/actionPerType[@id=$EntityType]/userRights=$user])"/>

                                        <ul class="dropdown-menu" role="menu" aria-labelledby="menu{position()}">
                                            <xsl:for-each select="./menu[submenu/actionPerType[@id=$EntityType]/userRights=$user]">
                                                <xsl:variable name="tag" select="./label"/>                                        
                                                <xsl:if test="$tag!=''">
                                                    <li class="nav-header">
                                                        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                        <xsl:value-of select="$translated"/>
                                                    </li>                                                  
                                                </xsl:if>
                                                <xsl:for-each select="./submenu[actionPerType[@id=$EntityType]/userRights=$user]">
                                                    <xsl:variable name="image_submenu" select="string(./@img_src)"/>                                         
                                                    <xsl:variable name="help_submenu" select="string(./@help)"/>                                         
                                                    <xsl:variable name="image">
                                                        <xsl:choose>
                                                         
                                                            <xsl:when test="$image_submenu!=''">                                                       
                                                                <xsl:value-of select="$image_submenu"/>
                                                            </xsl:when>                                                     
                                                        </xsl:choose>
                                                    </xsl:variable>
                                                    <li role="presentation">

                                                        <xsl:call-template name="enableLinks">
                                                            <xsl:with-param name="id" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@id"/>
                                                            <xsl:with-param name="href" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@href"/>
                                                            <xsl:with-param name="onclick" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@onclick"/>
                                                            <xsl:with-param name="help" select="$help_submenu"/>
                                                            <xsl:with-param name="hasText" select="'yes'"/>
                                                        </xsl:call-template>  
                                                    </li>     
                                                </xsl:for-each>
                                                <xsl:if test="position() &lt; $menusNum">
                                                    <li class="nav-divider"></li>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>                           
                    </xsl:for-each>        
                </ul>
            </div>
            <div class="col-sm-5 col-md-4 col-lg-3 actionsMenu">                
                <xsl:variable name="tag" select=" 'Anazitisi' "/>
                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                <ul class="nav nav-tabs">
                    <li>                    
                        <xsl:if test="$EntityType!='AdminOrg' and $EntityType!='AdminUser' and $EntityType!='Backup' and $EntityType!='AdminVocTrans' and $EntityType!='AdminVoc'">    
                            <form action="SearchResults?style=simpleSearch" id="form" method="post" class="search">
                                <i class="glyphicon glyphicon-search"></i>
                                <input placeholder="{$translated}" type="text" name="inputvalue" class="keyword"/>                
                                <input type="hidden" name="category" value="{$EntityType}"/>
                                <input type="hidden" name="status" value="all"/>
                                <input type="hidden" name="target" value="{$TargetCol}"/>
                                <input type="hidden" name="input" value="{$root}"/>
                                <input type="hidden" name="inputoper" value="contains"/>
                                <input type="hidden" name="inputparameter" value="1"/>
                                <input type="hidden" id="inputid" name="inputid" value="1"/>
                            </form>
                        </xsl:if>                           
                    </li>
                    <li>
                        <xsl:for-each select="//actions/menugroup[menu//actionPerType[@id=$EntityType]/userRights=$user and @id='Anazitisi' ]">
                            <div class="dropdown">                
                                <a href="#" data-toggle="dropdown" class="dropdown-toggle"> 
                                    <span class="caret searchCaret"></span> 
                                </a>

                                <ul id="searchDropDown" class="dropdown-menu" role="menu" aria-labelledby="menu{position()}">
                                    <xsl:for-each select="./menu[submenu/actionPerType[@id=$EntityType]/userRights=$user]">

                                        <li role="presentation">
                                            <xsl:variable name="tag" select="./label"/>
                                            <xsl:if test="$tag!=''">
                                                <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
                                                <xsl:value-of select="$translated"/> 
                                            </xsl:if>                                
                                            <xsl:variable name="image" select="string(./@img_src)"/>
                                            <xsl:variable name="help" select="string(./@help)"/>                           
                                            <xsl:for-each select="./submenu[actionPerType[@id=$EntityType]/userRights=$user]">
                                                <xsl:call-template name="enableLinks">
                                                    <xsl:with-param name="id" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@id"/>
                                                    <xsl:with-param name="href" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@href"/>
                                                    <xsl:with-param name="onclick" select="./actionPerType[@id=$EntityType]/userRights[text()=$user]/@onclick"/>
                                                    <xsl:with-param name="image" select="$image"/>
                                                    <xsl:with-param name="help" select="$help"/>
                                                    <xsl:with-param name="hasText" select="'yes'"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
        
                        </xsl:for-each>   
                    </li>  
                </ul>
            </div>
        </div>        

    </xsl:template>
    <xsl:template name="enableLinks">
        <xsl:param name="href" />
        <xsl:param name="onclick" />
        <xsl:param name="image" />
        <xsl:param name="id" />
        <xsl:param name="help" />
        <xsl:param name="hasText"/>
        <xsl:variable name="EntityType" select="//context/EntityType"/>        

        <xsl:variable name="tag" select="./label"/>
        <xsl:variable name="translated" select="$locale/context/*[name()=$tag]/*[name()=$lang]"/>
       
        <a title="{$translated}">
            <xsl:if test="count($id)>0">
                <xsl:attribute name="id">
                    <xsl:value-of select="string($id)"/>                  
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="count($href)>0">
                <xsl:attribute name="href">
                    <xsl:value-of select="string($href)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="count($onclick)>0">
                <xsl:attribute name="onclick">
                    <xsl:value-of select="string($onclick)"/>
                </xsl:attribute>
            </xsl:if>  
            <xsl:if test="$image!=''">
                <xsl:text> </xsl:text>
                <xsl:variable name="imageName" select="substring-before($image,'.')"/>
                <xsl:variable name="ext" select="substring-after($image,'.')"/>


                <img class="img-responsive" src=".{$image}" onmouseover="this.src = '.{$imageName}Hover.{$ext}';" onmouseout="this.src = '.{$image}';"/>
            </xsl:if>
            <xsl:if test="$hasText='yes'">
                <xsl:value-of select="$translated"/>
            </xsl:if>                
        </a>
    </xsl:template>
</xsl:stylesheet>