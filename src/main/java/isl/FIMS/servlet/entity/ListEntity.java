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
package isl.FIMS.servlet.entity;

import isl.FIMS.utils.entity.Config;
import isl.FIMS.utils.entity.GetEntityCategory;
import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.UtilsQueries;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import isl.dbms.DBCollection;
import isl.dms.DMSException;
import isl.dms.xml.XMLTransform;
import java.util.Arrays;

public class ListEntity extends ApplicationBasicServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml;charset=UTF-8");

        this.initVars(request);
                String username = getUsername(request);

        StringBuffer xml = new StringBuffer();
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String action = request.getParameter("action");
        if (status == null) {
            status = "";
        }
        if (action == null) {
            action = "";
        }

        this.setStatus(status);

        Config conf = new Config(type);

        xml = new StringBuffer(this.xmlStart(this.topmenu, username, this.pageTitle, this.lang, "", request));
        //depending on 'type' this varies
        StringBuffer outputsTag = new StringBuffer();
        String userOrg = this.getUserGroup(username);
        UtilsQueries u = new UtilsQueries();
        //========== paging code ==========
        //    u.initListPaging(request);
        String querySource = u.listEntityQuery(type, status, "", userOrg, this.lang, username, outputsTag);
        DBCollection queryCol = new DBCollection(this.DBURI, this.systemDbCollection, this.DBuser, this.DBpassword);
        String[] queryRes = queryCol.query(querySource);
        queryCol = new DBCollection(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword);
        StringBuffer resultsTag = new StringBuffer("<results>\n");
        for (int j = 0; j < queryRes.length; j++) {
            resultsTag.append(queryRes[j]).append("\n");
        }
        resultsTag.append("\n</results>\n");
        xml.append("<EntityCategory>").append(GetEntityCategory.getEntityCategory(type)).append("</EntityCategory>\n");
        xml.append("<URI_Reference_Path>").append(this.URI_Reference_Path).append("</URI_Reference_Path>\n");
        xml.append("<IsGuestUser>").append(this.userHasAction("guest",username)).append("</IsGuestUser>\n");
        xml.append("<DocStatus>").append(status).append("</DocStatus>\n");
        if (type.equals("Archive")) {
            xml.append("<photoType>").append("DigitalArchive").append("</photoType>\n");
        } else {
            xml.append("<photoType>").append(conf.ENTITY_TYPE).append("</photoType>\n");

        }
        xml.append("<EntityType>").append(conf.ENTITY_TYPE).append("</EntityType>\n");
        xml.append("<ServletName>").append(this.servletName).append("</ServletName>\n");
        xml.append("<TargetCol>").append(queryCol.getName()).append("</TargetCol>");
        xml.append("<query>\n");
        xml.append(outputsTag);
        xml.append(resultsTag);
        xml.append("</query>\n");
        xml.append(this.xmlEnd());
        String format = request.getParameter("format");
        if (format != null && format.equals("xml")) {
            response.setContentType("text/xml;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println(xml.toString());
            out.close();
        } else {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            if (Arrays.asList(ApplicationBasicServlet.entityListPhoto).contains(type)) {
                conf.LIST_ENTITY_XSL = conf.ENTITY_XSL_PATH + "list_photo_entity.xsl";

            }
            String xsl = conf.LIST_ENTITY_XSL;
            if(action.equals("compare")){
                xsl = conf.compare_xsl;
            }
            try {
                XMLTransform xmlTrans = new XMLTransform(xml.toString());
                xmlTrans.transform(out, xsl);
            } catch (DMSException e) {
                e.printStackTrace();
            }
            out.close();
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
