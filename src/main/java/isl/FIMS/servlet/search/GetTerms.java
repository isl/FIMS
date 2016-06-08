/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package isl.FIMS.servlet.search;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.Vocabulary;
import isl.dms.DMSConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.minidev.json.JSONObject;

/**
 *
 * @author konsolak
 */
public class GetTerms extends ApplicationBasicServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        DMSConfig vocConf = new DMSConfig(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "Vocabulary/", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);
        String vocName = request.getParameter("vocName");
        String lang = request.getParameter("lang");
        Vocabulary voc = new Vocabulary(vocName, lang, vocConf);
        String[] terms = voc.termValues();
        List<String> list = new ArrayList<String>(Arrays.asList(terms));
        list.remove("-------------------");
        try {
            /* TODO output your page here. You may use following sample code. */
            JSONObject jsonData = new JSONObject();
            jsonData.put("terms", list);
            out.print(jsonData.toString());
        } finally {
            out.close();
        }
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
