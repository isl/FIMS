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
import isl.dbms.DBMSException;
import isl.dms.DMSConfig;
import isl.dms.DMSException;
import isl.dms.file.DMSTag;
import isl.dms.file.DMSUser;
import isl.dms.file.DMSXQuery;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

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

        tagXPaths = DMSTag.valueOf("xpath", "input", category, conf);
        tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "input", category, conf);
//        String[] tagOpers = DMSTag.valueOf("oper", "input", category, conf);
        String[] tagType = DMSTag.valueOf("dataType", "input", category, conf);

//        Arrays.sort(inputsParameters);
        StringBuffer inputsTag = new StringBuffer("<inputs>\n");
        for (int i = 0; i < inputs.length; i++) {
            String inputId = inputsIds[i];
            inputsTag.append("<input id=\"").append(inputId).append("\">\n");

            for (int j = 0; j < tagXPaths.length; j++) {
                String xPath = tagXPaths[j];
                inputsTag.append("<path xpath=\"").append(xPath).append("\"");
                inputsTag.append(" dataType=\"").append(tagType[j]).append("\"");

                if (xPath.equals(inputs[i])) {
                    inputsTag.append(" selected=\"yes\">");
                } else {
                    inputsTag.append(" selected=\"no\">");
                }
                inputsTag.append(tagDisplayNames[j]).append("</path>\n");
            }
            /*
             * check inputsOpers[i] =null
             */
            if ((inputsOpers.length - 1) >= i) {
                inputsTag.append("<oper>").append(inputsOpers[i]);
                inputsTag.append("</oper>\n");
            }

            inputsTag.append("<value>").append(inputsValues[i]);
            inputsTag.append("</value>\n</input>\n");
        }
        inputsTag.append("</inputs>\n");

        StringBuffer outputsTag = new StringBuffer("<outputs>\n");

        StringBuffer infoTag = new StringBuffer("<info>\n");

        if (outputs.length != 0) {
            Map<String, String> listing = new HashMap();
            for (int i = 0; i < tagXPaths.length; i++) {
                listing.put(tagXPaths[i], tagDisplayNames[i]);
            }
            for (int i = 0; i < outputs.length; i++) {
                String xPath = tagXPaths[i];
                outputsTag.append("<path xpath=\"").append(outputs[i]).append("\"");
                outputsTag.append(" selected=\"yes\">");
                outputsTag.append(listing.get(outputs[i])).append("</path>\n");
            }
        } else {

            String[] outputsTitle = UtilsXPaths.getOutpuTitleForSimpleSearch(category);
            for (String outputsTitle1 : outputsTitle) {
                outputsTag.append("<path xpath=\"").append("").append("\"");
                outputsTag.append(" selected=\"yes\">");
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
        String lang = query.getInfo("lang");

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

        tagXPaths = DMSTag.valueOf("xpath", "input", category, conf);
        tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "input", category, conf);
        String[] tagOpers = DMSTag.valueOf("oper", "input", category, conf);
        String[] tagType = DMSTag.valueOf("dataType", "input", category, conf);

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");
        for (int i = 0; i < qInputs.length; i++) {
            int inId = qInputs[i];
            inputsTag.append("<input id=\"").append(inId).append("\">\n");
            for (int p = 0; p < tagXPaths.length; p++) {
                inputsTag.append("<path xpath=\"").append(tagXPaths[p]).append("\"");
                inputsTag.append(" dataType=\"").append(tagType[p]).append("\"");
                inputsTag.append(" oper=\"").append(tagOpers[i]).append("\"");

                if (tagXPaths[p].equals(query.getFromInput(inId, "path"))) {
                    inputsTag.append(" selected=\"yes\">");
                } else {
                    inputsTag.append(" selected=\"no\">");
                }
                inputsTag.append(tagDisplayNames[p]).append("</path>\n");
            }

            inputsTag.append("<oper>").append(query.getFromInput(inId, "oper"));
            inputsTag.append("</oper>\n");

            inputsTag.append("<value>").append(query.getFromInput(inId, "value"));
            inputsTag.append("</value>\n</input>\n");
        }
        inputsTag.append("</inputs>\n");

        StringBuffer outputsTag = new StringBuffer("<outputs>\n");
        for (int i = 0; i < tagXPaths.length; i++) {
            outputsTag.append("<path xpath=\"").append(tagXPaths[i]).append("\"");
            if (query.hasOutput(tagXPaths[i])) {
                outputsTag.append(" selected=\"yes\">");
            } else {
                outputsTag.append(" selected=\"no\">");
            }
            outputsTag.append(tagDisplayNames[i]).append("</path>\n");
        }
        outputsTag.append("</outputs>\n");

        StringBuffer infoTag = new StringBuffer("<info>\n");
        infoTag.append("<name>").append(query.getInfo("name")).append("</name>\n");
        infoTag.append("<category>").append(category).append("</category>\n");
        infoTag.append("<lang>").append(lang).append("</lang>\n");
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

        tagXPaths = DMSTag.valueOf("xpath", "input", category, conf);
        tagDisplayNames = DMSTag.valueOf("displayname/" + conf.LANG, "input", category, conf);
        String[] tagOpers = DMSTag.valueOf("oper", "input", category, conf);

        String[] tagType = DMSTag.valueOf("dataType", "input", category, conf);

        StringBuffer xmlTmp = new StringBuffer();
        for (int i = 0; i < tagXPaths.length; i++) {
            if (i == 0) {
                xmlTmp.append("<path xpath=\"").append(tagXPaths[i]).append("\"").append(" dataType=\"").append(tagType[i] + "\"").append(" oper=\"").append(tagOpers[i]).append("\" selected=\"yes\">").append(tagDisplayNames[i]).append("</path>\n");
            } else {

                xmlTmp.append("<path xpath=\"").append(tagXPaths[i]).append("\"").append(" dataType=\"").append(tagType[i] + "\"").append(" oper=\"").append(tagOpers[i]).append("\" selected=\"no\">").append(tagDisplayNames[i]).append("</path>\n");
            }
        }

        StringBuffer inputsTag = new StringBuffer("<inputs>\n");


        inputsTag.append("<input id=\"1\">\n").append(xmlTmp).append("<value/>\n</input>\n");
        inputsTag.append("</inputs>\n");

        StringBuffer outputsTag = new StringBuffer("<outputs>\n");
        for (int i = 0; i < tagXPaths.length; i++) {
            outputsTag.append("<path xpath=\"").append(tagXPaths[i]).append("\" selected=\"no\">").append(tagDisplayNames[i]).append("</path>\n");
        }
        outputsTag.append("</outputs>\n");

        StringBuffer ret = buildXML(0, category, infoTag, targetsTag, inputsTag, outputsTag);
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
}
