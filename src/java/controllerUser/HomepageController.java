/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import dao.AboutSectionDAO;
import dao.ContactInfoDAO;
import dao.CourtDAO;
import dao.InstagramFeedDAO;
import dao.OfferDAO;
import dao.SliderDAO;
import dao.VideoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.AboutSectionDTO;
import models.ContactInfoDTO;
import models.CourtDTO;
import models.InstagramFeedDTO;
import models.OfferDTO;
import models.SliderDTO;
import models.VideoDTO;

public class HomepageController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Homepage</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Homepage at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CourtDAO courtDAO = new CourtDAO();
        String search = request.getParameter("search");
        String pageParam = request.getParameter("page");
        String status = request.getParameter("status");
        String courtType = request.getParameter("courtType");
        SliderDAO sliderDAO = new SliderDAO();
        AboutSectionDAO aboutDAO = new AboutSectionDAO();
        VideoDAO videoDAO = new VideoDAO();
        OfferDAO offerDAO = new OfferDAO();
        ContactInfoDAO contactDAO = new ContactInfoDAO();
        InstagramFeedDAO dao = new InstagramFeedDAO();

        List<SliderDTO> sliders = sliderDAO.getAllActiveSliders();
        
        List<AboutSectionDTO> aboutSections = new ArrayList<>();
        try {
            aboutSections = aboutDAO.getAllActiveSections();
        } catch (SQLException e) {
            e.printStackTrace();
            aboutSections = new ArrayList<>();
        }
        
        List<VideoDTO> videoList = new ArrayList<>();
        try {
            videoList = videoDAO.getAllVideos(1, 100, null, null);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error loading videos: " + e.getMessage());
        }
        List<OfferDTO> allOffers = new ArrayList<>();
        try {
            allOffers = offerDAO.getActiveOffers();
        } catch (Exception e) {
            e.printStackTrace();
        }
        List<ContactInfoDTO> contactInfos = contactDAO.getAllActiveContactInfo();
        List<InstagramFeedDTO> visibleFeeds = new ArrayList<>();
        try {
            List<InstagramFeedDTO> allFeeds = dao.getAllFeeds(1, 100, null, null);
            visibleFeeds = allFeeds.stream()
                    .filter(InstagramFeedDTO::getIsVisible)
                    .limit(5)
                    .toList();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (videoList != null && !videoList.isEmpty()) {
            request.setAttribute("video", videoList.get(0)); 
            System.out.println("Video loaded: " + videoList.get(0).getTitle());
        } else {
            System.out.println("No videos found in database");
        }

        int maxOffersToShow = 3;
        List<OfferDTO> displayedOffers = allOffers.size() > maxOffersToShow
                ? allOffers.subList(0, maxOffersToShow)
                : allOffers;

        int page = 1;
        int courtsPerPage = 2;

        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        
        List<CourtDTO> courts = courtDAO.filterCourts(search, status, courtType);

        if (courts == null || courts.isEmpty()) {
            request.setAttribute("message", "No court found");
        } else {
            int totalCourts = courts.size();
            int totalPages = (int) Math.ceil((double) totalCourts / courtsPerPage);

            if (page < 1) {
                page = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            int start = (page - 1) * courtsPerPage;
            int end = Math.min(start + courtsPerPage, totalCourts);
            List<CourtDTO> pagedCourts = courts.subList(start, end);

            request.setAttribute("courts", pagedCourts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }

        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("courtType", courtType);
        request.setAttribute("sliders", sliders);
        request.setAttribute("aboutSections", aboutSections);
        request.setAttribute("offers", displayedOffers);
        request.setAttribute("contactInfos", contactInfos);
        request.setAttribute("instagramFeeds", visibleFeeds);

        request.getRequestDispatcher("homepage.jsp").forward(request, response);
    }

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
