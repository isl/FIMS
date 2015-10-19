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
package isl.FIMS.utils;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.entity.GetEntityCategory;
import isl.FIMS.utils.entity.XMLEntity;
import isl.dbms.DBCollection;
import isl.dbms.DBFile;
import isl.dbms.DBMSException;
import isl.dms.DMSConfig;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletOutputStream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.apache.commons.io.FileUtils;
import static org.apache.poi.hssf.usermodel.HSSFFooter.file;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import utilities.resizer.resize_image;

/**
 *
 * @author konsolak
 */
public class Utils extends ApplicationBasicServlet {

    public static final int PASSWORD_LENGTH = 8;

    //find recursively all dependants of a specific xml file
    public ArrayList<DBFile> findDependats(DBFile dbf, String fileId, String type, String database, String dbUser, String dbPass, String previous_Id, String previous_Type, ArrayList allPrevious) {
        // System.out.println("findDependats " + dbf.getName());
        // System.out.println("--------------------------------");
        ArrayList<DBFile> aList = new <DBFile> ArrayList();
        String[] res = dbf.queryString("//admin/refs/ref[@sps_id!=0 and (@sps_type!='" + type + "' or @sps_id!='" + fileId + "') and (@sps_type!='" + previous_Type + "' or @sps_id!='" + previous_Id + "')]");
        for (int i = 0; i < res.length; i++) {
            Element e = getElement(res[i]);
            String sps_type = e.getAttribute("sps_type");
            String sps_id = e.getAttribute("sps_id");
            String id = sps_type + sps_id;
            if (!allPrevious.contains(id)) {
                DBCollection col = new DBCollection(database, this.systemDbCollection + sps_type, dbUser, dbPass);
                String collectionPath = UtilsQueries.getPathforFile(col, id + ".xml", id.split(sps_type)[1]);
                col = new DBCollection(database, collectionPath, dbUser, dbPass);
                DBFile dependantFile = col.getFile(id + ".xml");
                //      System.out.println("name of file: " + dependantFile.getName());
                //System.out.println(dependantFile.getName());
                allPrevious.add(id);
                aList.add(dependantFile);
                //findDependats(dependantFile);
                aList.addAll(findDependats(dependantFile, sps_id, sps_type, database, dbUser, dbPass, fileId, type, allPrevious));
            }
        }

        //System.out.println("at end "+dbf.getName()+" "+aList.size());
        return aList;
    }

    public static Element getElement(String xmlString) {
        Element e = null;
        try {

            DocumentBuilderFactory dbfac = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = dbfac.newDocumentBuilder();
            Document doc = null;
            try {
                doc = docBuilder.parse(new InputSource(new StringReader(xmlString)));
            } catch (SAXException ex) {
            } catch (IOException ex) {
            }
            e = doc.getDocumentElement();

        } catch (ParserConfigurationException ex) {
        }
        return e;
    }

    //return the set-theoretic difference of coll2 in coll1.
    public static Collection Subtract(Collection coll1, Collection coll2) {
        Collection result = new ArrayList(coll2);
        result.removeAll(coll1);
        return result;
    }

    public static boolean deleteDir(String dirURL) {
        return deleteDir(new File(dirURL));
    }

