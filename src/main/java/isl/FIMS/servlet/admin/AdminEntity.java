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
package isl.FIMS.servlet.admin;

import isl.FIMS.utils.ApplicationConfig;
import isl.FIMS.utils.Messages;
import isl.FIMS.utils.ParseXMLFile;
import isl.FIMS.utils.Utils;
import isl.FIMS.utils.UtilsXPaths;
import isl.FIMS.utils.entity.Config;
import isl.FIMS.utils.entity.XMLEntity;
import isl.dbms.DBFile;
import isl.dms.DMSException;
import isl.dms.file.DMSFile;
import isl.dms.file.DMSTag;
import isl.dms.file.DMSUser;
import isl.dms.xml.XMLTransform;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

//Handles the admin actions on Entities
public class AdminEntity extends AdminBasicServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, DMSException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        this.initVars(request);
        String action = request.getParameter("action");
        String type = request.getParameter("type");
        String fileId = request.getParameter("id");
        String username = getUsername(request);

        if (fileId == null) {
            fileId = type;
        }
        String mode = request.getParameter("mode");
        if (mode == null) {
            mode = "";
        }
        boolean isAdmin = this.isAdminUser(request);
        boolean isSysAdmin = this.isSysAdminUser(request);

        if (isAdmin) {
            mode = "admin";
        }
        if (isSysAdmin) {
            mode = "sys";
        }

        Config conf = new Config("Admin");

        StringBuffer xml = new StringBuffer(this.xmlStart(this.topmenu, username, this.pageTitle, this.lang, "", request));
        xml.append("<AdminMode>").append(mode).append("</AdminMode>\n");

        XMLEntity xmlE = new XMLEntity(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword, type, fileId);

        String docOrg = xmlE.getAdminProperty("organization");
        String userOrg = this.getUserGroup(username);

        if (action.equals("toinsert")) {

            xml.append("\n<result>\n<Group><group>").append(userOrg).append("</group></Group>\n</result>\n");
            xml.append(this.getGroupsXML(userOrg));
            xml.append("<Langs>\n");
            for (int i = 0; i < this.systemLangs.length; i++) {
                xml.append("<Lang>");
                xml.append(this.systemLangs[i]);
                xml.append("</Lang>\n");
            }
            xml.append("</Langs>\n");
            if (!this.dbSchemaFolder.equals("")) {
                DBFile dbf = new DBFile(this.DBURI, this.dbSchemaFolder, "schemata_list.xml", this.DBuser, this.DBpassword);
                String[] target_files = dbf.queryString("//target_info");
                xml.append("<schemata>\n");
                for (String target_name : target_files) {
                    xml.append("<schema>");
                    xml.append(target_name);
                    xml.append("</schema>");
                }
                xml.append("</schemata>\n");

            }
            conf.DISPLAY_XSL = conf.INSERT_DOC_XSL;

        } else if (action.equals("insert")) {
            String docOrgId = request.getParameter("orgId");
            String docLang = request.getParameter("lang");
            String mainCurrentName = request.getParameter("mainCurrentName");
            String codeValue = "";
            if (docOrgId == null) {
                docOrgId = this.getUserGroup(username);
            }
            if (docOrgId.equals("0")) {
                this.displayMsg = Messages.EMPTY_FIELD_OrgName + Messages.NL;
            }

            if (docLang.equals("0")) {
                this.displayMsg += Messages.EMPTY_FIELD_Lang + Messages.NL;
            }

            if (mainCurrentName.length() == 0) {
                this.displayMsg += Messages.EMPTY_FIELD_MainCurrentName + Messages.NL;
            }
            /*  if (!this.dbSchemaFolder.equals("")) {
             String[] target_schemama_id = request.getParameterValues("target_schema");
             if (target_schemama_id == null) {
             this.displayMsg += Messages.EMPTY_FIELD_TargetSchema + Messages.NL;
             }

             }
             */
            if (this.displayMsg.length() == 0) {
                try {
                    Utils u = new Utils();
                    fileId = this.initInsertFile(type, true)[0];
                    String id = fileId.split(type)[1];
                    xmlE = new XMLEntity(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword, type, fileId);

                    this.initAdminPart(xmlE, id, username);
                    xmlE.setAdminProperty("organization", docOrgId);
                    xmlE.setAdminProperty("lang", docLang);
                    String primaryPath = UtilsXPaths.getPrimaryEntitiesInsertPath(type);
                    xmlE.xUpdate(primaryPath, mainCurrentName);
                    String uri_name = DMSTag.valueOf("uri_name", "target", type, this.conf)[0];
                    codeValue = this.URI_Reference_Path + uri_name + "/" + id;
                    if (!this.dbSchemaFolder.equals("")) {

                        String[] target_schemama_id = request.getParameterValues("target_schema");
                        if (target_schemama_id != null) {
                            DBFile dbf = new DBFile(this.DBURI, this.dbSchemaFolder, "schemata_list.xml", this.DBuser, this.DBpassword);
                            String q = "//target_info[";
                            for (int i = 0; i < target_schemama_id.length; i++) {
                                q += "./@id='" + target_schemama_id[i] + "'";
                                if ((target_schemama_id.length - 1) != i) {
                                    q += " or ";
                                }
                            }
                            q += "]";
                            String res[] = dbf.queryString(q);
                            String target = "";
                            String namespace = "";
                            for (String r : res) {
                                r = r.replaceAll(" id=\".*?\"", "");
                                String target_schema = (r.split("</target_schema>")[0]).split("<target_info>")[1] + "</target_schema>";
                                namespace += (r.split("</target_schema>")[1]).split("</target_info>")[0];
                                target += "<target_info>" + target_schema + "\n<target_collection/>\n" + "</target_info>";
                            }
                            xmlE.xInsertAfter("//info/source_info", target);
                            xmlE.xAppend("//namespaces", namespace);
                        } else {
                            String target = " <target_info>\n"
                                    + "            <target_schema type=\"\" version=\"\"></target_schema>\n"
                                    + "            <target_collection/>\n"
                                    + "        </target_info>";
                            String namespace = "<namespace prefix=\"\" uri=\"\"/>";
                            xmlE.xInsertAfter("//info/source_info", target);
                            xmlE.xAppend("//namespaces", namespace);
                        }
                    }
                    this.displayMsg = Messages.ACTION_SUCCESS;
                    this.displayMsg += Messages.NL + Messages.NL + Messages.URI_ID;
                    xml.append("<codeValue>").append(codeValue).append("</codeValue>\n");
                    xml.append("<backPages>").append('2').append("</backPages>\n");

                    this.error = false;
                } catch (Exception e) {
                    this.displayMsg = Messages.wentWorng;
                }
            }

        } else if (action.equals("reqpublish")) {
            this.status = request.getParameter("status");
            boolean userCanWrite = xmlE.hasAdminProperty("write", username);
            boolean isPending = xmlE.hasAdminProperty("status", Messages.PENDING);
            boolean isPublished = xmlE.hasAdminProperty("status", Messages.PUBLISHED);
            if (isPublished) {
                this.displayMsg = Messages.DOC_IS_PUBLISHED;
            } else if (isPending) {
                this.displayMsg = Messages.DOC_IS_PENDING;
            } else if (userCanWrite) {
                xmlE.setAdminProperty("status", Messages.PENDING);
                xmlE.setAdminProperty("info", "");
                String[] references = xmlE.queryString("//admin/refs/ref");
                for (int i = 0; i < references.length; i++) {
                    Element e = Utils.getElement(references[i]);
                    String sps_type = e.getAttribute("sps_type");
                    String sps_id = e.getAttribute("sps_id");
                    XMLEntity updateXml = new XMLEntity(this.DBURI, this.systemDbCollection + sps_type, this.DBuser, this.DBpassword, sps_type, sps_type + sps_id);
                    updateXml.xUpdate("//admin/refs_by/ref_by[@sps_type='" + type + "' and @sps_id='" + fileId.split(type)[1] + "' ]/@isUnpublished", "false");
                }
                /*send email to admin when request for publish */
                DMSFile df = new DMSFile(this.conf.USERS_FILE, this.conf);
                String email = df.queryString("//DMS/users/user[@username='admin']/info/email/text()")[0];
                Document doc = ParseXMLFile.parseFile(ApplicationConfig.SYSTEM_ROOT + "formating/multi_lang.xml");
                Element root = doc.getDocumentElement();
                Element contextTag = (Element) root.getElementsByTagName("context").item(0);
                Element emailSubject = (Element) contextTag.getElementsByTagName("emailSubject_PendingRequest").item(0);
                String subject = emailSubject.getElementsByTagName(lang).item(0).getTextContent();
                if (subject.contains("systemName")) {
                    subject = subject.replace("systemName", this.systemName);
                }
                Element emailContext = (Element) contextTag.getElementsByTagName("emailContext_PendingRequest").item(0);
                String context = emailContext.getElementsByTagName(lang).item(0).getTextContent();
                context = context.replaceFirst(":", username);
                context = context.replace(":", fileId);
                context = context.replaceAll("\\?", "<br>");
                boolean isSend = Utils.sendEmail(email, subject, context);

                this.displayMsg = Messages.REQUEST_SUCCESS;
                this.error = false;
            } else {
                this.displayMsg = Messages.CANNOT_EDIT + Messages.NL;
            }

        } else if (action.equals("publish")) {

            String status = xmlE.getAdminProperty("status");
            //check if status if pendind otherwise the doc must not get publish
            if (status.equals("pending")) {
                xmlE.setAdminProperty("status", Messages.PUBLISHED);
                this.displayMsg = Messages.ACTION_SUCCESS;

                this.error = false;
            } else {
                this.displayMsg = Messages.ACCESS_DENIED;
            }

        } else if (action.equals("unpublish")) {

            String status = xmlE.getAdminProperty("status");
            if (status.equals("published")) {
                xmlE.setAdminProperty("status", Messages.UNPUBLISHED);
                this.displayMsg = Messages.ACTION_SUCCESS;
                String[] references = xmlE.queryString("//admin/refs/ref");
                for (int i = 0; i < references.length; i++) {
                    Element e = Utils.getElement(references[i]);
                    String sps_type = e.getAttribute("sps_type");
                    String sps_id = e.getAttribute("sps_id");
                    XMLEntity updateXml = new XMLEntity(this.DBURI, this.systemDbCollection + sps_type, this.DBuser, this.DBpassword, sps_type, sps_type + sps_id);
                    updateXml.xUpdate("//admin/refs_by/ref_by[@sps_type='" + type + "' and @sps_id='" + fileId.split(type)[1] + "' ]/@isUnpublished", "true");
                }
                this.error = false;
            } else {
                this.displayMsg = Messages.ACCESS_DENIED;
            }

        } else if (action.equals("torejectpublish")) {
            String status = xmlE.getAdminProperty("status");
            //check if status of doc is pending otherwise the action is not permited
            if (status.equals("pending")) {
                conf.DISPLAY_XSL = conf.REJECT_PUBLISH_DOC_XSL;
            } else {
                this.displayMsg = Messages.ACCESS_DENIED;
            }
        } else if (action.equals("rejectpublish")) {
            //do reject publish...
            String comment = request.getParameter("comment");
            if (comment.length() == 0) {
                comment = Messages.REJECTED_NO_COMMENT;
            }
            xmlE.setAdminProperty("status", Messages.REJECTED);
            xmlE.setAdminProperty("info", comment);
            String[] references = xmlE.queryString("//admin/refs/ref");
            for (int i = 0; i < references.length; i++) {
                Element e = Utils.getElement(references[i]);
                String sps_type = e.getAttribute("sps_type");
                String sps_id = e.getAttribute("sps_id");
                XMLEntity updateXml = new XMLEntity(this.DBURI, this.systemDbCollection + sps_type, this.DBuser, this.DBpassword, sps_type, sps_type + sps_id);
                updateXml.xUpdate("//admin/refs_by/ref_by[@sps_type='" + type + "' and @sps_id='" + fileId.split(type)[1] + "' ]/@isUnpublished", "true");
            }
            this.displayMsg = Messages.ACTION_SUCCESS;
            this.error = false;
        } else if (action.equals("tosetrights")) {
            boolean isWritable = Boolean.valueOf(xmlE.queryString("//admin/write='" + username + "'")[0]);
            if (docOrg.equals(userOrg) && isWritable) {
                String codeValue = "";
                String mainCurrentName = "";
                String name_path = UtilsXPaths.getPrimaryEntitiesInsertPath(type);
                codeValue = xmlE.queryString("//admin/uri_id/text()")[0];
                if (!name_path.equals("")) {
                    mainCurrentName = xmlE.queryString(name_path)[0];
                }
                xml.append("<CodeValue>").append(codeValue).append("</CodeValue>\n");
                xml.append("<MainCurrentName>").append(mainCurrentName).append("</MainCurrentName>\n");

                try {
                    DMSFile df = new DMSFile(this.conf.USERS_FILE, this.conf);
                    String q = "/DMS/users/user[groups/group/text()='" + docOrg + "' and actions/*/name()!='sysadmin' and actions/*/name()!='guest']/@username/string()";
                    String[] usernames = df.queryString(q);

                    String[] editors = xmlE.getValuesOfAdminProperty("write");
                    Arrays.sort(editors);

                    for (int u = 0; u < usernames.length; u++) {
                        if (!usernames[u].equals("") && usernames[u] != null) {
                            boolean canWrite = (Arrays.binarySearch(editors, usernames[u]) >= 0) ? true : false;
                            xml.append("<user write=\"" + canWrite + "\">").append(usernames[u]).append("</user>\n");
                        }
                    }
                } catch (DMSException e) {
                    e.printStackTrace();
                }
                conf.DISPLAY_XSL = conf.DOC_RIGHTS_XSL;
            } else {
                this.displayMsg = Messages.ACCESS_DENIED;
            }

        } else if (action.equals("setrights")) {
            if (docOrg.equals(userOrg)) {
                try {
                    String[] usernames = DMSUser.getUsersInGroup(docOrg, this.conf);
                    for (int u = 0; u < usernames.length; u++) {
                        xmlE.removeAdminProperty("write", usernames[u]);
                    }
                } catch (DMSException e) {
                    e.printStackTrace();
                }

                try {
                    xmlE.removeAdminProperty("write", "*");
                } catch (RuntimeException e1) {
                    e1.printStackTrace();
                }

                String[] usernames = request.getParameterValues("username");

                try {
                    for (int u = 0; u < usernames.length; u++) {
                        xmlE.addAdminProperty("write", usernames[u]);
                    }
                } catch (RuntimeException e) {
                    e.printStackTrace();
                }
                this.displayMsg = Messages.ACTION_SUCCESS;
                xml.append("<backPages>").append('2').append("</backPages>\n");

            } else {
                this.displayMsg = Messages.ACCESS_DENIED;
            }

        } else if (action.equals("info")) {
            this.displayMsg = xmlE.getAdminProperty("info");
            conf.DISPLAY_XSL = conf.POPUP_DISPLAY_XSL;

        } else {
            this.displayMsg = Messages.ACCESS_DENIED;
        }

        xml.append("<EntityType>").append(type).append("</EntityType>\n");
        xml.append("<FileId>").append(fileId).append("</FileId>\n");
        xml.append("<AdminAction>").append(action).append("</AdminAction>\n");
        xml.append("<Display>").append(this.displayMsg).append("</Display>\n");
        xml.append("<DisplayError>").append(this.error).append("</DisplayError>\n");

        xml.append(this.xmlEnd());
        String xsl = conf.DISPLAY_XSL;
        try {
            XMLTransform xmlTrans = new XMLTransform(xml.toString());
            xmlTrans.transform(out, xsl);
        } catch (DMSException e) {
            e.printStackTrace();
        }
        out.close();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (DMSException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (DMSException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
