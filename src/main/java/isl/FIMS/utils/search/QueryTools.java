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
package isl.FIMS.utils.search;

import timeprimitve.SISdate;
import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.UtilsQueries;
import isl.FIMS.utils.UtilsXPaths;
import isl.FIMS.utils.Vocabulary;
import isl.dbms.DBFile;
import isl.dbms.DBMSException;
import isl.dms.DMSConfig;
import isl.dms.DMSException;
import isl.dms.file.DMSTag;
import isl.dms.file.DMSUser;
import isl.dms.file.DMSXQuery;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import schemareader.Element;
import schemareader.SchemaFile;

public class QueryTools {

    //Returns the query for the results of search (simple r advanced)
    public static String getQueryForSearchResults(Hashtable params, DMSConfig conf, String dataCol) throws DMSException {
        String[] targets = (String[]) params.get("targets");
        String operator = (String) params.get("operator");
        String[] inputs = (String[]) params.get("inputs");
        String[] inputsOpers = (String[]) params.get("inputsOpers");
        String[] inputsValues = (String[]) params.get("inputsValues");
        String[] outputs = (String[]) params.get("outputs");
        String code = (String) params.get("code");
        String category = (String) params.get("category");
        String lang = (String) params.get("lang");
        String status = (String) params.get("status");
        String username = (String) params.get("username");
        String organization = (String) params.get("organization");
        String mode = "";
        String rootXPath = "";
        try {
            rootXPath = DMSTag.valueOf("rootxpath", "target", category, conf)[0];
        } catch (DBMSException e) {
        }

        if (userHasAction("sysadmin", username, conf)) {
            mode = "sys";
        }
        if (status.equals("null")) {
            status = null;
        }
        StringBuffer queryEnd = new StringBuffer("return\n<result pos='{$j}'>\n");
        if (outputs.length == 0) {
            outputs = UtilsXPaths.getOutputResultForSimpleSearch(category);
            for (String output : outputs) {
                String[] outs = output.split("/");
                String outTag = outs[outs.length - 1];
                queryEnd.append("<").append(outTag).append(">\n").append("{$current").append(output).append("}\n").append("</").append(outTag).append(">\n");
            }
            try {
                outputs = DMSTag.valueOf("xpath", "listOutputExternal", category, conf);
            } catch (DMSException ex) {
            }
            for (String output : outputs) {
                String[] outs = output.split("/");
                String outTag = outs[outs.length - 1];
                queryEnd.append("<").append(outTag).append(">\n").append("{").append(output).append("}\n").append("</").append(outTag).append(">\n");
            }
        } else {
            for (String output : outputs) {
                if (output != null) {
                    String[] outs = output.split("/");
                    String outTag = outs[outs.length - 1];
                    String tmp = outs[1];
                    if (tmp.equals(category)) {
                        queryEnd.append("<" + outTag + ">\n").append("{$current").append(output).append("}\n").append("</" + outTag + ">\n");
                    } else {
                        queryEnd.append("<" + outTag + ">\n").append("{").append(output).append("}\n").append("</" + outTag + ">\n");
                    }
                }
            }
        }

        String[] adminPartsTitle;
        String[] adminPartsPath;
        try {
            adminPartsTitle = DMSTag.valueOf("tagname", "adminOutput", category, conf);
            adminPartsPath = DMSTag.valueOf("xpath", "adminOutput", category, conf);

            for (int i = 0; i < adminPartsTitle.length; i++) {
                if (adminPartsTitle[i].equals("AdminOrganization")) {
                    queryEnd.append("<" + adminPartsTitle[i] + "><" + adminPartsTitle[i] + ">\n{string(doc('" + ApplicationBasicServlet.adminDbCollection + ApplicationBasicServlet.conf.GROUPS_FILE + "')//group[@id=$current/" + rootXPath + adminPartsPath[i] + "]/@groupname)}\n</" + adminPartsTitle[i] + "></" + adminPartsTitle[i] + ">\n");
                } else {
                    queryEnd.append("<" + adminPartsTitle[i] + ">\n{$current/" + rootXPath + adminPartsPath[i] + "}\n</" + adminPartsTitle[i] + ">\n");

                }
            }
        } catch (DMSException ex) {
        } catch (DBMSException ex) {
        }

        StringBuffer inQuerySource = new StringBuffer();
        inQuerySource.append("return $i\n").append("return\n").append("<stats>\n").append("{for $j in 1 to count($results)\n").append("let $current := $results[$j]\n").append("let $i := $results[$j]\n");
        StringBuffer queryTargets = new StringBuffer();
        StringBuffer queryWhere = new StringBuffer();
        UtilsQueries u = new UtilsQueries();
        queryWhere = u.getQueryConditionsForSearch(queryWhere, params, mode, username, lang);
        for (String target : targets) {
            queryTargets.append(target).append(",");
        }

        try {
            queryTargets.delete(queryTargets.lastIndexOf(","), queryTargets.length());
        } catch (StringIndexOutOfBoundsException se) {
        }

        StringBuffer queryMiddle = new StringBuffer();

        for (int i = 0; i < inputs.length; i++) {
            inputsValues[i] = inputsValues[i].replaceAll("'", "");
            inputsValues[i] = inputsValues[i].replaceAll("\"", "");
            inputsValues[i] = inputsValues[i].replaceAll("&", "");
            queryMiddle.append(getPredicate(inputs[i], inputsOpers[i], inputsValues[i])).append(operator).append("\n");
        }
        try {
            queryMiddle.delete(queryMiddle.lastIndexOf(operator), queryMiddle.length());
        } catch (StringIndexOutOfBoundsException se) {
        }

        if (queryMiddle.length() > 0) {
            queryWhere.append(" and (\n").append(queryMiddle).append("\n)\n");
        }
        queryMiddle = queryWhere;

        queryMiddle.append(inQuerySource);

        queryEnd.append("<info>\n{$current/").append(rootXPath).append("/admin/info}\n</info>\n");
        queryEnd.append("<FileId>{replace(util:document-name($current),\".xml\",\"\")}</FileId>\n");
        queryEnd.append("<hiddenResults>");
        queryEnd.append("<FileId>{replace(util:document-name($current),\".xml\",\"\")}</FileId>\n");
        queryEnd.append("{$current/").append(rootXPath).append("/admin/organization}\n");
        queryEnd.append("<hasPublicDependants>{exists($current/").append(rootXPath).append("/admin/refs_by/ref_by[./@isUnpublished='false'])}\n</hasPublicDependants>");
        queryEnd.append("<userHasWrite>{$current/").append(rootXPath).append("/admin/write/text()='").append(username).append("'}\n</userHasWrite>");
        queryEnd.append("<isImported>{exists($current/").append(rootXPath).append("/admin/imported)}\n</isImported>");
        queryEnd.append("<versionId>{$current/").append(rootXPath).append("/admin/versions/versionId/text()}\n</versionId>");
        queryEnd.append("<type>{$current/").append(rootXPath).append("/admin/type}</type>\n");
        queryEnd.append("</hiddenResults>");
        queryEnd.append("<filename><filename>{fn:tokenize($current/").append(rootXPath).append("/admin/uri_id/text(),'").append(ApplicationBasicServlet.URI_Reference_Path).append("')[last()]}</filename></filename>\n");

        queryEnd.append("</result>}</stats>");

        StringBuffer query = new StringBuffer("let $collections:=\n");
        query.append("let $b:= xmldb:get-child-collections('").append(queryTargets).append("')");
        query.append("return count($b),");
        query.append("$collcount:=$collections+").append(dataCol).append(",");
        query.append("$results:=\n");
        query.append("for $m in ").append(dataCol).append(" to  $collcount\n");
        query.append("return\n");
        query.append("for $i in collection(concat('").append(queryTargets).append("/',$m))");

        query.append("let $id := $i//admin/id\n");

        if (queryMiddle.length() > 0) {
            query.append("where ").append(queryMiddle).append(queryEnd);
        } else {
            query.append(queryEnd);
        }
        return query.toString();
    }

