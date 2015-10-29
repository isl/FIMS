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
import isl.dms.DMSException;
import isl.dms.file.DMSTag;

/**
 *
 * @author konsolak
 */
public class UtilsXPaths {

    //uri filed path
    public static String getPathUriField(String type) {
        String uri_path = "";
        try {
            String[] tmp = DMSTag.valueOf("uri_path", "target", type, ApplicationBasicServlet.getDMSConfig());
            if (tmp.length > 0) {
                uri_path = tmp[0];
            }
        } catch (DMSException ex) {
            ex.printStackTrace();
        }

        return uri_path;
    }

    public static String getPrimaryEntitiesInsertPath(String type) {
        String path = "";
        try {
            path = DMSTag.valueOf("xpath", "title", type, ApplicationBasicServlet.getDMSConfig())[0];
        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        return path;
    }

    //simple search output result
    public static String[] getOutputResultForSimpleSearch(String type) {
        String[] outputResult = null;
        try {
            outputResult = DMSTag.valueOf("xpath", "listOutput", type, ApplicationBasicServlet.getDMSConfig());
        } catch (DMSException ex) {
            ex.printStackTrace();
        }

        return outputResult;

    }
    //simple search results

    public static String[] getOutpuTitleForSimpleSearch(String type) {
        String[] outputTitle = null;
        try {
            outputTitle = DMSTag.valueOf("tagname", "listOutput", type, ApplicationBasicServlet.getDMSConfig());
        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        return outputTitle;
    }

    //title for translate and version criteria
    public static String getOutpuTitleForTranslateCriteria(String type) {
        String outputTitle = new String();
        try {
            outputTitle = DMSTag.valueOf("tagname", "title", type, ApplicationBasicServlet.getDMSConfig())[0];
        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        return outputTitle;
    }

    /**
     *
     * @param type
     * @return path for search at name at each entity
     */
    public static String getSearchXpathAtName(String type) {
        String xpath = "";
        try {
            xpath = DMSTag.valueOf("xpath", "title", type, ApplicationBasicServlet.getDMSConfig())[0];
            xpath = "/" + xpath;
        } catch (DMSException ex) {
            ex.printStackTrace();
        }

        return xpath;
    }

    public static StringBuffer[] getXpathQuery(StringBuffer[] query, String type) {
        StringBuffer outputsTag = query[0];
        StringBuffer queryRet = query[1];
        StringBuffer queryOrderBy = query[2];
        String[] labels = null;
        String[] labelsExt = null;
        String[] adminLabels = null;
        String[] adminLabelsExt = null;

        String order = "";
        String[] xpaths = null;
        String[] xpathsExt = null;

        String[] adminPaths = null;
        String[] adminPathsExt = null;

        try {
            labels = DMSTag.valueOf("tagname", "listOutput", type, ApplicationBasicServlet.getDMSConfig());
            adminLabels = DMSTag.valueOf("tagname", "adminOutput", type, ApplicationBasicServlet.getDMSConfig());
            labelsExt = DMSTag.valueOf("tagname", "listOutputExternal", type, ApplicationBasicServlet.getDMSConfig());
            adminLabelsExt = DMSTag.valueOf("tagname", "adminOutputExt", type, ApplicationBasicServlet.getDMSConfig());

            order = DMSTag.valueOf("xpath", "title", type, ApplicationBasicServlet.getDMSConfig())[0];

            xpaths = DMSTag.valueOf("xpath", "listOutput", type, ApplicationBasicServlet.getDMSConfig());
            adminPaths = DMSTag.valueOf("xpath", "adminOutput", type, ApplicationBasicServlet.getDMSConfig());
            xpathsExt = DMSTag.valueOf("xpath", "listOutputExternal", type, ApplicationBasicServlet.getDMSConfig());
            adminPathsExt = DMSTag.valueOf("xpath", "adminOutputExt", type, ApplicationBasicServlet.getDMSConfig());

        } catch (DMSException ex) {
            ex.printStackTrace();
        }
        int i = 0;
        queryRet.append("return\n").append("<result>\n");
        for (String label : labels) {
            outputsTag.append("<path xpath=\"xxx\" selected=\"yes\">").append(label).append("</path>\n");
            queryRet.append("<" + label + ">\n{$i/" + xpaths[i] + "}\n</" + label + ">\n");
            i++;
        }
        i = 0;
        for (String label : labelsExt) {
            outputsTag.append("<path xpath=\"xxx\" selected=\"yes\">").append(label).append("</path>\n");
            queryRet.append("<" + label + ">\n{/" + xpathsExt[i] + "}\n</" + label + ">\n");
            i++;
        }
        i = 0;

        for (String label : adminLabelsExt) {
            if (label.equals("info") || label.equals("type")) {
                outputsTag.append("<path xpath=\"xxx\" selected=\"no\">").append(label).append("</path>\n");
            } else {
                outputsTag.append("<path xpath=\"xxx\" selected=\"yes\">").append(label).append("</path>\n");
            }

            queryRet.append("<" + label + ">\n{" + adminPathsExt[i] + "}\n</" + label + ">\n");

            i++;
        }
        i = 0;

        for (String label : adminLabels) {
            if (label.equals("info") || label.equals("type")) {
                outputsTag.append("<path xpath=\"xxx\" selected=\"no\">").append(label).append("</path>\n");
            } else {
                outputsTag.append("<path xpath=\"xxx\" selected=\"yes\">").append(label).append("</path>\n");
            }
            if (label.equals("AdminOrganization")) {
                queryRet.append("<" + label + ">\n<" + label + ">\n{string(doc('" + ApplicationBasicServlet.adminDbCollection + ApplicationBasicServlet.conf.GROUPS_FILE + "')//group[@id=$i" + adminPaths[i] + "]/@groupname)}\n</" + label + ">\n</" + label + ">\n");
            } else {
                queryRet.append("<" + label + ">\n{$i" + adminPaths[i] + "}\n</" + label + ">\n");

            }
            i++;
        }

        queryOrderBy.append("order by $i/" + order +"[1]"+ "/text()\n");
        query[0] = outputsTag;
        query[1] = queryRet;
        query[2] = queryOrderBy;

        return query;
    }

}
