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
package isl.FIMS.servlet.export;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.ParseXMLFile;
import isl.FIMS.utils.Utils;
import isl.FIMS.utils.entity.Config;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author konsolak
 */
public class ExportSchema extends ApplicationBasicServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.initVars(request);
                String username = getUsername(request);

        boolean isGuest = this.getRights(username).equals("guest");
        if (!isGuest) {
            try {
                String filePath = this.export_import_Folder;
                java.util.Date date = new java.util.Date();
                Timestamp t = new Timestamp(date.getTime());
                String currentDir = filePath + t.toString().replaceAll(":", "").replaceAll("\\s", "");
                File saveDir = new File(currentDir);
                saveDir.mkdir();
                Config conf = new Config("ExportSchema");
                String type = request.getParameter("type");
                request.setCharacterEncoding("UTF-8");

                ServletOutputStream outStream = response.getOutputStream();
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + "Schema_" +type+ ".zip\"");
                File schemaFile = new File(this.schemaFolder + type + ".xsd");
                FileUtils.copyFile(schemaFile, new File(currentDir + System.getProperty("file.separator") + type + ".xsd"));
                Utils.copySchemaReferences(this.schemaFolder + type + ".xsd", currentDir);
            
                File f = new File(currentDir + System.getProperty("file.separator") + "zip");
                f.mkdir();
                String zip = f.getAbsolutePath() + System.getProperty("file.separator") + "Schema_" + type + ".zip";

                Utils.createZip(zip, currentDir);
                Utils.downloadZip(outStream, new File(zip));

                Utils.deleteDir(currentDir);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
    //write to temp File at server

    // <editor-lfold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
