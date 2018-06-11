/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package isl.FIMS.servlet.ui;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.ApplicationConfig;
import isl.dms.DMSException;
import isl.dms.xml.XMLTransform;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
public class Privacy extends ApplicationBasicServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = (String) request.getParameter("action") == null ? "" : (String) request.getParameter("action");
        String lang = (String) request.getParameter("lang") == null ? "" : (String) request.getParameter("lang");

        PrintWriter out = response.getWriter();

        StringBuffer xml = new StringBuffer();
        xml.append(this.xmlStart(lang));
        xml.append("<action>").append(action).append("</action>");
        xml.append("<lang>").append(lang).append("</lang>");

        xml.append(xmlEnd());
        try {
            XMLTransform xmlTrans = new XMLTransform(xml.toString());
            xmlTrans.transform(out, ApplicationConfig.SYSTEM_ROOT + "formating/xsl/ui/privacy.xsl");
        } catch (DMSException e) {
            e.printStackTrace();
        }
        out.close();
    }

    public String xmlStart(String lang) {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                + "<page language=\"" + lang + "\">\n"
                + "<header>\n"
                + "</header>\n"
                + "<topmenu>\n"
                + "</topmenu>\n"
                + "<leftmenu>\n"
                + "</leftmenu>\n" + "<context>\n";
    }// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

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
