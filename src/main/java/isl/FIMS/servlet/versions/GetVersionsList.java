/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package isl.FIMS.servlet.versions;

import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.FIMS.utils.Messages;
import isl.FIMS.utils.entity.Config;
import isl.FIMS.utils.entity.XMLEntity;
import isl.dbms.DBCollection;
import isl.dms.DMSException;
import isl.dms.xml.XMLTransform;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author konsolak
 */
public class GetVersionsList extends ApplicationBasicServlet {

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
        response.setContentType("text/xml");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        this.initVars(request);

        String type = request.getParameter("type");
        Config conf = new Config(type);
        String fileId = request.getParameter("id");
        String id = fileId.split(type)[1];

        StringBuffer resultsTag = new StringBuffer("<results>\n");
        XMLEntity xmlE = new XMLEntity(this.DBURI, this.systemDbCollection + type, this.DBuser, this.DBpassword, type, fileId);

        try {

            DBCollection versionColOfId = new DBCollection(this.DBURI, this.versionDbCollection + type + "/" + fileId, this.DBuser, this.DBpassword);
            String query = "for $i in collection('" + versionColOfId.getName() + "')\n"
                    + "where util:document-name($i) = '" + fileId + ".xml'\n"
                    + "order by $i//admin//versionId/text() descending\n"
                    + "return\n"
                    + "<result>\n"
                    + "<versionId>{$i//admin//versionId/text()}</versionId>\n"
                    + "<versionUser>{$i//admin//versionUser/text()}</versionUser>\n"
                    + "<versionDate>{$i//admin//versionDate/text()}</versionDate>\n"
                    + "<comment>{$i//admin//versions/comment/text()}</comment>\n"
                    + "</result>\n";

            String[] queryRes = versionColOfId.query(query);
            for (int j = 0; j < queryRes.length; j++) {
                resultsTag.append(queryRes[j]).append("\n");
            }

            String nameValue = xmlE.queryString("//admin/uri_id/text()")[0];

        } catch (isl.dbms.DBMSException e) {
        }
            resultsTag.append("\n</results>\n");

        out.println(resultsTag);

        out.close();
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