    //Builds XML representing query (XQueries-like format)
    public static String getXML4ResultXsl(Hashtable params, DMSConfig conf, String dataCol) throws DMSException {
        String qId = (String) params.get("qId");
        String category = (String) params.get("category");
        String lang = (String) params.get("lang");
        String status = (String) params.get("status");
        String mnemonicName = (String) params.get("mnemonicName");
        String[] targets = (String[]) params.get("targets");
        String operator = (String) params.get("operator");
        String[] inputs = (String[]) params.get("inputs");
        String[] inputsIds = (String[]) params.get("inputsIds");
//        String[] inputsParameters = (String[]) params.get("inputsParameters");
        String[] inputsValues = (String[]) params.get("inputsValues");
        String[] outputs = (String[]) params.get("outputs");

        String[] inputsOpers = (String[]) params.get("inputsOpers");

        String[] tagXPaths = DMSTag.valueOf("xpath", "target", category, conf);
        String[] tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "target", category, conf);

        java.util.Arrays.sort(targets);
        StringBuffer targetsTag = new StringBuffer("<targets>\n");
        for (int i = 0; i < tagXPaths.length; i++) {
            String xPath = tagXPaths[i];
            targetsTag.append("<path xpath=\"").append(xPath).append("\"");
            if (java.util.Arrays.binarySearch(targets, xPath) >= 0) {
                targetsTag.append(" selected=\"yes\">");
            } else {
                targetsTag.append(" selected=\"no\">");
            }
            targetsTag.append(tagDisplayNames[i]).append("</path>\n");
        }
        targetsTag.append("</targets>\n");

