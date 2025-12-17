package web;

import dao.DeviceDAO;
import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import model.Device;
import model.Preference;
import model.User;

@WebServlet(name = "DeviceServlet", urlPatterns = {"/DeviceServlet"})
@MultipartConfig
public class DeviceServlet extends HttpServlet {

    private UserDAO userDAO;
    private DeviceDAO deviceDAO;

    public DeviceServlet() {
        userDAO = new UserDAO();
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("invalid".equals(action)) {
            invalidSession(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
    }

    public void invalidSession(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Pages/login.jsp?error=Session+invalid,+silakan+login+kembali");
    }

    protected void ShowDevices(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int device_id = Integer.parseInt(request.getParameter("idDevices"));

        Device singleDevice = deviceDAO.selectDevice(device_id);
        if (singleDevice == null) {
            request.getSession().setAttribute("singleDevice", null);
        } else {
            request.getSession().setAttribute("singleDevice", singleDevice);
        }
    }
}
