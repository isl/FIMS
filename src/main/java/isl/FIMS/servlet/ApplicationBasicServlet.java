/*
 * Copyright 2015 Institute of Computer Science,
 * Foundation for Research and Technology - Hellas
 *
 * Licensed under the EUPL, Version 1.1 or - as soon they will be approved
 * by the European Commission - subsequent versions of the EUPL (the "Licence");
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 *
 * http://ec.europa.eu/idabc/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed
 * under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and limitations
 * under the Licence.
 *
 * Contact:  POBox 1385, Heraklio Crete, GR-700 13 GREECE
 * Tel:+30-2810-391632
 * Fax: +30-2810-391638
 * E-mail: isl@ics.forth.gr
 * http://www.ics.forth.gr/isl
 *
 * Authors : Konstantina Konsolaki, Georgios Samaritakis
 *
 * This file is part of the FIMS webapp.
 */
package isl.FIMS.servlet;

import static isl.FIMS.servlet.ApplicationBasicServlet.systemDbCollection;
import isl.FIMS.utils.ApplicationConfig;
import isl.FIMS.utils.Messages;
import isl.FIMS.utils.entity.XMLEntity;
import isl.dbms.DBCollection;
import isl.dbms.DBFile;
import isl.dbms.DBMSException;
import isl.dms.DMSConfig;
import isl.dms.DMSException;
import isl.dms.file.DMSTag;
import isl.dms.file.DMSUser;
import java.io.File;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import isl.FIMS.utils.UtilsQueries;
import isl.FIMS.utils.UtilsXPaths;
import isl.FIMS.utils.entity.GetEntityCategory;
import isl.dms.file.DMSFile;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class ApplicationBasicServlet extends HttpServlet {
    //parameters from web.xml

    protected String systemWebRoot;
    public static String DBURI, DBuser, DBpassword, DB_REST_URL, systemDbCollection;
    protected static String  systemUploads, versionDbCollection;
    public static String adminDbCollection, URI_Reference_Path;
    public static String[] entityTypes, systemLangs, dbSchemaPath;
    public static String[] uploadAttributes;
    public static String[] entityListPhoto;

    public static String[] primaryEntities, secondaryEntyties;
    protected String BugReportURL, uploadsFile, dataTypesFile, BackupsFile, export_import_Folder;
    protected String picSeperator;
    protected long threshold;
    //Configuration Object
    public static DMSConfig conf;

    public static int maxCollsize;
    //various vars
    protected String status, topmenu, lang, type, category;
    protected String action = "";
    protected String servletName;
    protected static String emailPass;
    protected static String emailAdress;
    //  protected  String username;
    protected static String pageTitle = "PageTitle";
    protected static String schemaFolder;
    protected static String[] editorWebapp;
    protected static String defaultLang = "";
    protected static String defaultEntity = "";
    protected static String systemName = "";
    protected static String espaLogo = "";
    protected static String contactEmail = "";
    protected static String dbSchemaFolder = "";
    protected static String schemaVersion = "";
    protected static String systemVersion = "";
    protected static String signUpEmailUrl = "";

    public static int thumbSize, normalSize;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.servletName = config.getServletName();
        this.DBURI = getServletContext().getInitParameter("DBURI");
        this.systemWebRoot = getServletContext().getInitParameter("SystemWebRoot");
        this.DBuser = getServletContext().getInitParameter("DBuser");
        this.DBpassword = getServletContext().getInitParameter("DBpassword");
        this.systemDbCollection = getServletContext().getInitParameter("SystemDbCollection");
        this.versionDbCollection = getServletContext().getInitParameter("VersionDbCollection");
        this.adminDbCollection = getServletContext().getInitParameter("AdminDbCollection");
        this.systemUploads = getServletContext().getInitParameter("SystemUploads");
        this.entityTypes = getServletContext().getInitParameter("EntityTypes").split(",");
        this.dbSchemaPath = getServletContext().getInitParameter("dbSchemaPath").split(",");
        this.uploadAttributes = getServletContext().getInitParameter("uploadAttributes").split(",");
        this.primaryEntities = getServletContext().getInitParameter("Primary_EntityTypes").split(",");
        this.secondaryEntyties = getServletContext().getInitParameter("Secondary_EntityTypes").split(",");
        this.systemLangs = getServletContext().getInitParameter("SystemLangs").split(",");
        this.maxCollsize = Integer.parseInt(getServletContext().getInitParameter("maxCollsize"));//        mdaskal
        this.BackupsFile = getServletContext().getInitParameter("Backups");
        this.picSeperator = getServletContext().getInitParameter("picSeperator");
        this.threshold = Long.parseLong(getServletContext().getInitParameter("threshold").trim());
        this.BugReportURL = getServletContext().getInitParameter("BugReportURL");
        this.uploadsFile = getServletContext().getInitParameter("UploadsFile");
        this.export_import_Folder = getServletContext().getInitParameter("Export_Import_Folder");
        this.URI_Reference_Path = getServletContext().getInitParameter("URI_Reference_Path");
        this.dbSchemaFolder = getServletContext().getInitParameter("dbSchemaFolder");
        this.emailPass = getServletContext().getInitParameter("emailPass");
        this.emailAdress = getServletContext().getInitParameter("emailAdress");
        this.schemaVersion = getServletContext().getInitParameter("schemaVersion");
        this.systemVersion = getServletContext().getInitParameter("systemVersion");
        this.signUpEmailUrl = getServletContext().getInitParameter("signUpEmailUrl");

        File export = new File(this.export_import_Folder);
        if (!export.exists()) {
            export.mkdir();
        }
        schemaFolder = getServletContext().getInitParameter("schemaFolder");
        this.dataTypesFile = getServletContext().getInitParameter("dataTypesFile");
        this.conf = new DMSConfig(this.DBURI, this.adminDbCollection, this.DBuser, this.DBpassword);
        ApplicationConfig.init(this.systemWebRoot);
        //  this.editorWebapp = getServletContext().getInitParameter("editorWebapp");
        this.editorWebapp = getServletContext().getInitParameter("editorWebapp").split(",");

        defaultLang = getServletContext().getInitParameter("defaultLang");
        defaultEntity = getServletContext().getInitParameter("defaultEntity");
        this.systemName = getServletContext().getInitParameter("systemName");
        this.espaLogo = getServletContext().getInitParameter("espaLogo");
        this.contactEmail = getServletContext().getInitParameter("contactEmail");
        thumbSize = Integer.parseInt(getServletContext().getInitParameter("thumbSize"));
        normalSize = Integer.parseInt(getServletContext().getInitParameter("normalSize"));
        this.entityListPhoto = getServletContext().getInitParameter("entityListPhoto").split(",");
    }

    protected void initVars(HttpServletRequest request) {
        this.lang = this.getLang(request);
        this.type = request.getParameter("type");
        this.action = request.getParameter("action");
        this.status = request.getParameter("status");
        this.category = request.getParameter("category");
        this.conf.LANG = this.lang;
    }

    public String getSystemWebRoot(HttpServletRequest request) {
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        String baseURL = "http://" + serverName + ":" + serverPort + contextPath + "/";
        return baseURL;
    }

    public String getRights(String username) {
        String UserRights = null;
        try {

            DMSUser Actions = new DMSUser(username, this.conf);
            String[] ActionArray = Actions.getActions();
            UserRights = ActionArray[0];
        } catch (DMSException e) {
            e.printStackTrace();
        }
        return UserRights;
    }

    public static String returnDBSystem() {
        String systemdbColl = systemDbCollection;
        return systemdbColl;
    }

    public static String returnLogfilePath() {
        String logFilePath = systemUploads;
        return logFilePath;
    }

    public String xmlStart(String topmenu, String user, String title, String lang, String mode, HttpServletRequest request) {
        String username = getUsername(request);
        String UserRights = getRights(username);
        String userOrg = this.getUserGroup(username);
        HttpSession session = request.getSession(true);
        DMSFile df = new DMSFile(this.conf.USERS_FILE, this.conf);
        String firstname = "";
        String lastname = "";
        String temp[];
        try {
            temp = df.queryString("/DMS/users/user[./@username='" + user + "']/info/firstname/text()");
            if (temp.length > 0) {
                firstname = temp[0];
            }
            temp = df.queryString("/DMS/users/user[./@username='" + user + "']/info/lastname/text()");
            if (temp.length > 0) {
                lastname = temp[0];
            }
        } catch (DMSException ex) {
        }

        String pageXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<page user=\"" + user + "\" fullname=\"" + firstname + " " + lastname + "\" UserRights=\"" + UserRights + "\" userOrg=\"" + userOrg + "\" title=\"" + title + "\" language=\"" + lang + "\" mode=\"" + mode + "\">\n" +/* "<systemRoot>" + ApplicationConfig.SYSTEM_ROOT + "</systemRoot>\n" +*/ "<header>\n" + "</header>\n" + session.getAttribute("topSettings") + "\n" + session.getAttribute("leftmenu") + "\n" + "<context>\n" + session.getAttribute("actionsMenu") + "\n";
        return pageXML;
    }

    public String getXMLPart(String fileName, DBCollection col) {
        String menu = "";
        try {
            DBFile dbf = col.getFile(fileName + ".xml");
            menu = dbf.getXMLAsString();
        } catch (Exception e) {
        }
        return menu;
    }

    public String xmlEnd() {
        String systemNameInfo = "<systemName>" + this.systemName + "</systemName>";
        String espaLogo = "<espaLogo>" + this.espaLogo + "</espaLogo>";
        String contactEmail = "<contactEmail>" + this.contactEmail + "</contactEmail>";

        return contactEmail + "\n" + espaLogo + "\n" + systemNameInfo + "\n" + "\n</context>\n<footer/>\n</page>";
    }

    public String getAction() {
        return (this.action == null) ? "" : this.action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getStatus() {
        return (this.status == null) ? "" : this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLang(HttpServletRequest request) {

        if (request.getSession(false) != null) {
            String lang = (String) request.getSession(false).getAttribute("lang");
            if (lang == null) {
                lang = defaultLang;
            }
            return lang;
        } else {
            return defaultLang;
        }
    }

    public String getUsername(HttpServletRequest request) {
        if (request.getSession(false) != null) {
            String user = (String) request.getSession(false).getAttribute("username");
            if (user == null) {
                user = "";
            }
            return user;
        } else {
            return "";
        }
    }

    public int getUserId(HttpServletRequest request) throws DMSException {
        //from the database
        String username = (String) (request.getSession().getAttribute("username"));
        DMSUser user = new DMSUser(username, this.conf);
        return user.getId();
    }

    public String getUserGroup(String username) {
        //from the database
        //implies that user belongs to ONLY one group...

        DMSUser user;

        String[] ret;
        try {
            user = new DMSUser(username, this.conf);
            ret = user.getGroups();
            if (ret.length == 0) {
                return null;
            } else {
                return ret[0];
            }
        } catch (DMSException e) {
            e.printStackTrace();
        }

        return null;
    }

    public String getUserInfo(String info, String username) {
        //from the database
        DMSUser user;
        String value = null;
        try {
            user = new DMSUser(username, this.conf);
            value = user.getInfo(info);
        } catch (DMSException e) {
            e.printStackTrace();
        }
        return value;
    }

    public boolean userHasAction(String action, String username) {
        //from the database
        DMSUser user;
        boolean ret = false;
        try {
            user = new DMSUser(username, this.conf);
            ret = user.hasAction(action);
        } catch (DMSException e) {
        }
        return ret;
    }

    public void initAdminPart(XMLEntity xmlE, String id, String username) {
        xmlE.setAdminProperty("lang", this.lang);
        xmlE.setAdminProperty("organization", this.getUserGroup(username));
        xmlE.setAdminProperty("creator", username);
        xmlE.setAdminProperty("versions/versionUser", username);
        xmlE.setAdminProperty("versions/versionId", "1");
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        xmlE.setAdminProperty("versions/versionDate", dateFormat.format(date));
        xmlE.setAdminProperty("saved", "yes");
        xmlE.setAdminProperty("locked", "no");
        if (GetEntityCategory.getEntityCategory(type).equals("primary")) {
            xmlE.setAdminProperty("status", Messages.UNPUBLISHED);
            xmlE.setAdminProperty("info", "");
        }

        xmlE.setAdminProperty("write", username);
        //xmlE.setAdminProperty("read", this.username);
        xmlE.setAdminProperty("read", "*");
        String uri_name = "";
        try {
            uri_name = DMSTag.valueOf("uri_name", "target", type, this.conf)[0];
        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        String uriValue = this.URI_Reference_Path + uri_name + "/" + id;
        String uriPath = UtilsXPaths.getPathUriField(type);
        xmlE.setAdminProperty("uri_id", uriValue);
        if (!uriPath.equals("")) {
            xmlE.xUpdate(uriPath, uriValue);
        }
    }

    public String[] initInsertFile(String type, boolean toStoreFile) {
        DBCollection col = new DBCollection(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword);
        String collName = "";

        String id = "";
        int idInt = UtilsQueries.getLastId(col);
        if (idInt != 0) {
            idInt = idInt + 1;
            id = String.valueOf(idInt);
        } else {
            id = XMLEntity.newId(col, type);
        }

        String fileId = type + id;
        DBFile f = col.getFile(type + ".xml");

        //Antigafoume to 'protupo' ('type'.xml) se kainourio
        String results = UtilsQueries.getminColl(this.systemDbCollection, type, col);
        String minColl = results.substring(results.indexOf("<coll>") + 6, results.indexOf("</coll>"));
        String minfiles = results.substring(results.indexOf("<min>") + 5, results.indexOf("</min>"));
        int filesSize = Integer.parseInt(minfiles);
        if (filesSize > this.maxCollsize) {
            String maxCollName = UtilsQueries.getmaxCollName(this.systemDbCollection, type, col);
            int maxColl = Integer.parseInt(maxCollName);
            maxColl = maxColl + 1;
            maxCollName = String.valueOf(maxColl);
            try {
                col.createCollection(maxCollName);
            } catch (DBMSException e) {
                e.printStackTrace();
            }
            col = new DBCollection(this.DBURI, this.systemDbCollection + type + "/" + maxCollName, this.DBuser, this.DBpassword);
            collName = this.systemDbCollection + type + "/" + maxCollName;

        } else {
            collName = this.systemDbCollection + type + "/" + minColl;
            col = new DBCollection(this.DBURI, this.systemDbCollection + type + "/" + minColl, this.DBuser, this.DBpassword);
        }
        if (toStoreFile) {
            DBFile newF = f.storeIntoAs(col, fileId + ".xml");
            newF.xUpdate("//admin/id/text()", id);
        }
        String[] ret = {fileId, collName};
        return ret;
    }

    public void deleteCollectionsBeforeRestore() {

        DBCollection dbc = new DBCollection(this.DBURI, this.systemDbCollection, this.DBuser, this.DBpassword);
        String[] childCollections = dbc.listChildCollections();

        for (int i = 0; i < childCollections.length; i++) {
            String col = childCollections[i];
            try {
                dbc.removeCollection(col);
            } catch (DBMSException e) {
                e.printStackTrace();
            }
        }
    }

    public String findDependantsOfOrganizations(String id) {
        String result = "false";
        for (int i = 0; i < this.entityTypes.length; i++) {
            String type = this.entityTypes[i];
            DBCollection dbc = new DBCollection(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword);
            String adminquery = "//admin/organization='" + id + "'";
            String[] fileArray = dbc.query(adminquery);

            if (fileArray[0].equals("true")) {
                result = "true";
                break;
            }
        }
        return result;
    }

    public static String[] getEntityTypes() {
        return entityTypes;
    }

    public static DMSConfig getDMSConfig() {
        return conf;
    }
}