    public static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i = 0; i < children.length; i++) {
                boolean deleted = deleteDir(new File(dir, children[i]));
                if (!deleted) {
                    return false;
                }
            }
        }
        return dir.delete();
    }

    /////////////////////////////Check Disk Space...mdaskal
    public static boolean checkDiskSpace(String path, long threshold) {
        try {
            long ava = getFreeSpace(path);
            long m = 1024 * 1024;

            //System.out.println( "Available space in path " + path + " is " + ava / m + "Mb" ); //$NON-NLS-1$//$NON-NLS-2$ //$NON-NLS-3$
//                        this.value = new Long( ava / m ).toString();
            if (new Long(ava / m).compareTo(new Long(threshold)) > 0) {
                return true;
            }
        } catch (Exception ex) {
            //	System.out.println( "Error occurred when checking the disk, the path :[" + path //$NON-NLS-1$
            //	+ "] may be incorrect for the current os" ); //$NON-NLS-1$
            ex.printStackTrace();
        }
        return false;

    }

    private static long getFreeSpaceOnLinux(String path) throws Exception {
        long bytesFree = -1;

        Process p = Runtime.getRuntime().exec("df " + "/" + path); //$NON-NLS-1$ //$NON-NLS-2$
        InputStream reader = new BufferedInputStream(p.getInputStream());
        StringBuffer buffer = new StringBuffer();
        for (;;) {
            int c = reader.read();
            if (c == -1) {
                break;
            }
            buffer.append((char) c);
        }
        String outputText = buffer.toString();
        reader.close();

        // parse the output text for the bytes free info
        StringTokenizer tokenizer = new StringTokenizer(outputText, "\n"); //$NON-NLS-1$
        tokenizer.nextToken();
        if (tokenizer.hasMoreTokens()) {
            String line2 = tokenizer.nextToken();
            StringTokenizer tokenizer2 = new StringTokenizer(line2, " "); //$NON-NLS-1$
            if (tokenizer2.countTokens() >= 4) {
                tokenizer2.nextToken();
                tokenizer2.nextToken();
                tokenizer2.nextToken();
                bytesFree = Long.parseLong(tokenizer2.nextToken());
                return bytesFree * 1024;
            }

            return bytesFree * 1024;
        }

        throw new Exception("Can not read the free space of " + path + " path"); //$NON-NLS-1$ //$NON-NLS-2$
    }

    private static long getFreeSpace(String path) throws Exception {
        File Filepath = new File(path);
        if (!Filepath.exists()) {
            Filepath.mkdirs();
        }

        if (System.getProperty("os.name").startsWith("Windows")) //$NON-NLS-1$ //$NON-NLS-2$
        {
            return getFreeSpaceOnWindows(path);
        }
        if (System.getProperty("os.name").startsWith("Linux")) //$NON-NLS-1$ //$NON-NLS-2$
        {
            return getFreeSpaceOnLinux(path);
        }

        throw new UnsupportedOperationException(
                "The method getFreeSpace(String path) has not been implemented for this operating system."); //$NON-NLS-1$

    }

    private static long getFreeSpaceOnWindows(String path) throws Exception {
        long bytesFree = -1;

        File script = new File(System.getProperty("java.io.tmpdir"), //$NON-NLS-1$
                "script.bat"); //$NON-NLS-1$
        PrintWriter writer = new PrintWriter(new FileWriter(script, false));
        writer.println("dir \"" + path + "\""); //$NON-NLS-1$ //$NON-NLS-2$
        writer.close();

        // get the output from running the .bat file
        Process p = Runtime.getRuntime().exec(script.getAbsolutePath());
        InputStream reader = new BufferedInputStream(p.getInputStream());
        StringBuffer buffer = new StringBuffer();
        for (;;) {
            int c = reader.read();
            if (c == -1) {
                break;
            }
            buffer.append((char) c);
        }
        String outputText = buffer.toString();
        reader.close();

        StringTokenizer tokenizer = new StringTokenizer(outputText, "\n"); //$NON-NLS-1$
        String line = null;
        while (tokenizer.hasMoreTokens()) {
            line = tokenizer.nextToken().trim();
            // see if line contains the bytes free information

        }
        tokenizer = new StringTokenizer(line, " "); //$NON-NLS-1$
        tokenizer.nextToken();
        tokenizer.nextToken();
        bytesFree = Long.parseLong(tokenizer.nextToken().replace('.', ',').replaceAll(",", "")); //$NON-NLS-1$//$NON-NLS-2$
        System.out.println("Free Space= " + bytesFree);
        return bytesFree;
    }

    ///////////////copy files and directories
    public static void copy(java.io.File destination, java.io.File source) throws Exception {
        if (source.isDirectory()) {
            if (!destination.isDirectory()) {
                throw new Exception("Destination '" + destination.getName() + "' is not directory.");
            }
            copyDirectory(destination, source);
        } else {
            if (destination.isDirectory()) {
                destination = new java.io.File(destination, source.getName());
            }
            copyFile(destination, source);
        }
    }

    private static void copyDirectory(java.io.File destination, java.io.File source) throws Exception {
        java.io.File[] list = source.listFiles();
        for (int i = 0; i < list.length; i++) {
            java.io.File dest = new java.io.File(destination, list[i].getName());
            if (list[i].isDirectory()) {
                dest.mkdir();
                copyDirectory(dest, list[i]);
            } else {
                if (!list[i].isHidden()) {
                    copyFile(dest, list[i]);
                }
            }
        }
    }

    private static void copyFile(java.io.File destination, java.io.File source) throws Exception {
        try {
            java.io.FileInputStream inStream = new java.io.FileInputStream(source);
            java.io.FileOutputStream outStream = new java.io.FileOutputStream(destination);

            int len;
            byte[] buf = new byte[2048];

            while ((len = inStream.read(buf)) != -1) {
                outStream.write(buf, 0, len);
            }
            // System.out.println("File "+destination.getName()+" copied");
        } catch (Exception e) {
            throw new Exception("Can't copy file " + source + " -> " + destination + ".", e);
        }
    }

    //    added by mdaskal for backup
    public static String GenerateBackupFileName(String user, String time, String date, String prefix, String regex) {
        String name;
        Random random = new Random();
        int randomInt = random.nextInt(100);
        String randomStr = String.valueOf(randomInt);
        name = prefix + regex + user + regex + time + regex + date + regex + randomStr;
        return name;
    }

    public static void downloadZip(ServletOutputStream outStream, File file) {
        DataInputStream in = null;
        int BUFSIZE = 8192;

        try {
            byte[] byteBuffer = new byte[BUFSIZE];
            in = new DataInputStream(new FileInputStream(file));
            int bytesRead;
            while ((bytesRead = in.read(byteBuffer)) != -1) {
                outStream.write(byteBuffer, 0, bytesRead);
            }
            in.close();
            outStream.close();
        } catch (IOException ex) {
        } finally {
            try {
                in.close();
            } catch (IOException ex) {
            }
        }
    }

    public static void createZip(String zipFile, String sourceDirectory) {
        try {
            // String zipFile = "C:/FileIO/zipdemo.zip";
            // String sourceDirectory = "C:/examples";

            //create byte buffer
            byte[] buffer = new byte[1024];
            //create object of FileOutputStream
            FileOutputStream fout = new FileOutputStream(zipFile);
            //create object of ZipOutputStream from FileOutputStream
            ZipOutputStream zout = new ZipOutputStream(fout);
            //create File object from directory name
            File dir = new File(sourceDirectory);

            //check to see if this directory exists
            if (!dir.isDirectory()) {
            } else {
                File[] files = dir.listFiles();
                for (int i = 0; i < files.length; i++) {
                    if (files[i].isFile()) {
                        //create object of FileInputStream for source file
                        FileInputStream fin = new FileInputStream(files[i]);
                        zout.putNextEntry(new ZipEntry(files[i].getName()));
                        int length;
                        while ((length = fin.read(buffer)) > 0) {
                            zout.write(buffer, 0, length);
                        }
                        zout.closeEntry();
                        //close the InputStream
                        fin.close();
                    }
                }
            }

            //close the ZipOutputStream
            zout.close();
        } catch (IOException ioe) {
            System.out.println("IOException :" + ioe);
        }
    }

    /**
     * Unzip it (This implementation works only when zip contains files-folders
     * with ASCII filenames Greek characters break the code!
     *
     * @param zipFile input zip file
     * @param output zip file output folder
     */
    public static void unzip(String zipFile, String outputFolder) {

        String rootFolderName = "";
        String rootFlashFilename = "";
        byte[] buffer = new byte[1024];

        try {

            //get the zip file content
            ZipInputStream zis
                    = new ZipInputStream(new FileInputStream(outputFolder + File.separator + zipFile));
            //get the zipped file list entry

            ZipEntry ze = zis.getNextEntry();

            boolean rootDirFound = false;
            boolean flashFileFound = false;
            while (ze != null) {

                String fileName = ze.getName();
                File newFile = new File(outputFolder + File.separator + fileName);
                //create all non exists folders
                //else you will hit FileNotFoundException for compressed folder
                if (!ze.getName().contains("__MACOSX")) {
                    if (ze.isDirectory()) {
//                        System.out.println("ROOTDIR=" + rootDirFound);
                        if (rootDirFound == false) {
                            rootFolderName = newFile.getName();
                            rootDirFound = true;
                        }
                        new File(newFile.getParent()).mkdirs();
                    } else {
                        FileOutputStream fos = null;

                        new File(newFile.getParent()).mkdirs();

                        if (flashFileFound == false && newFile.getName().endsWith(".swf") && !newFile.getName().startsWith(".")) {
                            rootFlashFilename = newFile.getName();
                            flashFileFound = true;
                        }

                        fos = new FileOutputStream(newFile);

                        int len;
                        while ((len = zis.read(buffer)) > 0) {
                            fos.write(buffer, 0, len);
                        }

                        fos.close();
                    }
                }
                ze = zis.getNextEntry();
            }

            zis.closeEntry();
            zis.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static ArrayList readFile(File f) {
        ArrayList content = new ArrayList();
        try {
            // Open the file that is the first 
            // command line parameter
            FileInputStream fstream = new FileInputStream(f);
            // Get the object of DataInputStream
            DataInputStream in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            //Read File Line By Line
            while ((strLine = br.readLine()) != null) {
                // Print the content on the console
                content.add(strLine.trim());
            }
            //Close the input stream
            in.close();
        } catch (Exception e) {//Catch exception if any
            System.err.println("Error: " + e.getMessage());
        }
        return content;
    }

    public static String generateRandomPassword() {
        // Pick from some letters that won't be easily mistaken for each
        // other. So, for example, omit o O and 0, 1 l and L.
        String letters = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789+@";

        String pw = "";
        for (int i = 0; i < PASSWORD_LENGTH; i++) {
            Random r = new Random();

            int index = (int) (r.nextDouble() * letters.length());
            pw += letters.substring(index, index + 1);
        }
        return pw;
    }

    public static boolean sendEmail(String to, String subject, String context) {
        boolean isSend = false;

        try {

            String host = "smtp.gmail.com";
            String user = emailAdress;
            String password = emailPass;

            String port = "587";
            String from = "no-reply-" + systemName + "@gmail.com";
            Properties props = System.getProperties();

            props.put("mail.smtp.user", user);
            props.put("mail.smtp.password", password);
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            //  props.put("mail.debug", "true");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.EnableSSL.enable", "true");
            //     props.put("mail.smtp.socketFactory.port", port);
            //    props.put("mail.smtp.socketFactory.class",
            //            "javax.net.ssl.SSLSocketFactory");
            //    props.put("mail.smtp.port", "465");

            Session session = Session.getInstance(props, null);
            //session.setDebug(true);

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));

            // To get the array of addresses
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            message.setSubject(subject, "UTF-8");
            message.setContent(context, "text/html; charset=UTF-8");
            Transport transport = session.getTransport("smtp");
            try {
                transport.connect(host, user, password);
                transport.sendMessage(message, message.getAllRecipients());
            } finally {
                transport.close();
            }
            isSend = true;
        } catch (MessagingException ex) {
            ex.printStackTrace();
        }
        return isSend;

    }

    public static void updateReferences(XMLEntity xmlE, String database, String xmlId, String xmlType, String dbPass, String dbUser) {

        /*String[] references = xmlE.queryString("//*[not (self::ref or self::ref_by) and @sps_type!='' and @sps_id!='' and @sps_id!='0']");
         * exist2.2 error with "no"
         */
        String[] references = xmlE.queryString("//*[name(.)!= 'ref' and name(.)!='ref_by'  and @sps_type!='' and @sps_id!='' and @sps_id!='0']");

        String[] oldRerences = xmlE.queryString("//admin/refs/ref");
        xmlE.setAdminProperty("refs", "");
        Set<String> afterEditingList = new HashSet();
        Set<String> beforeEditingList = new HashSet();
        for (int i = 0; i < oldRerences.length; i++) {
            Element e = Utils.getElement(oldRerences[i]);
            String sps_type = e.getAttribute("sps_type");
            String sps_id = e.getAttribute("sps_id");
            //h katw pavla xrhsimopoieitai gia na mporesume sth sunexeia na spasume to string
            beforeEditingList.add(sps_type + "_" + sps_id);
        }

        for (String reference : references) {
            Element e = Utils.getElement(reference);
            String sps_type = e.getAttribute("sps_type");
            String sps_id = e.getAttribute("sps_id");
            if (!afterEditingList.contains(sps_type + "_" + sps_id)) {
                xmlE.xAppend("//admin/refs", "<ref sps_id='" + sps_id + "' sps_type='" + sps_type + "'/>");

                try {
                    XMLEntity refxml = new XMLEntity(database, ApplicationBasicServlet.systemDbCollection + sps_type, dbUser, dbPass, sps_type, sps_type + sps_id);

                    String[] existingRefs_by = refxml.queryString("//admin/refs_by");
                    if (existingRefs_by.length == 0) {
                        refxml.setAdminProperty("refs_by", "");
                    }
                    String property = "";
                    if (GetEntityCategory.getEntityCategory(xmlType).equals("primary")) {
                        property = "<ref_by sps_id='" + xmlId + "' sps_type='" + xmlType + "' isUnpublished='true'/>";
                    } else {
                        property = "<ref_by sps_id='" + xmlId + "' sps_type='" + xmlType + "'/>";
                    }

                    if (!refxml.exist("//admin/refs_by/ref_by[@sps_id='" + xmlId + "' and @sps_type='" + xmlType + "']")) {
                        refxml.xAppend("//admin/refs_by", property);
                    }
                    existingRefs_by = refxml.queryString("//admin/refs_by/ref_by");
                } catch (DBMSException ex) {
                }

            }
            afterEditingList.add(sps_type + "_" + sps_id);
        }
        Collection notUsedReferences = Utils.Subtract(afterEditingList, beforeEditingList);
        Iterator<String> it = notUsedReferences.iterator();
        //removes references that are not used anymore
        while (it.hasNext()) {
            String removeRef = it.next();
            String removeType = removeRef.split("_")[0];
            String removeId = removeRef.split("_")[1];
            XMLEntity removeXml = new XMLEntity(database, ApplicationBasicServlet.systemDbCollection + removeType, dbUser, dbPass, removeType, removeType + removeId);
            removeXml.xRemove("//admin/refs_by/ref_by[@sps_type='" + xmlType + "' and @sps_id='" + xmlId + "' ]");
        }
    }

    public static void updateVocabularies(XMLEntity xmlE, String database, String xmlId, String xmlType, String dbPass, String dbUser, String lang) {
        String[] vocsToCheck = xmlE.queryString("//*[@sps_vocabulary!='' and @sps_id!='' and ./text()!='']");
        for (String vocTag : vocsToCheck) {
            Element e = Utils.getElement(vocTag);
            String sps_vocabulary = e.getAttribute("sps_vocabulary");
            String sps_id = e.getAttribute("sps_id");
            String text = e.getTextContent();
            DMSConfig vocConf = new DMSConfig(Utils.DBURI, Utils.systemDbCollection + "Vocabulary/", Utils.DBuser, Utils.DBpassword);
            Vocabulary voc = new Vocabulary(sps_vocabulary, lang, vocConf);
            String[] terms = voc.termValues();
            String addTerm = text;
            if (!Arrays.asList(terms).contains(addTerm)) {
                int id = voc.addTerm(addTerm);
                if (text.contains("'")) {
                    xmlE.xUpdate("//*[@sps_vocabulary='" + sps_vocabulary + "'and ./text()=\"" + text + "\" ]/@sps_id", String.valueOf(id));

                } else {
                    xmlE.xUpdate("//*[@sps_vocabulary='" + sps_vocabulary + "'and ./text()='" + text + "' ]/@sps_id", String.valueOf(id));

                }

            }
        }
    }

    public static Node removeNode(Node root, String elementName, boolean deep) {
        if (!(root.hasChildNodes())) {
            return null;
        }

        Node matchingNode = null;
        String nodeName = null;
        Node child = null;

        NodeList childNodes = root.getChildNodes();
        int noChildren = childNodes.getLength();
        for (int i = 0; i < noChildren; i++) {
            if (matchingNode == null) {
                child = childNodes.item(i);
                nodeName = child.getNodeName();
                if ((nodeName != null) & (nodeName.equals(elementName))) {
                    root.removeChild(child);
                    return child;
                }
                if (deep) {
                    matchingNode
                            = removeNode(child, elementName, deep);
                }
            } else {
                break;
            }
        }

        return matchingNode;
    }

    public static ArrayList<String> checkReference(XMLEntity xmlE, String database, String xmlId, String xmlType, String dbUser, String dbPass) {
        ArrayList<String> missingFiles = new <String> ArrayList();
        String[] references = xmlE.queryString("//*[name(.)!= 'ref' and name(.)!='ref_by'  and @sps_type!='' and @sps_id!='' and @sps_id!='0']");
        String[] oldRerences = xmlE.queryString("//admin/refs/ref");
        Set<String> afterEditingList = new HashSet();
        Set<String> beforeEditingList = new HashSet();
        for (int i = 0; i < oldRerences.length; i++) {
            Element e = Utils.getElement(oldRerences[i]);
            String sps_type = e.getAttribute("sps_type");
            String sps_id = e.getAttribute("sps_id");
            //h katw pavla xrhsimopoieitai gia na mporesume sth sunexeia na spasume to string
            beforeEditingList.add(sps_type + "_" + sps_id);
        }
        for (int i = 0; i < references.length; i++) {
            Element e = Utils.getElement(references[i]);
            String sps_type = e.getAttribute("sps_type");
            String sps_id = e.getAttribute("sps_id");
            if (!afterEditingList.contains(sps_type + "_" + sps_id)) {
                String refCollection = "";
                try {
                    refCollection = UtilsQueries.getpath(database, ApplicationBasicServlet.systemDbCollection + sps_type, dbUser, dbPass, sps_type, sps_id);
                    DBFile refxml = new DBFile(database, refCollection, sps_type + sps_id + ".xml", dbUser, dbPass);
                } catch (Exception ex) {
                    missingFiles.add(sps_type + "/" + sps_id);
                }
            }
            afterEditingList.add(sps_type + "_" + sps_id);

        }
        //  System.out.println("Subtract result");
        Collection notUsedReferences = Utils.Subtract(afterEditingList, beforeEditingList);
        Iterator<String> it = notUsedReferences.iterator();
        //removes references that are not used anymore
        while (it.hasNext()) {
            String removeRef = it.next();
            String removeType = removeRef.split("_")[0];
            String removeId = removeRef.split("_")[1];
            String removeCollection = "";
            try {
                removeCollection = UtilsQueries.getpath(database, ApplicationBasicServlet.systemDbCollection + removeType, dbUser, dbPass, removeType, removeId);
                DBFile removeXml = new DBFile(database, removeCollection, removeType + removeId + ".xml", dbUser, dbPass);
            } catch (Exception e) {
                missingFiles.add(removeType + "/" + removeId);
            }
        }
        return missingFiles;
    }

    public static String removeExtension(String s) {

        String separator = System.getProperty("file.separator");
        String filename;

        // Remove the path upto the filename.
        int lastSeparatorIndex = s.lastIndexOf(separator);
        if (lastSeparatorIndex == -1) {
            filename = s;
        } else {
            filename = s.substring(lastSeparatorIndex + 1);
        }

        // Remove the extension.
        int extensionIndex = filename.lastIndexOf(".");
        if (extensionIndex == -1) {
            return filename;
        }

        return filename.substring(0, extensionIndex);
    }

    public static String getDate() {

        Calendar cal = new GregorianCalendar(Locale.getDefault());
        DecimalFormat myformat = new DecimalFormat("00");

        // Get the components of the date
        // int era = cal.get(Calendar.ERA);               // 0=BC, 1=AD
        int year = cal.get(Calendar.YEAR);             // 2002
        int month = cal.get(Calendar.MONTH) + 1;           // 0=Jan, 1=Feb, ...
        int day = cal.get(Calendar.DAY_OF_MONTH);      // 1...

        //   int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1=Sunday, 2=Monday
        return myformat.format(day) + "-" + myformat.format(month) + "-" + year;
    }

    /**
     * Time method
     *
     * @return Current time as <CODE>String</CODE> in hh:mm:ss format
     */
    public static String getTime() {
        Calendar cal = new GregorianCalendar(Locale.getDefault());

        // Get the components of the time
        //    int hour12 = cal.get(Calendar.HOUR);            // 0..11
        // Create the DecimalFormat object only one time.
        DecimalFormat myformat = new DecimalFormat("00");

        int hour24 = cal.get(Calendar.HOUR_OF_DAY);     // 0..23
        int min = cal.get(Calendar.MINUTE);             // 0..59
        int sec = cal.get(Calendar.SECOND);             // 0..59
        return myformat.format(hour24) + myformat.format(min) + myformat.format(sec);
//        return new String(myformat.format(hour24)+":"+myformat.format(min)+":"+myformat.format(sec));
    }

    public static String createUniqueFilename(String filename) {

        //Create a pseudorandom number
        long randomNumber = Math.round(Math.random() * 14000);
        String datestamp = Utils.getDate();
        String timestamp = Utils.getTime();

        String justName = filename.substring(0, filename.lastIndexOf('.'));
        String fileExtension = filename.substring(filename.lastIndexOf('.') + 1);

        //And use all of the above parts to create a unique random file name
        //var uniquename = results[0] + timestamp + datestamp + random +"." + results[1];
        String uniquename = justName + "___" + datestamp + timestamp + "___" + randomNumber + "." + fileExtension;

        return uniquename;
    }

    public static String findMime(DBFile uploads, String file, String use) {

        file = file.substring(file.lastIndexOf(".") + 1);
        file = file.toLowerCase();
        //System.out.println("//mime[type='"+file+"']/../name()");

        String[] mimes = uploads.queryString("//mime[type='" + file + "']/../name()");
        if (mimes.length == 0) {
            return "Other";
        } else {
            if (mimes.length > 1) {
                String mime = uploads.queryString("//mime[type/@use ='"+use+"' and type='" + file + "']/../name()")[0];
                return mime;
            } else {
                return mimes[0];
            }
        }

    }

    public static boolean resizeImage(String file, String sourceFolder, String destinationFolder, int pixels) {

        resize_image img = new resize_image();
        if (!new File(sourceFolder).exists()) {
            new File(sourceFolder).mkdirs();
        }
        if (!new File(destinationFolder).exists()) {
            new File(destinationFolder).mkdirs();
        }
        img.set_dir_location(sourceFolder, destinationFolder);
        img.set_width_or_height(pixels, img.HEIGHT);
        return img.resize_imageFile(file);
    }

    public static void copySchemaReferences(String schemaPath, String destination) {
        Document contents = ParseXMLFile.parseFile(schemaPath);
        String prefix = contents.getDocumentElement().getTagName().split(":")[0];
        NodeList includes = contents.getElementsByTagName(prefix + ":include");
        for (int i = 0; i < includes.getLength(); i++) {
            try {
                Node include = includes.item(i);
                String schemaLocation = include.getAttributes().getNamedItem("schemaLocation").getNodeValue();
                if (schemaLocation != "") {
                    File schemaFile = new File(Utils.schemaFolder + schemaLocation);
                    FileUtils.copyFile(schemaFile, new File(destination + System.getProperty("file.separator") + schemaLocation));
                    copySchemaReferences(schemaFile.getAbsolutePath(), destination);
                }
            } catch (IOException ex) {
            }

        }

    }

}
