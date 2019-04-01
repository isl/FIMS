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
import isl.FIMS.utils.Utils;
import isl.FIMS.utils.UtilsQueries;
import isl.FIMS.utils.UtilsXPaths;
import isl.dbms.DBCollection;
import isl.dbms.DBFile;
import isl.dbms.DBMSException;
import isl.dms.DMSConfig;
import isl.dms.DMSException;
import isl.dms.file.DMSTag;
import isl.dms.file.DMSUser;
import isl.dms.file.DMSXQuery;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import javax.servlet.http.HttpSession;
import org.w3c.dom.NodeList;
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
        String[] refByEntities = (String[]) params.get("refByEntities");
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
        inQuerySource.append("return $i\n").append("return\n").append("<stats>\n").append("{let $ids := distinct-values($results//id)").append("for $j in 1 to count($results)\n").append("let $current := $results[$j]\n").append("let $i := $results[$j]\n");
        StringBuffer querychildTargets = new StringBuffer();
        StringBuffer queryFor = new StringBuffer("for ");

        StringBuffer queryWhere = new StringBuffer();
        UtilsQueries u = new UtilsQueries();

        HashMap<String, String> colToVariable = new <String, String>HashMap();
        for (int i = 0; i < targets.length; i++) {
            String target = targets[i];
            if (i == 0) {
                colToVariable.put(target, "i");
            } else {
                if (!colToVariable.containsKey(target)) {
                    colToVariable.put(target, "c" + i);
                }
            }
        }
        Iterator<String> entities = colToVariable.keySet().iterator();
        StringBuffer queryRestrictLangSave = new StringBuffer("");

        while (entities.hasNext()) {
            String target = entities.next();
            String variable = colToVariable.get(target);
            queryFor.append("$" + variable + " in ");
            queryFor.append("collection('").append(target + "/").append("'), ");
            queryRestrictLangSave.append("and $").append(variable).append("//admin/saved='yes'\n");
            queryRestrictLangSave.append("and $").append(variable).append("//admin/lang='" + lang + "'\n");
        }
        querychildTargets.append(targets[0]);

        try {
            queryFor.delete(queryFor.lastIndexOf(","), queryFor.length());
        } catch (StringIndexOutOfBoundsException se) {
        }
        queryWhere = u.getQueryConditionsForSearch(queryWhere, params, mode, username, lang);
        queryWhere.append(queryRestrictLangSave);
        StringBuffer queryMiddle = new StringBuffer();
        int countRefBy = 0;
        for (int i = 0; i < inputs.length; i++) {
            if (!inputs[i].equals("refBy_/") && !inputs[i].equals("/" + category)) {
                System.out.println("inputsOpers[i] " + operator);
                System.out.println("input " + inputs[i]);

                inputsValues[i] = inputsValues[i].replaceAll("'", "");
                inputsValues[i] = inputsValues[i].replaceAll("\"", "");
                inputsValues[i] = inputsValues[i].replaceAll("&", "");
                String variable = "";

                if (inputs[i].equals("")) {

                    variable = "i";
                } else {
                    String inputEntity = inputs[i].split("/")[1];
                    String key = ApplicationBasicServlet.systemDbCollection + inputEntity;
                    variable = colToVariable.get(key);
                }
                if (inputs[i].contains("refBy_")) {
                    countRefBy++;
                }
                if (countRefBy == 1) {

                    int index = queryMiddle.lastIndexOf(operator);
                    if (index != -1) {
                        queryMiddle.delete(index, queryMiddle.length());
                        queryMiddle.append("or");
                    }
                }

                if (inputsValues[i].contains("__")) {
                    String externalEntity = inputsValues[i].split("__")[0];
                    String externalkey = ApplicationBasicServlet.systemDbCollection + externalEntity;
                    String extVariable = colToVariable.get(externalkey);
                    if (extVariable != null) {
                        if (inputs[i].contains("refBy_")) {
                            String condition = "$" + variable + inputs[i].split("refBy_")[1] + "/@sps_type = '" + externalEntity + "' \n";
                            condition += "and " + "$" + variable + inputs[i].split("refBy_")[1] + "/@sps_id = $" + extVariable + "/" + externalEntity + "/admin/id/text()";
                            queryMiddle.append(condition).append(operator).append("\n");
                        } else {
                            String condition = "$" + variable + inputs[i] + "/@sps_type = '" + externalEntity + "' \n";
                            condition += "and " + "$" + variable + inputs[i] + "/@sps_id = $" + extVariable + "/" + externalEntity + "/admin/id/text()";
                            queryMiddle.append(condition).append(operator).append("\n");
                        }
                    }
                } else {
                    if (inputs[i].contains("refBy_")) {
                        queryMiddle.append(getPredicate(inputs[i].split("refBy_")[1], inputsOpers[i], inputsValues[i], variable)).append(operator).append("\n");
                    } else {
                        queryMiddle.append(getPredicate(inputs[i], inputsOpers[i], inputsValues[i], variable)).append(operator).append("\n");
                    }
                }

            }
        }
        try {
            queryMiddle.delete(queryMiddle.lastIndexOf(operator), queryMiddle.length());
        } catch (StringIndexOutOfBoundsException se) {
        }
        for (int j = 0; j < refByEntities.length; j++) {
            String externalEntity = refByEntities[j];
            String externalkey = ApplicationBasicServlet.systemDbCollection + externalEntity;
            String extVariable = colToVariable.get(externalkey);
            if (extVariable != null) {
                String op = "";
                if (queryMiddle.length() > 0) {
                    op = "and";
                }
                String condition = " " + op + " $i//admin//ref_by/@sps_type = '" + externalEntity + "' \n";
                condition += "and " + "$i//admin//ref_by/@sps_id = $" + extVariable + "/" + externalEntity + "/admin/id/text()";
                queryMiddle.append(condition).append("\n");
            }

        }
