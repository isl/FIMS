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
package isl.FIMS.servlet.imports;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.ApplicationConfig;
import isl.FIMS.utils.Messages;
import isl.FIMS.utils.ParseXMLFile;
import isl.FIMS.utils.Utils;
import isl.FIMS.utils.UtilsXPaths;
import isl.FIMS.utils.entity.Config;
import isl.FIMS.utils.entity.GetEntityCategory;
import isl.FIMS.utils.entity.XMLEntity;
import isl.dbms.DBCollection;
import isl.dbms.DBFile;
import isl.dms.DMSException;
import isl.dms.file.DMSTag;
import isl.dms.xml.XMLTransform;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.FileCleanerCleanup;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileCleaningTracker;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import schemareader.SchemaFile;

/*
 * @author konsolak
 */
public class ImportXML extends ApplicationBasicServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private BufferedReader input;
    private static final int REQUEST_SIZE = 1000000000 * 1024;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        this.initVars(request);
        String username = getUsername(request);

        Config conf = new Config("EisagwghXML_RDF");
        String xsl = ApplicationConfig.SYSTEM_ROOT + "formating/xsl/import/ImportXML.xsl";
        String displayMsg = "";
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder xml = new StringBuilder(this.xmlStart(this.topmenu, username, this.pageTitle, this.lang, "", request));
        //  ArrayList<String> notValidMXL = new ArrayList<String>();
        HashMap<String, ArrayList> notValidMXL = new <String, ArrayList>HashMap();
        if (!ServletFileUpload.isMultipartContent(request)) {
            displayMsg = "form";
        } else {
            // configures some settings
            String filePath = this.export_import_Folder;
            java.util.Date date = new java.util.Date();
            Timestamp t = new Timestamp(date.getTime());
            String currentDir = filePath + t.toString().replaceAll(":", "");
            File saveDir = new File(currentDir);
            if (!saveDir.exists()) {
                saveDir.mkdir();
            }
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD);
            factory.setRepository(saveDir);
            ArrayList<String> savedIDs = new ArrayList<String>();

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(REQUEST_SIZE);
            // constructs the directory path to store upload file
            String uploadPath = currentDir;
            int xmlCount = 0;
            String[] id = null;
            try {
                // parses the request's content to extract file data
                List formItems = upload.parseRequest(request);
                Iterator iter = formItems.iterator();
                // iterates over form's fields
                File storeFile = null;
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    // processes only fields that are not form fields
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        filePath = uploadPath + File.separator + fileName;
                        storeFile = new File(filePath);
                        item.write(storeFile);
                        Utils.unzip(fileName, uploadPath);
                        File dir = new File(uploadPath);

                        String[] extensions = new String[]{"xml", "x3ml"};
                        List<File> files = (List<File>) FileUtils.listFiles(dir, extensions, true);
                        xmlCount = files.size();
                        for (File file : files) {
                            // saves the file on disk
                            Document doc = ParseXMLFile.parseFile(file.getPath());
                            String xmlContent = doc.getDocumentElement().getTextContent();
                            String uri_name = "";
                            try {
                                uri_name = DMSTag.valueOf("uri_name", "target", type, this.conf)[0];
                            } catch (DMSException ex) {
                                ex.printStackTrace();
                            }
                            String uriValue = this.URI_Reference_Path + uri_name + "/";
                            boolean insertEntity = false;
                            if (xmlContent.contains(uriValue) || file.getName().contains(type)) {
                                insertEntity = true;
                            }
                            Element root = doc.getDocumentElement();
                            Node admin = Utils.removeNode(root, "admin", true);

                            //  File rename = new File(uploadPath + File.separator + id[0] + ".xml");
                            //  boolean isRename = storeFile.renameTo(rename);
                            //   ParseXMLFile.saveXMLDocument(rename.getPath(), doc);
                            String schemaFilename = "";
                            schemaFilename = type;

                            SchemaFile sch = new SchemaFile(schemaFolder + schemaFilename + ".xsd");
                            TransformerFactory tf = TransformerFactory.newInstance();
                            Transformer transformer = tf.newTransformer();
                            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
                            StringWriter writer = new StringWriter();
                            transformer.transform(new DOMSource(doc), new StreamResult(writer));
                            String xmlString = writer.getBuffer().toString().replaceAll("\r", "");

                            //without admin
                            boolean isValid = sch.validate(xmlString);
                            if ((!isValid && insertEntity)) {
                                notValidMXL.put(file.getName(), null);
                            } else if (insertEntity) {
                                id = initInsertFile(type, false);
                                doc = createAdminPart(id[0], type, doc, username);
                                writer = new StringWriter();
                                transformer.transform(new DOMSource(doc), new StreamResult(writer));
                                xmlString = writer.getBuffer().toString().replaceAll("\r", "");
                                DBCollection col = new DBCollection(this.DBURI, id[1], this.DBuser, this.DBpassword);
                                DBFile dbF = col.createFile(id[0] + ".xml", "XMLDBFile");
                                dbF.setXMLAsString(xmlString);
                                dbF.store();
                                ArrayList<String> externalFiles = new <String> ArrayList();
                                ArrayList<String> externalDBFiles = new <String> ArrayList();

                                String q = "//*[";
                                for (String attrSet : this.uploadAttributes) {
                                    String[] temp = attrSet.split("#");
                                    String func = temp[0];
                                    String attr = temp[1];
                                    if (func.contains("text")) {
                                        q += "@" + attr + "]/text()";
                                    } else {
                                        q = "data(//*[@" + attr + "]/@" + attr + ")";
                                    }
                                    String[] res = dbF.queryString(q);
                                    for (String extFile : res) {
                                        externalFiles.add(extFile + "#" + attr);
                                    }
                                }
                                q = "//";
                                if (!dbSchemaPath[0].equals("")) {
                                    for (String attrSet : this.dbSchemaPath) {
                                        String[] temp = attrSet.split("#");
                                        String func = temp[0];
                                        String path = temp[1];
                                        if (func.contains("text")) {
                                            q += path + "//text()";
                                        } else {
                                            q = "data(//" + path + ")";
                                        }
                                        String[] res = dbF.queryString(q);
                                        for (String extFile : res) {
                                            externalDBFiles.add(extFile);
                                        }
                                    }
                                }
                                ArrayList<String> missingExternalFiles = new <String> ArrayList();
                                for (String extFile : externalFiles) {
                                    extFile = extFile.substring(0, extFile.lastIndexOf("#"));

                                    List<File> f = (List<File>) FileUtils.listFiles(dir, FileFilterUtils.nameFileFilter(extFile), TrueFileFilter.INSTANCE);
                                    if (f.size() == 0) {
                                        missingExternalFiles.add(extFile);
                                    }
                                }
                                if (missingExternalFiles.size() > 0) {
                                    notValidMXL.put(file.getName(), missingExternalFiles);
                                }

                                XMLEntity xmlNew = new XMLEntity(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword, type, id[0]);

                                ArrayList<String> worngFiles = Utils.checkReference(xmlNew, this.DBURI, id[0], type, this.DBuser, this.DBpassword);
                                if (worngFiles.size() > 0) {
                                    //dbF.remove();
                                    notValidMXL.put(file.getName(), worngFiles);
                                }
                                //remove duplicates from externalFiles if any
                                HashSet hs = new HashSet();
                                hs.addAll(missingExternalFiles);
                                missingExternalFiles.clear();
                                missingExternalFiles.addAll(hs);
                                if (missingExternalFiles.isEmpty() && worngFiles.isEmpty()) {

                                    for (String extFile : externalFiles) {
                                        String attr = extFile.substring(extFile.lastIndexOf("#") + 1, extFile.length());
                                        extFile = extFile.substring(0, extFile.lastIndexOf("#"));

                                        List<File> f = (List<File>) FileUtils.listFiles(dir, FileFilterUtils.nameFileFilter(extFile), TrueFileFilter.INSTANCE);
                                        File uploadFile = f.iterator().next();
                                        String content = FileUtils.readFileToString(uploadFile);

                                        DBFile uploadsDBFile = new DBFile(this.DBURI, this.adminDbCollection, "Uploads.xml", this.DBuser, this.DBpassword);
                                        String mime = Utils.findMime(uploadsDBFile, uploadFile.getName(), attr);
                                        String uniqueName = Utils.createUniqueFilename(uploadFile.getName());
                                        File uploadFileUnique = new File(uploadFile.getPath().substring(0, uploadFile.getPath().lastIndexOf(File.separator)) + File.separator + uniqueName);
                                        uploadFile.renameTo(uploadFileUnique);
                                        xmlString = xmlString.replaceAll(uploadFile.getName(), uniqueName);
                                        String upload_path = this.systemUploads + type;
                                        File upload_dir = null;;
                                        if (mime.equals("Photos")) {
                                            upload_path += File.separator + mime + File.separator + "original" + File.separator;
                                            upload_dir = new File(upload_path + uniqueName);
                                            FileUtils.copyFile(uploadFileUnique, upload_dir);
                                            Utils.resizeImage(uniqueName, upload_path, upload_path.replaceAll("original", "thumbs"), thumbSize);
                                            Utils.resizeImage(uniqueName, upload_path, upload_path.replaceAll("original", "normal"), normalSize);
                                            xmlString = xmlString.replace("</versions>", "</versions>" + "\n" + "<type>Photos</type>");
                                        } else {
                                            upload_path += File.separator + mime + File.separator;
                                            upload_dir = new File(upload_path + uniqueName);
                                            FileUtils.copyFile(uploadFileUnique, upload_dir);
                                        }
                                        if (!dbSchemaFolder.equals("")) {
                                            if (externalDBFiles.contains(extFile)) {
                                                try {
                                                    DBCollection colSchema = new DBCollection(this.DBURI, dbSchemaFolder, this.DBuser, this.DBpassword);
                                                    DBFile dbFSchema = colSchema.createFile(uniqueName, "XMLDBFile");
                                                    dbFSchema.setXMLAsString(content);
                                                    dbFSchema.store();
                                                } catch (Exception e) {
                                                }
                                            }
                                        }
                                        uploadFileUnique.renameTo(uploadFile);

                                    }
                                    dbF.setXMLAsString(xmlString);
                                    dbF.store();
                                    Utils.updateReferences(xmlNew, this.DBURI, id[0].split(type)[1], type, this.DBpassword, this.DBuser);
                                    Utils.updateVocabularies(xmlNew, this.DBURI, id[0].split(type)[1], type, this.DBpassword, this.DBuser, lang);
                                    savedIDs.add(id[0]);
                                } else {
                                    dbF.remove();
                                }

                            }
                        }

                    }
                }
                Document doc = ParseXMLFile.parseFile(ApplicationConfig.SYSTEM_ROOT + "formating/multi_lang.xml");
                Element root = doc.getDocumentElement();
                Element contextTag = (Element) root.getElementsByTagName("context").item(0);
                String uri_name = "";
                try {
                    uri_name = DMSTag.valueOf("uri_name", "target", type, this.conf)[0];
                } catch (DMSException ex) {
                }
                if (notValidMXL.size() == 0) {
                    xsl = conf.DISPLAY_XSL;
                    displayMsg = Messages.ACTION_SUCCESS;
                    displayMsg += Messages.NL + Messages.NL + Messages.URI_ID;
                    String uriValue = "";
                    xml.append("<Display>").append(displayMsg).append("</Display>\n");
                    xml.append("<backPages>").append('2').append("</backPages>\n");

                    for (String saveId : savedIDs) {
                        uriValue = this.URI_Reference_Path + uri_name + "/" + saveId + Messages.NL;
                        xml.append("<codeValue>").append(uriValue).append("</codeValue>\n");

                    }

                } else if (notValidMXL.size() >= 1) {
                    xsl = ApplicationConfig.SYSTEM_ROOT + "formating/xsl/import/ImportXML.xsl";

                    Iterator it = notValidMXL.keySet().iterator();
                    while (it.hasNext()) {

                        String key = (String) it.next();
                        ArrayList<String> value = notValidMXL.get(key);

                        if (value != null) {
                            displayMsg += "<line>";
                            Element select = (Element) contextTag.getElementsByTagName("missingReferences").item(0);
                            displayMsg += select.getElementsByTagName(lang).item(0).getTextContent();
                            displayMsg = displayMsg.replace("?", key);
                            for (String mis_res : value) {

                                displayMsg += mis_res + ",";
                            }
                            displayMsg = displayMsg.substring(0, displayMsg.length() - 1);
                            displayMsg += ".";
                            displayMsg += "</line>";

                        } else {
                            displayMsg += "<line>";
                            Element select = (Element) contextTag.getElementsByTagName("NOT_VALID_XML").item(0);
                            displayMsg += select.getElementsByTagName(lang).item(0).getTextContent();
                            displayMsg = displayMsg.replace(";", key);
                            displayMsg += "</line>";
                        }
                        displayMsg += "<line>";
                        displayMsg += "</line>";
                    }
                    if (notValidMXL.size() < xmlCount) {
                        displayMsg += "<line>";
                        Element select = (Element) contextTag.getElementsByTagName("rest_valid").item(0);
                        displayMsg += select.getElementsByTagName(lang).item(0).getTextContent();
                        displayMsg += "</line>";
                        for (String saveId : savedIDs) {
                            displayMsg += "<line>";
                            String uriValue = this.URI_Reference_Path + uri_name + "/" + saveId;
                            select = (Element) contextTag.getElementsByTagName("URI_ID").item(0);
                            displayMsg += select.getElementsByTagName(lang).item(0).getTextContent() + ": " + uriValue;
                            displayMsg += "</line>";
                        }
                    }
                }
                Utils.deleteDir(currentDir);
            } catch (Exception ex) {
                ex.printStackTrace();
                displayMsg += Messages.NOT_VALID_IMPORT;
            }

        }
        xml.append("<Display>").append(displayMsg).append("</Display>\n");
        xml.append("<EntityType>").append(type).append("</EntityType>\n");
        xml.append(this.xmlEnd());
        try {
            XMLTransform xmlTrans = new XMLTransform(xml.toString());
            xmlTrans.transform(out, xsl);
        } catch (DMSException e) {
            e.printStackTrace();
        }
        out.close();
    }

    private DiskFileItemFactory setupFileItemFactory(File repository, ServletContext context) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD);
        factory.setRepository(repository);

        FileCleaningTracker pTracker = FileCleanerCleanup.getFileCleaningTracker(context);
        factory.setFileCleaningTracker(pTracker);

        return factory;
    }

    private Document createAdminPart(String fileId, String type, Document doc, String username) {
        //create admin element
        String query = "name(//admin/parent::*)";
        DBFile dbf = new DBFile(this.DBURI, this.systemDbCollection + type, type + ".xml", this.DBuser, this.DBpassword);
        String parentOfAdmin = dbf.queryString(query)[0];
        Element parentElement = (Element) doc.getElementsByTagName(parentOfAdmin).item(0);
        Element admin = doc.createElement("admin");
        parentElement.appendChild(admin);

        //create id element
        String id = fileId.split(type)[1];
        Element idE = doc.createElement("id");
        idE.appendChild(doc.createTextNode(id));
        admin.appendChild(idE);

        //create uri_id element
        String uri_name = "";
        try {
            uri_name = DMSTag.valueOf("uri_name", "target", type, this.conf)[0];
        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        String uriValue = this.URI_Reference_Path + uri_name + "/" + id;
        String uriPath = UtilsXPaths.getPathUriField(type);
        Element uriId = doc.createElement("uri_id");
        uriId.appendChild(doc.createTextNode(uriValue));
        admin.appendChild(uriId);
        if (!uriPath.equals("")) {
            try {
                XPath xPath = XPathFactory.newInstance().newXPath();
                NodeList nodes = (NodeList) xPath.evaluate(uriPath,
                        doc.getDocumentElement(), XPathConstants.NODESET);
                Node oldChild = nodes.item(0);
                if (oldChild != null) {
                    oldChild.setTextContent(uriValue);
                }
            } catch (XPathExpressionException ex) {
                ex.printStackTrace();
            }
        }

        //create lang element
        Element lang = doc.createElement("lang");
        lang.appendChild(doc.createTextNode(this.lang));
        admin.appendChild(lang);

        //create organization element
        Element organization = doc.createElement("organization");
        organization.appendChild(doc.createTextNode(this.getUserGroup(username)));
        admin.appendChild(organization);

        //create creator element
        Element creator = doc.createElement("creator");
        creator.appendChild(doc.createTextNode(username));
        admin.appendChild(creator);

        //create creator element
        Element saved = doc.createElement("saved");
        saved.appendChild(doc.createTextNode("yes"));
        admin.appendChild(saved);

        //create locked element
        Element locked = doc.createElement("locked");
        locked.appendChild(doc.createTextNode("no"));
        admin.appendChild(locked);
        Element status = doc.createElement("status");
        if (GetEntityCategory.getEntityCategory(type).equals("primary")) {
            status.appendChild(doc.createTextNode("unpublished"));
        }
        admin.appendChild(status);

        //create version elemnt
        Element versions = doc.createElement("versions");

        //create versionidr elememt
        Element versionId = doc.createElement("versionId");
        versionId.appendChild(doc.createTextNode("1"));
        versions.appendChild(versionId);

        //create versionUser elememt
        Element versionUser = doc.createElement("versionUser");
        versionUser.appendChild(doc.createTextNode(username));
        versions.appendChild(versionUser);

        //create versionDate elememt
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        Element versionDate = doc.createElement("versionDate");
        versionDate.appendChild(doc.createTextNode(dateFormat.format(date)));
        versions.appendChild(versionDate);

        admin.appendChild(versions);
        //create read element
        Element read = doc.createElement("read");
        read.appendChild(doc.createTextNode(username));
        admin.appendChild(read);

        //create write element
        Element write = doc.createElement("write");
        write.appendChild(doc.createTextNode(username));
        admin.appendChild(write);

        //create status element
        //create imported element
        Element imported = doc.createElement("imported");
        imported.appendChild(doc.createTextNode(username));
        admin.appendChild(imported);

        return doc;
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
