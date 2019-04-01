/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package isl.FIMS.servlet.search;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.Utils;
import isl.FIMS.utils.Vocabulary;
import isl.FIMS.utils.search.QueryTools;
import isl.dbms.DBCollection;
import isl.dms.DMSConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import static javafx.scene.input.KeyCode.T;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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

        String action = request.getParameter("action") == null ? "" : request.getParameter("action");
        String lang = request.getParameter("lang");
        if (action.equals("getVocTerms")) {

            DMSConfig vocConf = new DMSConfig(ApplicationBasicServlet.DBURI, ApplicationBasicServlet.systemDbCollection + "Vocabulary/", ApplicationBasicServlet.DBuser, ApplicationBasicServlet.DBpassword);
            String vocName = request.getParameter("vocName");
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
        } else if (action.equals("getXpathTerms")) {
            String xpath = request.getParameter("xpath") == null ? "" : request.getParameter("xpath");
            DBCollection col = new DBCollection(this.DBURI, this.systemDbCollection, this.DBuser, this.DBpassword);
            String firstPart = xpath.split("/")[0];
            firstPart = firstPart + "[admin/lang='" + lang + "']";
            String secondPart = xpath.substring(xpath.indexOf("/") + 1, xpath.length());
            String q = "//" + firstPart + "/" + secondPart + "/text()";
            String[] terms = col.query(q);
            HashSet<String> list = null;
            List sortedList = new ArrayList();

            if (terms.length == 0) {
                list = new HashSet<String>();
                String word = "noData";
                String wT = Utils.getTranslationFromMultiLang(word, lang, "context");
                list.add(wT);
            } else {
                list = new HashSet<String>(Arrays.asList(terms));
                sortedList = new ArrayList(list);
                Collections.sort(sortedList);
            }
            try {
                /* TODO output your page here. You may use following sample code. */
                JSONObject jsonData = new JSONObject();
                jsonData.put("terms", sortedList);
                out.print(jsonData.toString());
            } finally {
                out.close();
            }
        } else if (action.equals("getXpathEntities")) {
            String xpath = request.getParameter("xpath") == null ? "" : request.getParameter("xpath");
            DBCollection col = new DBCollection(this.DBURI, this.systemDbCollection, this.DBuser, this.DBpassword);
            String firstPart = xpath.split("/")[0];
            firstPart = firstPart + "[admin/lang='" + lang + "']";
            String secondPart = xpath.substring(xpath.indexOf("/") + 1, xpath.length());
            String q = "data(//" + firstPart + "/" + secondPart + "[@sps_type!=\"\"]/@sps_type)";
            String[] entities = col.query(q);
            HashSet<String> list = null;
            if (entities.length == 0) {
                list = new HashSet<String>();
                String word = "noLinks";
                String wT = Utils.getTranslationFromMultiLang(word, lang, "context");
                list.add(null + "__" + wT);
            } else {
                list = new HashSet<String>();
                for (String e : entities) {
                    if (!e.equals("") && !list.contains(e)) {
                        String wT = Utils.getTranslationFromMultiLang(e, lang, "leftmenu");
                        list.add(e + "__" + wT);
                    }
                }
            }
            try {
                JSONObject jsonData = new JSONObject();
                jsonData.put("entities", list);
                out.print(jsonData.toString());
            } finally {
                out.close();
            }

        } else if (action.equals("getListOfTags")) {
            String category = request.getParameter("category") == null ? "" : request.getParameter("category");
            HttpSession session = request.getSession(true);
            session.removeAttribute(category + ".xpaths");
            ArrayList[] allListTags = QueryTools.getListOfTags(category, lang, session);

            try {
                JSONObject jsonData = new JSONObject();
                jsonData.put("xpaths", allListTags[0]);
                jsonData.put("labels", allListTags[1]);
                jsonData.put("dataTypes", allListTags[2]);
                jsonData.put("selectedTags", allListTags[3]);
                jsonData.put("vocTags", allListTags[4]);
                jsonData.put("thesTags", allListTags[5]);
                jsonData.put("linksTags", allListTags[6]);

                out.print(jsonData.toString());
            } finally {
                out.close();
            }
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
