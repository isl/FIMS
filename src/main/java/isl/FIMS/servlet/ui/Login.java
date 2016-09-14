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
package isl.FIMS.servlet.ui;

import isl.FIMS.utils.ApplicationConfig;
import isl.FIMS.servlet.ApplicationBasicServlet;
import isl.dbms.DBCollection;
import isl.dms.DMSException;
import isl.dms.file.DMSFile;
import isl.dms.file.DMSUser;
import isl.dms.xml.XMLTransform;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet used to check if the user is authorized in order to login to the system
 * @author konsolak
 */
public class Login extends ApplicationBasicServlet {

    /**
     * Creates the header of the Login page 
     * @param user : username
     * @param title : title of the page
     * @param lang : the selected language 
     * @param mode 
     * @return
     */
    public String xmlStart(String user, String title, String lang, String mode) {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                + "<page user=\"" + user + "\" title=\"" + title + "\" language=\"" + lang + "\" mode=\"" + mode + "\">\n"
                /*+ "<systemRoot>" + ApplicationConfig.SYSTEM_ROOT + "</systemRoot>\n"*/
                + "<header>\n"
                + "</header>\n"
                + "<topmenu>\n"
                + "</topmenu>\n"
                + "<leftmenu>\n"
                + "</leftmenu>\n" + "<context>\n";
    }

    /**
     * Serves the get request to check if the user is authorized to login to the system
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String lang = request.getParameter("lang");
        String signUp = getServletContext().getInitParameter("signUp");
        String forgetPass = getServletContext().getInitParameter("forgetPass");

        if (lang == null) {
            lang = this.getLang(request);
        }

        if (lang.equals("")) {
            lang = this.defaultLang; //default
        }
        StringBuffer xml = new StringBuffer();

        String username = this.getUsername(request);

        String comment = "";
        DMSFile df = new DMSFile(this.conf.USERS_FILE, this.conf);
        try {

            String temp[] = df.queryString("/DMS/users/user[./@username='" + username + "']/info/comment/text()");
            if (temp.length > 0) {
                comment = temp[0];
            }
        } catch (DMSException ex) {
        }

        if (username != null) {
            if (!username.equals("")) {
                if (defaultEntity.equals("")) {
                    response.sendRedirect("FirstPage");
                } else if (!defaultEntity.equals("") && comment.equals("firstLogin")) {
                    try {
                        DMSUser user = new DMSUser(username, conf);
                        user.setInfo("comment", "");
                    } catch (DMSException ex) {
                    }
                    response.sendRedirect("FirstPage");
                } else {
                    response.sendRedirect("ListEntity?type=" + defaultEntity);
                }
            }
        }

        // Create xml output
        String xmlStart = this.xmlStart(username, "LoginPageTitle", lang, "");
        String xmlEnd = this.xmlEnd();

        StringBuffer xmlMiddle = new StringBuffer();
        String error = request.getParameter("error");

        String errorMsg = "";

        if (error != null && error.equals("1")) {
            //Wrong username or password
            HttpSession session = request.getSession();

            errorMsg = (String) session.getAttribute("errorMsg");
            session.invalidate();
        }

        xmlMiddle.append("<ErrorMsg>").append(errorMsg).append("</ErrorMsg>");

        xml.append(xmlStart);
        xml.append(xmlMiddle);
        xml.append("<Langs>\n");
        for (String systemLang : this.systemLangs) {
            xml.append("<Lang>");
            xml.append(systemLang);
            xml.append("</Lang>\n");
        }

        xml.append("</Langs>\n");
        xml.append("<signUp>" + signUp + "</signUp>");
        xml.append("<forgetPass>" + forgetPass + "</forgetPass>");

        xml.append(xmlEnd);

        String xsl = ApplicationConfig.LOGIN_XSL;
        try {
            XMLTransform xmlTrans = new XMLTransform(xml.toString());

            xmlTrans.transform(out, xsl);
        } catch (DMSException e) {
            e.printStackTrace();
        }
        out.close();
    }

    /**
     * Serves the post request to check if the user is authorized to login to the system
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String status = "";
        String signUp = getServletContext().getInitParameter("signUp");
        String forgetPass = getServletContext().getInitParameter("forgetPass");

        boolean isUserValid = false;
        try {
            isUserValid = DMSUser.checkUser(username, password, this.conf);

        } catch (DMSException e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession(true);
        if (isUserValid == true) {
            String lang = request.getParameter("lang");
            if (lang == null) {
                lang = this.getLang(request);
            }
            SetLanguage.setLang(lang);
            String colName = this.systemDbCollection + "DMSFILES/applicationFiles/management_xmlFiles";
            DBCollection col = new DBCollection(this.DBURI, colName, this.DBuser, this.DBpassword);
            String topSettings = this.getXMLPart("topmenu", col);
            String leftmenu = this.getXMLPart("leftmenu", col);
            String actionsMenu = this.getXMLPart("actionsMenu", col);
            session.setAttribute("username", username);
            session.setAttribute("lang", lang);
            session.setAttribute("userIP", request.getRemoteAddr());
            session.setAttribute("topSettings", topSettings);
            session.setAttribute("leftmenu", leftmenu);
            session.setAttribute("actionsMenu", actionsMenu);
            String browserInfo = request.getHeader("user-agent");

            if (browserInfo.contains("MSIE")) {
                session.setAttribute("browser", "IE");
            } else if (browserInfo.contains("Firefox")) {
                session.setAttribute("browser", "Firefox");
            }
            initVars(request);
            String sessionId = session.getId();
            String encodeUsername = URLEncoder.encode(username);
            for (String editor : this.editorWebapp) {
                Cookie cookie = new Cookie(encodeUsername, sessionId);
                cookie.setPath("/" + editor);
                cookie.setMaxAge(10800);
                response.addCookie(cookie);
            }
            if (userHasAction("guest", username)) {
                status = "org";
            } else {
                status = "allunpublished";
            }
            StringBuffer xml = new StringBuffer(this.xmlStart(this.topmenu, username, this.pageTitle, this.lang, "", request));
            xml.append("<Langs>\n");
            for (String systemLang : this.systemLangs) {
                xml.append("<Lang>");
                xml.append(systemLang);
                xml.append("</Lang>\n");
            }

            xml.append("</Langs>\n");
            xml.append("<signUp>" + signUp + "</signUp>");
            xml.append("<forgetPass>" + forgetPass + "</forgetPass>");

            xml.append(this.xmlEnd());

            String comment = "";
            DMSFile df = new DMSFile(this.conf.USERS_FILE, this.conf);
            try {
                String temp[] = df.queryString("/DMS/users/user[./@username='" + username + "']/info/comment/text()");
                if (temp.length > 0) {
                    comment = temp[0];
                }
            } catch (DMSException ex) {
            }

            if (defaultEntity.equals("")) {
                response.sendRedirect("FirstPage");
            } else if (!defaultEntity.equals("") && comment.equals("firstLogin")) {
                try {
                    DMSUser user = new DMSUser(username, conf);
                    user.setInfo("comment", "");
                } catch (DMSException ex) {
                }
                response.sendRedirect("FirstPage");
            } else {
                response.sendRedirect("ListEntity?type=" + defaultEntity);
            }
        } else {
            String errorMsg = "UserInvalid";
            session.setAttribute("errorMsg", errorMsg);
            //session.invalidate();
            response.sendRedirect("Login?error=1");
        }
    }
}