        ArrayList[] all = getListOfTags(category, lang);
        ArrayList<String> xpaths = all[0];

        StringBuffer selectedTags = getSelectedTags(inputs, xpaths);

        StringBuffer xpathsTags = new StringBuffer("<xpaths>\n");
        xpathsTags.append(all[0]);
        xpathsTags.append("</xpaths>\n");

        StringBuffer labelsTags = new StringBuffer("<labels>\n");
        labelsTags.append(all[1]);
        labelsTags.append("</labels>\n");

        StringBuffer dataTypesTags = new StringBuffer("<dataTypes>\n");
        dataTypesTags.append(all[2]);
        dataTypesTags.append("</dataTypes>\n");

        String[] inputLabels = (String[]) params.get("inputLabels");

        StringBuffer vocTags = new StringBuffer("<vocTags>\n");
//        for (int i = 0; i < all[4].size(); i++) {
//            String[] terms = (String[]) all[4].get(i);
//            vocTags.append("<vocabulary>\n");
//            for (String t : terms) {
//
//                vocTags.append("***").append(t.trim()).append("***");
//            }
//            vocTags.append("</vocabulary>\n");
//        }
        vocTags.append(all[4]);
        vocTags.append("</vocTags>\n");

        StringBuffer input = new StringBuffer("");

        int i = 0;

        for (String t : inputs) {
            input.append("<input>\n");

            input.append("<selectedXapths>\n");
            input.append(t.trim());
            input.append("</selectedXapths>\n");
            input.append("<value>");
            input.append(inputsValues[i].trim());
            input.append("</value>\n");
            input.append("<oper>").append(inputsOpers[i]);
            input.append("</oper>\n");
            if (inputLabels.length > 0) {
                input.append("<inputLabel>\n").append(inputLabels[i]);
                input.append("</inputLabel>\n");
            }
            i++;
            input.append("</input>\n");

        }

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");

        inputsTag.append(xpathsTags);
        inputsTag.append(labelsTags);
        inputsTag.append(dataTypesTags);
        inputsTag.append(selectedTags);
        inputsTag.append(vocTags);
        inputsTag.append(input);

        inputsTag.append("</inputs>\n");

        StringBuffer outputsTag = new StringBuffer("<outputs>\n");

        if (outputs.length != 0) {//           
            String[] labelsOutput = (String[]) params.get("labelsOutput");
            for (i = 0; i < outputs.length; i++) {
                outputsTag.append("<path xpath=\"").append(outputs[i]).append("\">");
                if (labelsOutput.length > 0) {
                    outputsTag.append(labelsOutput[i]);
                }
                outputsTag.append("</path>\n");
            }
        } else {
            String[] outputsTitle = UtilsXPaths.getOutpuTitleForSimpleSearch(category);
            for (String outputsTitle1 : outputsTitle) {
                outputsTag.append("<path xpath=\"").append("").append("\">");
                outputsTag.append(outputsTitle1).append("</path>\n");
            }
            outputsTitle = DMSTag.valueOf("tagname", "listOutputExternal", category, conf);
            for (String outputsTitle1 : outputsTitle) {
                outputsTag.append("<path xpath=\"").append("").append("\"");
                outputsTag.append(" selected=\"yes\">");
                outputsTag.append(outputsTitle1).append("</path>\n");
            }
        }

