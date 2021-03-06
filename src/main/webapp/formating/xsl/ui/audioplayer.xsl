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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:url="http://whatever/java/java.net.URLEncoder"  version=".0">
   <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>audioplayer</title>
                <script src="formating/javascript/mp3player/audio.min.js"></script>
                <script>
                    audiojs.events.ready(function() {
                    var as = audiojs.createAll();
                    });
                </script>
                

            </head>
            <body>
                
                <audio preload="auto" autoplay="true" src="FetchBinFile?file=Podcast\Audio\{encode-for-uri(//file)}&amp;mime=audio">
                </audio>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
