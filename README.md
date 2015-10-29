
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

 

FIMS
====

FIMS is a web application suitable for documenting, recording and managing XML files stored in an XML database. 
FIMS project dependecies are described in file [FIMS-Dependencies-LicensesUsed.txt](https://github.com/isl/FIMS/blob/master/FIMS-Dependencies-LicensesUsed.txt)

##Build - Deploy - Run##

Folder src contain all the files needed to build the web app and create a war file. This project is a Maven project, providing all the libs in pom.xml. 
You may use any application server that supports war files. (has been tested with Apache Tomcat version 7 or later). 
Currently, the database supported is [eXist version 2.2](http://www.exist-db.org).

##Database Setup##

For demo purposes, a sample database is provided. Also the database contains a sample entity (Person) for that purpose. 
In order to store the demo database, open the eXist client application and select from the top menu "File-->Store files/directories" and then select
the DMSCOLLECTION folder located inside "FIMS_configuration". 

##Application Setup##

Folder Structure

		Copy from “FIMS_configuration”, “fims” folder in yours desired destination. 
		In the folder “Schema”, we provide the schema of the entity Person. 

Edit web.xml

	a. SystemWebRoot: Change the port 8084, with the port of the application server. Also if necessary, change localhost to the IP of your machine
	b. DBURI: Change the port 8090 with the port of the database server. Also if necessary, change localhost to the IP of your machine
	c. DBuser: database username-Change this parameter if necessary
	d. DBpassword: database password-Change this parameter if necessary
	e. DBdriver: database driver-Change this parameter if necessary
	f. schemaFolder: Change the path to point to the correct path at your local file system (where yours schema folder is located). 
	g. SystemUploads: Change the path to point to the correct path at your local file system (where yours uploads folder is located). 
	h. Export_Import_Folder: Change the path to point to the correct path at your local file system (where yours export_import folder is located)
	i. Backups: Change the path to point to the correct path at your local file system (where yours Backups folder is located). Initially this folder is empty but when you create a System Backup from the system, the backup files are stored to this folder. 

Note:
In order the actions “Create New”, ”View” and “Edit” to work, the user should have an XML editor available 
and provide the url of the editor at the actionsMenu.xml file located in eXist. 
Also he/she should add the name of the editor’s web-app at the web.xml at the parameter editorWebapp.   





