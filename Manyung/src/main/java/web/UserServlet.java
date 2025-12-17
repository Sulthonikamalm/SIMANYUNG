/*
 * ============================================================
 * UserServlet.java - Servlet untuk User/Customer
 * ============================================================
 * Updated untuk ERD Baru dengan database manyung
 * ============================================================
 */
package web;

import dao.DeviceDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Device;
import model.Preference;
import model.User;
import model.UserBehavior;

@WebServlet(name = "UserServlet", urlPatterns = { "/UserServlet" })
public class UserServlet extends HttpServlet implements UserBehavior {

    private UserDAO userDAO;
    private DeviceDAO deviceDAO;

    public UserServlet() {
        userDAO = new UserDAO();
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            Login(request, response);
        } else if ("InsertPreference".equals(action)) {
            UpdatePreference(request, response);
        } else if ("register".equals(action)) {
            Register(request, response);
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "login":
                Login(request, response);
                break;
            case "logout":
                Logout(request, response);
                break;
            case "invalid":
                invalidSession(request, response);
                break;
            case "rekomendasiDevice":
                getRekomendasiDevice(request, response);
                break;
            case "filterByCategory":
                getDeviceByCategory(request, response);
                break;
            case "searchDevice":
                searchDevice(request, response);
                break;
            case "compareDevices":
                compareDevices(request, response);
                break;
            case "showDevices":
                ShowDevices(request, response);
                response.sendRedirect(request.getContextPath() + "/Pages/showDevice.jsp");
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
                break;
        }

    }

    public void invalidSession(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Pages/login.jsp?error=Session+invalid,+silakan+login+kembali");
    }

    protected void Login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean validateUser = userDAO.validateUser(email, password);
        boolean validateAdmin = userDAO.validateAdmin(email, password);

        if (validateUser) {
            User user = userDAO.selectUser(email, password);
            request.getSession().setAttribute("user", user);
            int id = user.getUser_id();
            Preference preference = userDAO.selectPreference(id);
            user.setPreference(preference);
            response.sendRedirect("Pages/homeAfterLogin.jsp");

        } else if (validateAdmin) {
            User user = userDAO.selectUser(email, password);
            User admin = userDAO.selectUser(email, password);
            request.getSession().setAttribute("admin", admin);
            request.getSession().setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=showAllDevicesAdmin");

        } else {
            response.sendRedirect("Pages/login.jsp?error=username+atau+password+salah");
        }
    }

    protected void Logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Redirect ke halaman login
        response.sendRedirect("http://localhost:8080/Manyung");
    }

    protected void Register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean validateUser = userDAO.insertUser(user, email, password);

        if (validateUser) {
            response.sendRedirect("Pages/login.jsp?regMsg=Register+berhasil");
        } else {
            response.sendRedirect("Pages/registration.jsp?error=Username+sudah+ada");
        }
    }

    @Override
    public void UpdatePreference(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String processor = request.getParameter("processor");
        String graphics = request.getParameter("graphics");
        String memory = request.getParameter("memory");
        User user = (User) request.getSession().getAttribute("user");
        int user_id = user.getUser_id();
        Preference preference = userDAO.selectPreference(user_id);
        if (preference != null) {
            try {
                boolean cekMasuk = userDAO.updatePreference(user_id, processor, graphics, memory);
            } catch (SQLException ex) {
                Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            try {
                boolean cekMasuk = userDAO.insertPreference(user_id, processor, graphics, memory);
            } catch (SQLException ex) {
                Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        preference = userDAO.selectPreference(user_id);

        user.setPreference(preference);

        request.getSession().setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/UserServlet?action=rekomendasiDevice");
    }

    protected void updateFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filter = request.getParameter("");
        User user = (User) request.getSession().getAttribute("user");

        request.getSession().setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/DeviceServlet?action=rekomendasiDevice");
    }

    @Override
    public void getRekomendasiDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user from session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/DeviceServlet?action=invalid");
        } else {
            // Get user preferences
            Preference preference = user.getPreference();
            String email = user.getEmail();
            String pass = user.getPassword();
            boolean isAdmin = userDAO.validateAdmin(email, pass);
            if (preference == null && !isAdmin) {
                response.sendRedirect(request.getContextPath() + "/DeviceServlet?action=invalid");
            } else {
                if (!isAdmin) {
                    List<Device> devices = deviceDAO.getRecommendedDevice(
                            preference.getProcessor(),
                            preference.getGraphicsCardType(),
                            preference.getMemory(),
                            isAdmin);
                    request.getSession().setAttribute("displayDevice", devices);
                    response.sendRedirect(request.getContextPath()
                            + "/Pages/rekomendasiDevice.jsp?Preference=Menampilkan+device+dengan+preference:"
                            + "+prosesor+'" + preference.getProcessor() + ",'+jenis+kartu+'"
                            + preference.getGraphicsCardType() + "',+dan+memori+'" + preference.getMemory() + "'+GB");
                } else {
                    List<Device> devices = deviceDAO.getRecommendedDevice(
                            "",
                            "",
                            0,
                            isAdmin);
                    request.getSession().setAttribute("displayDevice", devices);
                    response.sendRedirect(request.getContextPath()
                            + "/Pages/rekomendasiDevice.jsp?Preference=Menampilkan semua device");
                }
            }
        }
    }

    @Override
    public void getDeviceByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");

        List<Device> FilteredDevices = deviceDAO.selectFilter(category);
        if (FilteredDevices == null || FilteredDevices.isEmpty()) {
            request.getSession().setAttribute("displayDevice", null);
        } else {
            request.getSession().setAttribute("displayDevice", FilteredDevices);
        }

        response.sendRedirect(request.getContextPath() + "/Pages/rekomendasiDevice.jsp?Filter=" + category);

    }

    protected void searchDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deviceName = request.getParameter("deviceName");

        if (deviceName == null || deviceName.trim().isEmpty()) {
            request.getSession().setAttribute("displayDevice", null);
            response.sendRedirect(
                    request.getContextPath() + "/Pages/rekomendasiDevice.jsp?error=Nama+device+tidak+boleh+kosong");
            return;
        }

        List<Device> searchResult = deviceDAO.searchDevice(deviceName);

        if (searchResult == null || searchResult.isEmpty()) {
            request.getSession().setAttribute("displayDevice", null);
            response.sendRedirect(request.getContextPath() + "/Pages/rekomendasiDevice.jsp?error=Device+dengan+query+'"
                    + deviceName + "'+tidak+ditemukan");
        } else {
            request.getSession().setAttribute("displayDevice", searchResult);
            response.sendRedirect(request.getContextPath() + "/Pages/rekomendasiDevice.jsp?Query=" + deviceName);
        }
    }

    protected void compareDevices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] deviceIds = request.getParameterValues("deviceIds");
        // Retrieve the selected device IDs

        if (deviceIds != null) {
            List<Device> selectedDevices = new ArrayList<>();
            for (String id : deviceIds) {
                // Fetch each device from the database or service
                Device device = deviceDAO.selectDevice(Integer.parseInt(id));
                selectedDevices.add(device);
            }

            // Forward the list to another JSP page
            request.getSession().setAttribute("selectedDevices", selectedDevices);
            response.sendRedirect("Pages/compare.jsp");
        }
    }

    protected void ShowDevices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int device_id = Integer.parseInt(request.getParameter("idDevices"));

        Device singleDevice = deviceDAO.selectDevice(device_id);
        if (singleDevice == null) {
            request.getSession().setAttribute("singleDevice", null);
        } else {
            request.getSession().setAttribute("singleDevice", singleDevice);
        }
    }
}