        outputsTag.append("</outputs>\n");
        outputsTag.append("<adminParts>\n");
        String[] adminPartsTitle = DMSTag.valueOf("tagname", "adminOutput", category, conf);
        for (String title : adminPartsTitle) {

            outputsTag.append("<title>").append(title).append("</title>\n");
        }
        outputsTag.append("</adminParts>");
        StringBuffer infoTag = new StringBuffer("<info>\n");
        infoTag.append("<name>" + mnemonicName + "</name>\n");
        infoTag.append("<category>" + category + "</category>\n");
        infoTag.append("<lang>" + lang + "</lang>\n");
        infoTag.append("<status>" + status + "</status>\n");
        infoTag.append("<operator>" + operator + "</operator>\n");
        infoTag.append("</info>\n");

        int queryId = (qId.length() > 0) ? Integer.parseInt(qId) : 0;
        StringBuffer ret = buildXML(queryId, category, infoTag, targetsTag, inputsTag, outputsTag);
        return ret.toString();
    }

    public static String getXML4SavedQuery(DMSXQuery query, DMSConfig conf) throws DMSException {
        String category = query.getInfo("category");
        String status = query.getInfo("status");

        int[] qInputs = query.getInputs();

        String[] tagXPaths = DMSTag.valueOf("xpath", "target", category, conf);
        String[] tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "target", category, conf);

        StringBuffer targetsTag = new StringBuffer("<targets>\n");
        for (int i = 0; i < tagXPaths.length; i++) {
            targetsTag.append("<path xpath=\"").append(tagXPaths[i]).append("\"");;
            if (query.hasTarget(tagXPaths[i])) {
                targetsTag.append(" selected=\"yes\">");
            } else {
                targetsTag.append(" selected=\"no\">");
            }
            targetsTag.append(tagDisplayNames[i]).append("</path>\n");
        }
        targetsTag.append("</targets>\n");

        ArrayList[] all = getListOfTags(category, conf.LANG);
        ArrayList<String> xpaths = all[0];

        StringBuffer xpathsTags = new StringBuffer("<xpaths>\n");
        xpathsTags.append(all[0]);
        xpathsTags.append("</xpaths>\n");

        StringBuffer labelsTags = new StringBuffer("<labels>\n");
        labelsTags.append(all[1]);
        labelsTags.append("</labels>\n");

        StringBuffer dataTypesTags = new StringBuffer("<dataTypes>\n");
        dataTypesTags.append(all[2]);
        dataTypesTags.append("</dataTypes>\n");

        StringBuffer vocTags = new StringBuffer("<vocTags>\n");