//        try {
//            queryMiddle.delete(queryMiddle.lastIndexOf(operator), queryMiddle.length());
//        } catch (StringIndexOutOfBoundsException se) {
//        }
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
        query.append("let $b:= xmldb:get-child-collections('").append(querychildTargets).append("')");
        query.append("return count($b),");
        query.append("$collcount:=$collections+").append(dataCol).append(",");
        query.append("$results:=\n");
        //     query.append("for $m in ").append(dataCol).append(" to  $collcount\n");
        query.append("for $m in ").append("1").append(" to  1\n");
        query.append("return\n");
        query.append(queryFor);

        query.append("let $id := $i//admin/id\n");

        if (queryMiddle.length() > 0) {
            query.append("where ").append(queryMiddle).append(queryEnd);
        } else {
            query.append(queryEnd);
        }
        return query.toString();
    }

    //Builds XML representing query (XQueries-like format)
    public static String getXML4ResultXsl(Hashtable params, DMSConfig conf, String dataCol, HttpSession session) throws DMSException {
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

//       / java.util.Arrays.sort(targets);
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
        for (int i = 1; i < targets.length; i++) {
            targetsTag.append("<path xpath=\"").append(targets[i]).append("\"");
            targetsTag.append(" selected=\"no\">").append("</path>\n");

        }
        targetsTag.append("</targets>\n");
        ArrayList[] all = getListOfTags(category, lang, session);
        ArrayList<String> xpaths = all[0];

        //   StringBuffer selectedTags = getSelectedTags(inputs, xpaths);
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
        StringBuffer thesTags = new StringBuffer("<thesTags>\n");
        thesTags.append(all[5]);
        thesTags.append("</thesTags>\n");

        StringBuffer linksTags = new StringBuffer("<linksTags>\n");
        linksTags.append(all[6]);
        linksTags.append("</linksTags>\n");

        StringBuffer input = new StringBuffer("");

        int i = 0;

        for (String t : inputs) {
            input.append("<input>\n");
            if (!t.equals("/" + category)) {

                input.append("<selectedXapths>\n");
                input.append(t.trim());
                input.append("</selectedXapths>\n");
            } else {
                input.append("<selectedXapths>\n");
                input.append("[]");
                input.append("</selectedXapths>\n");
            }
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

        for (int j = 0; j < inputs.length; j++) {
            inputsTag.append("<selectedTags>\n").append(inputs[j]).append("</selectedTags>\n");
        }
        inputsTag.append(vocTags);
        inputsTag.append(thesTags);
        inputsTag.append(linksTags);

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

    public static String getXML4SavedQuery(DMSXQuery query, DMSConfig conf, HttpSession session) throws DMSException {
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

        ArrayList[] all = getListOfTags(category, conf.LANG, session);
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

        StringBuffer thesTags = new StringBuffer("<thesTags>\n");
        thesTags.append(all[5]);
        thesTags.append("</thesTags>\n");

        StringBuffer linksTags = new StringBuffer("<linksTags>\n");
        linksTags.append(all[6]);
        linksTags.append("</linksTags>\n");

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
            System.out.println("xpath " + xpath);
            if (!xpath.equals("/" + category)) {

                input.append("<selectedXapths>\n");
                input.append(xpath.trim());
                input.append("</selectedXapths>\n");
            } else {
                System.out.println("in");
                input.append("<selectedXapths>\n");
                input.append("[]");
                input.append("</selectedXapths>\n");
            }
//            input.append("<selectedXapths>\n");
//            input.append(xpath);
//            input.append("</selectedXapths>\n");
            input.append("<value>\n");
            input.append(value);
            input.append("</value>\n");
            input.append("<oper>\n").append(oper);
            input.append("</oper>\n");
            input.append("<inputLabel>\n").append(label);
            input.append("</inputLabel>\n");
            input.append("</input>\n");

        }
        //   StringBuffer selectedTags = getSelectedTags(inputs.toArray(new String[inputs.size()]), xpaths);

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");

        inputsTag.append(xpathsTags);
        inputsTag.append(labelsTags);
        inputsTag.append(dataTypesTags);
        for (int i = 0; i < inputs.size(); i++) {
            if (!inputs.get(i).equals("/" + category)) {
                inputsTag.append("<selectedTags>\n").append(inputs.get(i)).append("</selectedTags>\n");
            } else {
                inputsTag.append("<selectedTags>\n").append("[]").append("</selectedTags>\n");
            }
        }
        inputsTag.append(vocTags);
        inputsTag.append(thesTags);
        inputsTag.append(linksTags);

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

    public static String xml4InitialSearch(String category, String lang, String status, DMSConfig conf, HttpSession session) throws DMSException {
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

        StringBuffer inputsTag = getLaAndLiTags(category, lang, session);
        StringBuffer ret = buildXML(0, category, infoTag, targetsTag, inputsTag, new StringBuffer(""));
        return ret.toString();
    }

    public static String getReferecedByEntities(DBCollection col, String category) {
        StringBuffer refByTag = new StringBuffer("<refByTag>\n");
        String[] res = col.query("data(//admin/refs_by/ref_by[@sps_id!=0 and @sps_type!='" + category + "']/@sps_type)");
        for (String r : res) {
            if (!refByTag.toString().contains(r)) {
                refByTag.append("<type>").append(r).append("</type>\n");
            }
        }
        refByTag.append("</refByTag>\n");
        return refByTag.toString();
    }

    private static StringBuffer buildXML(int qId, String category, StringBuffer infoTag, StringBuffer targetsTag, StringBuffer inputsTag, StringBuffer outputsTag) {
        StringBuffer ret = new StringBuffer("<query id=\"" + qId + "\">\n");
        ret.append(infoTag).append(targetsTag).append(inputsTag).append(outputsTag);
        ret.append("\n</query>\n");
        ret.append("<LeftMenuId>").append("search" + category).append("</LeftMenuId>");
        ret.append("<EntityType>").append(category).append("</EntityType>\n");
        return ret;
    }

    private static String getPredicate(String input, String oper, String value, String variable) {

        // perform a case-insensitive match
        if (oper.equals("matches")) {
            return " matches($" + variable + input + ", \'" + value + "\', \'i\') ";
        }

        // assume operators like: =, !=, etc.
        // for support for '<' or '>', we replace '&lt;' and '&gt;'
        oper = oper.replaceAll("&gt;", ">");
        oper = oper.replaceAll("&lt;", "<");
        if (oper.length() <= 2) {
            return " ($" + variable + input + oper + "\'" + value + "\') ";
        }

        //TIME-HANDLING 
        if (oper.startsWith("time")) {
            SISdate sisTime = new SISdate(value);

            String from = Integer.toString(sisTime.getFrom());
            String to = Integer.toString(sisTime.getTo());

            String newOper = "";
            if (oper.endsWith("1")) {
                //ΠΡΙΝ
                newOper = " ($" + variable + input + "/@y/number() <" + from + ") ";
            } else if (oper.endsWith("2")) {
                //ΜΕΤΑ
                newOper = " ($" + variable + input + "/@x/number() >" + to + ") ";
            } else if (oper.endsWith("3")) {
                //ΣΥΜΠΙΠΤΕΙ
                newOper = " ($" + variable + input + "/@x/number() =" + from + " and $" + variable + input + "/@y/number() =" + to + ") ";
            } else if (oper.endsWith("4")) {
                //ΠΕΡΙΕΧΕΤΑΙ
                newOper = " ($" + variable + input + "/@x/number() >" + from + " and $" + variable + input + "/@y/number() <" + to + ") ";
            } else if (oper.endsWith("5")) {
                //ΠΕΡΙΕΧΕΙ
                newOper = " ($" + variable + input + "/@x/number() <" + from + " and $" + variable + input + "/@y/number() >" + to + ") ";
            } else if (oper.endsWith("6")) {
                //ΤΟΜΗ
                newOper = " ($" + variable + input + "/@x/number() <" + to + " and $" + variable + input + "/@y/number() >" + from + ") ";
            } else if (oper.endsWith("7")) {
                //ΤΟΜΗ ΔΕΞΙΑ
                newOper = " ($" + variable + input + "/@x/number() >=" + from + " and $" + variable + input + "/@x/number() <=" + to + " and $" + variable + input + "/@y/number() >" + to + ") ";
            } else if (oper.endsWith("8")) {
                //ΤΟΜΗ ΑΡΙΣΤΕΡΑ
                newOper = " ($" + variable + input + "/@x/number() <" + from + " and $" + variable + input + "/@y/number() >=" + from + " and $" + variable + input + "/@y/number() <=" + to + ") ";
            }
            return newOper;

        } else if (oper.startsWith("math")) {
            String newOper = "";

            if (oper.endsWith("1")) {
                newOper = " ($" + variable + input + "/text() =" + value + ") ";
            } else if (oper.endsWith("2")) {
                newOper = " ($" + variable + input + "/text() !=" + value + ") ";
            } else if (oper.endsWith("3")) {
                newOper = " ($" + variable + input + "/text() >" + value + ") ";
            } else if (oper.endsWith("4")) {
                newOper = " ($" + variable + input + "/text() >=" + value + ") ";
            } else if (oper.endsWith("5")) {
                newOper = " ($" + variable + input + "/text() <" + value + ") ";
            } else if (oper.endsWith("6")) {
                newOper = " ($" + variable + input + "/text() <=" + value + ") ";
            }
            return newOper;
        } else if (oper.contains("containsNT")) {
            DBCollection laAndLiCol = new DBCollection(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "/LaAndLi", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);
            String temp = input.replaceFirst("/", "");
            String q = "//node[xpath/text()='" + temp + "']/facet";
            String[] res = laAndLiCol.query(q);
            String facetInfo = "";
            if (res.length > 0) {
                facetInfo = res[0];
            }
            org.w3c.dom.Element facetInfoE = Utils.getElement(facetInfo);
            String userName = facetInfoE.getAttribute("username");
            String themasUrl = facetInfoE.getAttribute("themasUrl");
            String thesaurusName = facetInfoE.getAttribute("thesaurusName");
            String urlEnd = "&external_user=" + userName + "&external_thesaurus=" + thesaurusName;
            String serviceURL = "";
            try {
                serviceURL = themasUrl + "SearchResults_Terms?updateTermCriteria=parseCriteria&answerType=XMLSTREAM&pageFirstResult=SaveAll&input_term=name&op_term==&inputvalue_term=" + URLEncoder.encode(value, "UTF-8")
                        + "&operator_term=or&output_term1=name&output_term1=rnt" + urlEnd;
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(QueryTools.class.getName()).log(Level.SEVERE, null, ex);
            }
            String themasServiceResponse = Utils.consumeService(serviceURL);
            String condition = "";
            if (oper.equals("containsNT")) {
                condition = "  contains($" + variable + input + ", \'" + value + "\') ";
            } else {
                condition = "  not(contains($" + variable + input + ", \'" + value + "\')) ";

            }

            if (themasServiceResponse.length() > 0) {
                org.w3c.dom.Element xml = Utils.getElement(themasServiceResponse);
                NodeList nts = xml.getElementsByTagName("rnt");
                for (int i = 0; i < nts.getLength(); i++) {
                    if (!nts.item(i).getTextContent().equals("")) {
                        if (oper.equals("containsNT")) {
                            condition += " or contains($" + variable + input + ", \'" + nts.item(i).getTextContent() + "\') ";
                        } else {
                            condition += " or not(contains($" + variable + input + ", \'" + nts.item(i).getTextContent() + "\')) ";

                        }
                    }
                }
            }
            return condition;
        } else if (oper.equals("containsTerm") || oper.equals("containsLink")) {
            return " " + "contains" + "($" + variable + input + ", \'" + value + "\') ";
        } else if (oper.equals("notContainsTerm") || oper.equals("notContains")) {
            return " " + "not(contains" + "($" + variable + input + ", \'" + value + "\')) ";
        } else {
            return " " + oper + "($" + variable + input + ", \'" + value + "\') ";
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

    private static StringBuffer getLaAndLiTags(String category, String lang, HttpSession session) {

        ArrayList[] allListTags = getListOfTags(category, lang, session);
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

        StringBuffer thesTags = new StringBuffer("<thesTags>\n");
        thesTags.append(allListTags[5]);
        thesTags.append("</thesTags>\n");
        StringBuffer inputsTag = new StringBuffer("<inputs>\n");

        StringBuffer linksTags = new StringBuffer("<linksTags>\n");
        linksTags.append(allListTags[6]);
        linksTags.append("</linksTags>\n");

        inputsTag.append(xpathsTags);
        inputsTag.append(labelsTags);
        inputsTag.append(dataTypesTags);
        inputsTag.append(selectedTags);
        inputsTag.append(vocTags);
        inputsTag.append(thesTags);
        inputsTag.append(linksTags);

        inputsTag.append("</inputs>\n");
        return inputsTag;

    }

    public static ArrayList[] getListOfTags(String category, String lang, HttpSession session) {

        ArrayList[] allList = new ArrayList[7];
        ArrayList<String> xpaths = new ArrayList<String>();
        ArrayList<String> labels = new ArrayList<String>();
        ArrayList<String> dataTypes = new ArrayList<String>();
        ArrayList selectedInputs = new ArrayList();
        ArrayList<String> vocabulary = new ArrayList<String>();
        ArrayList<String> thesaurus = new ArrayList<String>();
        ArrayList<String> links = new ArrayList<String>();

        String existsXpath = (String) session.getAttribute(category + ".xpaths");
        try {
            if (existsXpath == null) {
                DBFile nodesFile = new DBFile(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "LaAndLi/", category + ".xml", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);

                String nodesQuery = "";
                nodesQuery = "for $node in //node[@type='" + category + "']"
                        + " return"
                        + " <label>"
                        + " {$node/xpath}"
                        + " <lang>{$node/" + lang + "/string()}</lang>"
                        + " <dataType>{$node/dataType/string()}</dataType>"
                        + " <vocabulary>{$node/vocabulary/string()}</vocabulary>"
                        + " <valueFrom>{$node/valueFrom/string()}</valueFrom>"
                        + " <thes>{$node/facet}</thes>"
                        + " </label>";

                String[] nodes = nodesFile.queryString(nodesQuery);

                // ArrayList<String[]> vocabulary = new ArrayList<String[]>();
                DMSConfig vocConf = new DMSConfig(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "Vocabulary/", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);
                SchemaFile sch = new SchemaFile(ApplicationBasicServlet.schemaFolder + category + ".xsd");

                for (int i = 0; i < nodes.length; i++) {
                    String xpath = getMatch(nodes[i], "(?<=<xpath>)[^<]+(?=</xpath>)");
                    xpaths.add(getMatch(nodes[i], "(?<=<xpath>)[^<]+(?=</xpath>)"));
                    labels.add(getMatch(nodes[i], "(?<=<lang>)[^<]+(?=</lang>)"));
                    String vocName = getMatch(nodes[i], "(?<=<vocabulary>)[^<]+(?=</vocabulary>)");
                    String valueFrom = getMatch(nodes[i], "(?<=<valueFrom>)[^<]+(?=</valueFrom>)");

                    if (!vocName.equals("")) {
                        // Vocabulary voc = new Vocabulary(vocName, lang, vocConf);
                        // String[] terms = voc.termValues();
                        //  vocabulary.add(terms);
                        vocabulary.add(vocName);
                    } else {
                        vocabulary.add("");
                    }
                    if (!valueFrom.equals("")) {
                        links.add("true");
                    } else {
                        links.add("false");
                    }
                    if (nodes[i].contains("<facet")) {
                        thesaurus.add("true");
                    } else {
                        thesaurus.add("false");
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
                    //System.out.println("pathType " + pathType);
                    if (pathType.equals("string") || pathType.equals("")) {
                        dataTypes.add("string");
                    } else if (pathType.equals("date") || pathType.equals("time_span")) {
                        dataTypes.add("time");
                    } else if (pathType.equals("integer") || pathType.equals("decimal") || pathType.equals("int")) {
                        dataTypes.add("math");
                    } else if (pathType.equals("thesaurus")) {
                        dataTypes.add("thesaurus");
                    } else {
                        dataTypes.add("string");
                    }
                }
                session.setAttribute(category + ".xpaths", "true");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        allList[0] = xpaths;
        allList[1] = labels;
        allList[2] = dataTypes;
        allList[3] = selectedInputs;
        allList[4] = vocabulary;
        allList[5] = thesaurus;
        allList[6] = links;

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