//        for (int i = 0; i < all[4].size(); i++) {
//            String[] terms = (String[]) all[4].get(i);
//            vocTags.append("<vocabulary>\n");
//            for (String t : terms) {
//
//                vocTags.append("***").append(t.trim()).append("***");
//            }
//            vocTags.append("</vocabulary>\n");
//        }
        vocTags.append(all[4]);
        vocTags.append("</vocTags>\n");

        StringBuffer input = new StringBuffer("");
        ArrayList<String> inputs = new ArrayList();

        for (int i = 0; i < qInputs.length; i++) {
            int inId = qInputs[i];
            String xpath = query.getFromInput(inId, "path");
            String value = query.getFromInput(inId, "value");
            String oper = query.getFromInput(inId, "oper");
            String label = query.getFromInput(inId, "inputLabels");

            inputs.add(xpath);
            input.append("<input>\n");

            input.append("<selectedXapths>\n");
            input.append(xpath);
            input.append("</selectedXapths>\n");
            input.append("<value>\n");
            input.append(value);
            input.append("</value>\n");
            input.append("<oper>\n").append(oper);
            input.append("</oper>\n");
            input.append("<inputLabel>\n").append(label);
            input.append("</inputLabel>\n");
            input.append("</input>\n");

        }
        StringBuffer selectedTags = getSelectedTags(inputs.toArray(new String[inputs.size()]), xpaths);

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");

        inputsTag.append(xpathsTags);
        inputsTag.append(labelsTags);
        inputsTag.append(dataTypesTags);
        inputsTag.append(selectedTags);
        inputsTag.append(vocTags);
        inputsTag.append(input);

        inputsTag.append("</inputs>\n");

        StringBuffer outputsTag = new StringBuffer("<outputs>\n");
        String[] outputs = query.getOutputs();

        for (int i = 0; i < outputs.length; i++) {
            String path = outputs[i].split("--")[0];
            String label = outputs[i].split("--")[1];

            outputsTag.append("<path xpath=\"").append(path).append("\">");
            outputsTag.append(label);
            outputsTag.append("</path>\n");
        }

        outputsTag.append("</outputs>\n");

        StringBuffer infoTag = new StringBuffer("<info>\n");
        infoTag.append("<name>").append(query.getInfo("name")).append("</name>\n");
        infoTag.append("<category>").append(category).append("</category>\n");
        infoTag.append("<lang>").append(conf.LANG).append("</lang>\n");
        infoTag.append("<status>").append(status).append("</status>\n");
        infoTag.append("<operator>").append(query.getInfo("operator")).append("</operator>\n");
        infoTag.append("</info>\n");
        StringBuffer ret = buildXML(query.getId(), category, infoTag, targetsTag, inputsTag, outputsTag);
        return ret.toString();
    }

    public static String xml4InitialSearch(String category, String lang, String status, DMSConfig conf) throws DMSException {
        StringBuffer infoTag = new StringBuffer("<info>\n");
        infoTag.append("<operator>and</operator>\n");
        infoTag.append("<category>").append(category).append("</category>\n");
        infoTag.append("<lang>").append(lang).append("</lang>\n");
        infoTag.append("<status>" + status + "</status>\n");
        infoTag.append("<name></name>\n");
        infoTag.append("</info>\n");

        String[] tagXPaths = DMSTag.valueOf("xpath", "target", category, conf);
        String[] tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "target", category, conf);

        StringBuffer targetsTag = new StringBuffer("<targets>\n");
        for (int i = 0; i < tagXPaths.length; i++) {
            targetsTag.append("<path xpath=\"").append(tagXPaths[i]).append("\"");;
            targetsTag.append(" selected=\"yes\">");
            targetsTag.append(tagDisplayNames[i]).append("</path>\n");
        }
        targetsTag.append("</targets>\n");

        StringBuffer inputsTag = getLaAndLiTags(category, lang);
        StringBuffer ret = buildXML(0, category, infoTag, targetsTag, inputsTag, new StringBuffer(""));
        return ret.toString();
    }

    private static StringBuffer buildXML(int qId, String category, StringBuffer infoTag, StringBuffer targetsTag, StringBuffer inputsTag, StringBuffer outputsTag) {
        StringBuffer ret = new StringBuffer("<query id=\"" + qId + "\">\n");
        ret.append(infoTag).append(targetsTag).append(inputsTag).append(outputsTag);
        ret.append("\n</query>\n");
        ret.append("<LeftMenuId>").append("search" + category).append("</LeftMenuId>");
        ret.append("<EntityType>").append(category).append("</EntityType>\n");
        return ret;
    }

    private static String getPredicate(String input, String oper, String value) {

        // perform a case-insensitive match
        if (oper.equals("matches")) {
            return " matches($i" + input + ", \'" + value + "\', \'i\') ";
        }

        // assume operators like: =, !=, etc.
        // for support for '<' or '>', we replace '&lt;' and '&gt;'
        oper = oper.replaceAll("&gt;", ">");
        oper = oper.replaceAll("&lt;", "<");
        if (oper.length() <= 2) {
            return " ($i" + input + oper + "\'" + value + "\') ";
        }

        //TIME-HANDLING 
        if (oper.startsWith("time")) {
            SISdate sisTime = new SISdate(value);

            String from = Integer.toString(sisTime.getFrom());
            String to = Integer.toString(sisTime.getTo());

            String newOper = "";
            if (oper.endsWith("1")) {
                //ΠΡΙΝ
                newOper = " ($i" + input + "/@y/number() <" + from + ") ";
            } else if (oper.endsWith("2")) {
                //ΜΕΤΑ
                newOper = " ($i" + input + "/@x/number() >" + to + ") ";
            } else if (oper.endsWith("3")) {
                //ΣΥΜΠΙΠΤΕΙ
                newOper = " ($i" + input + "/@x/number() =" + from + " and $i" + input + "/@y/number() =" + to + ") ";
            } else if (oper.endsWith("4")) {
                //ΠΕΡΙΕΧΕΤΑΙ
                newOper = " ($i" + input + "/@x/number() >" + from + " and $i" + input + "/@y/number() <" + to + ") ";
            } else if (oper.endsWith("5")) {
                //ΠΕΡΙΕΧΕΙ
                newOper = " ($i" + input + "/@x/number() <" + from + " and $i" + input + "/@y/number() >" + to + ") ";
            } else if (oper.endsWith("6")) {
                //ΤΟΜΗ
                newOper = " ($i" + input + "/@x/number() <" + to + " and $i" + input + "/@y/number() >" + from + ") ";
            } else if (oper.endsWith("7")) {
                //ΤΟΜΗ ΔΕΞΙΑ
                newOper = " ($i" + input + "/@x/number() >=" + from + " and $i" + input + "/@x/number() <=" + to + " and $i" + input + "/@y/number() >" + to + ") ";
            } else if (oper.endsWith("8")) {
                //ΤΟΜΗ ΑΡΙΣΤΕΡΑ
                newOper = " ($i" + input + "/@x/number() <" + from + " and $i" + input + "/@y/number() >=" + from + " and $i" + input + "/@y/number() <=" + to + ") ";
            }
            return newOper;

        } else if (oper.startsWith("math")) {
            String newOper = "";

            if (oper.endsWith("1")) {
                newOper = " ($i" + input + "/text() =" + value + ") ";
            } else if (oper.endsWith("2")) {
                newOper = " ($i" + input + "/text() !=" + value + ") ";
            } else if (oper.endsWith("3")) {
                newOper = " ($i" + input + "/text() >" + value + ") ";
            } else if (oper.endsWith("4")) {
                newOper = " ($i" + input + "/text() >=" + value + ") ";
            } else if (oper.endsWith("5")) {
                newOper = " ($i" + input + "/text() <" + value + ") ";
            } else if (oper.endsWith("6")) {
                newOper = " ($i" + input + "/text() <=" + value + ") ";
            }
            return newOper;
        } else {

            return " " + oper + "($i" + input + ", \'" + value + "\') ";
        }
    }

    public static boolean userHasAction(String action, String username, DMSConfig conf) {
        //from the database
        DMSUser user;
        boolean ret = false;
        try {
            user = new DMSUser(username, conf);
            ret = user.hasAction(action);
        } catch (DMSException e) {
            e.printStackTrace();
        }
        return ret;
    }

    private static String getMatch(String input, String pattern) {
        String ResultString = "";
        try {
            Pattern Regex = Pattern.compile(pattern,
                    Pattern.DOTALL);
            Matcher RegexMatcher = Regex.matcher(input);
            if (RegexMatcher.find()) {
                ResultString = RegexMatcher.group();
            }
        } catch (PatternSyntaxException ex) {
            // Syntax error in the regular expression
        }
        return ResultString;
    }

    private static StringBuffer getLaAndLiTags(String category, String lang) {

        ArrayList[] allListTags = getListOfTags(category, lang);
        StringBuffer xpathsTags = new StringBuffer("<xpaths>\n");
        xpathsTags.append(allListTags[0]);
        xpathsTags.append("</xpaths>\n");

        StringBuffer labelsTags = new StringBuffer("<labels>\n");
        labelsTags.append(allListTags[1]);
        labelsTags.append("</labels>\n");

        StringBuffer dataTypesTags = new StringBuffer("<dataTypes>\n");
        dataTypesTags.append(allListTags[2]);
        dataTypesTags.append("</dataTypes>\n");

        StringBuffer selectedTags = new StringBuffer("<selectedTags>\n");
        selectedTags.append(allListTags[3]);
        selectedTags.append("</selectedTags>\n");

        StringBuffer vocTags = new StringBuffer("<vocTags>\n");
//        for (int i = 0; i < allListTags[4].size(); i++) {
//            String[] terms = (String[]) allListTags[4].get(i);
//            vocTags.append("<vocabulary>\n");
//            for (String t : terms) {
//
//                vocTags.append("***").append(t.trim()).append("***");
//            }
//            vocTags.append("</vocabulary>\n");
//        }
        vocTags.append(allListTags[4]);
        vocTags.append("</vocTags>\n");

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");

        inputsTag.append(xpathsTags);
        inputsTag.append(labelsTags);
        inputsTag.append(dataTypesTags);
        inputsTag.append(selectedTags);
        inputsTag.append(vocTags);

        inputsTag.append("</inputs>\n");
        return inputsTag;

    }

    private static ArrayList[] getListOfTags(String category, String lang) {

        ArrayList[] allList = new ArrayList[5];
        try {
            DBFile nodesFile = new DBFile(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "LaAndLi/", category + ".xml", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);

            String nodesQuery = "";
            nodesQuery = "for $node in //node[@type='" + category + "']"
                    + " return"
                    + " <label>"
                    + " {$node/xpath}"
                    + " <lang>{$node/" + lang + "/string()}</lang>"
                    + " <dataType>{$node/dataType/string()}</dataType>"
                    + " <vocabulary>{$node/vocabulary/string()}</vocabulary>"
                    + " </label>";

            String[] nodes = nodesFile.queryString(nodesQuery);
            ArrayList<String> xpaths = new ArrayList<String>();
            ArrayList<String> labels = new ArrayList<String>();
            ArrayList<String> dataTypes = new ArrayList<String>();
            // ArrayList<String[]> vocabulary = new ArrayList<String[]>();
            ArrayList<String> vocabulary = new ArrayList<String>();
            DMSConfig vocConf = new DMSConfig(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "Vocabulary/", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);
            SchemaFile sch = new SchemaFile(ApplicationBasicServlet.schemaFolder + category + ".xsd");

            for (int i = 0; i < nodes.length; i++) {
                String xpath = getMatch(nodes[i], "(?<=<xpath>)[^<]+(?=</xpath>)");
                xpaths.add(getMatch(nodes[i], "(?<=<xpath>)[^<]+(?=</xpath>)"));
                labels.add(getMatch(nodes[i], "(?<=<lang>)[^<]+(?=</lang>)"));
                String vocName = getMatch(nodes[i], "(?<=<vocabulary>)[^<]+(?=</vocabulary>)");
                if (!vocName.equals("")) {
                    // Vocabulary voc = new Vocabulary(vocName, lang, vocConf);
                    // String[] terms = voc.termValues();
                    //  vocabulary.add(terms);
                    vocabulary.add(vocName);
                } else {
                    vocabulary.add("");
                }
                String pathType = "string";
                ArrayList<Element> elements = sch.getElements(xpath);
                if (!elements.isEmpty()) {
                    Element el = elements.get(0);
                    pathType = el.getType();
                }

//                if (getMatch(nodes[i], "(?<=<dataType>)[^<]+(?=</dataType>)").equals("")) {
//                    dataTypes.add("string");
//                } else {
//                    dataTypes.add(getMatch(nodes[i], "(?<=<dataType>)[^<]+(?=</dataType>)"));
//                }
//                System.out.println("pathType " + el.getType());
                if (pathType.equals("string") || pathType.equals("")) {
                    dataTypes.add("string");
                } else if (pathType.equals("date") || pathType.equals("time_span")) {
                    dataTypes.add("time");
                } else if (pathType.equals("integer") || pathType.equals("decimal") || pathType.equals("int")) {
                    dataTypes.add("math");
                } else {
                    dataTypes.add("string");
                }
            }

            ArrayList selectedInputs = new ArrayList();

            for (int i = 0; i < xpaths.size(); i++) {
                selectedInputs.add("0");
            }
      
            allList[0] = xpaths;
            allList[1] = labels;
            allList[2] = dataTypes;
            allList[3] = selectedInputs;
            allList[4] = vocabulary;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return allList;

    }

    private static StringBuffer getSelectedTags(String[] inputs, ArrayList<String> xpaths) {

        StringBuffer selectedTags = new StringBuffer("");
        if (xpaths != null) {
            if (inputs.length > 0) {
                for (String input : inputs) {
                    selectedTags.append("<selectedTags>\n");
                    ArrayList selectedInputs = new ArrayList();

                    for (int i = 0; i < xpaths.size(); i++) {
                        String xpath = xpaths.get(i);

                        if (input.trim().equals("/" + xpath)) {
                            selectedInputs.add("1");
                        } else {
                            selectedInputs.add("0");
                        }

                    }
                    selectedTags.append(selectedInputs);

                    selectedTags.append("</selectedTags>");

                }
            } else {
                selectedTags.append("<selectedTags>\n");
                ArrayList selectedInputs = new ArrayList();
                for (int i = 0; i < xpaths.size(); i++) {
                    selectedInputs.add("0");
                }
                selectedTags.append("</selectedTags>\n");

            }
        }

        return selectedTags;

    }
}
