/*
 * ============================================================
 * AdminServlet.java - Servlet untuk Admin
 * ============================================================
 * Updated untuk ERD Baru dengan database manyung
 * ============================================================
 */
package web;

import dao.DeviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import model.AdminBehavior;
import model.Device;

@WebServlet(name = "AdminServlet", urlPatterns = { "/AdminServlet" })
@MultipartConfig
public class AdminServlet extends HttpServlet implements AdminBehavior {

    private final String uploadDirectory = "C:/images_device";
    private DeviceDAO deviceDAO;

    public AdminServlet() {
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("showAllDevicesAdmin".equals(action)) {
            showAllDevices(request, response);
            String msg = request.getParameter("msg");
            if (msg != null) {
                switch (msg) {
                    case "edit":
                        response.sendRedirect("Pages/HalamanAdmin.jsp?msg=Device+berhasil+diubah");
                        break;
                    case "add":
                        response.sendRedirect("Pages/HalamanAdmin.jsp?msg=Device+berhasil+ditambah");
                        break;
                    case "del":
                        response.sendRedirect("Pages/HalamanAdmin.jsp?msg=Device+berhasil+dihapus");
                        break;
                    default:
                        break;
                }
            } else {
                response.sendRedirect("Pages/HalamanAdmin.jsp");
            }
        } else if ("showDeviceEdit".equals(action)) {
            ShowDevices(request, response);
            response.sendRedirect(request.getContextPath() + "/Pages/EditDevice.jsp");
        } else if ("deleteDevice".equals(action)) {
            deleteDevice(request, response);
        } else if ("invalid".equals(action)) {
            invalidSession(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String action = request.getParameter("action");

        if ("tambahDevice".equals(action)) {
            tambahDevice(request, response);
        } else if ("editDevice".equals(action)) {
            editDevice(request, response);
        }
    }

    @Override
    public void tambahDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract parameters from the request
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        int price = Integer.parseInt(request.getParameter("price"));
        String operatingSystem = request.getParameter("operatingSystem");
        String battery = request.getParameter("battery");
        String storage = (request.getParameter("storage"));
        int memory = Integer.parseInt(request.getParameter("memory"));
        String display = request.getParameter("display");
        String graphicsCard = request.getParameter("graphicsCard");
        String graphicsCardType = request.getParameter("graphicsCardType");
        String processor = request.getParameter("processor");
        String url = request.getParameter("url");

        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();
        String filePath = uploadDirectory + File.separator + fileName;

        // Save the file to the server4
        File fileSaveDir = new File(uploadDirectory);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs(); // Create the directory if it does not exist
        }
        filePart.write(filePath);

        // Relative path to store in the database
        String relativePath = "images_device/" + fileName;
        // Call the DAO to insert the device into the database
        boolean deviceAdded = deviceDAO.insertDevice(
                name, brand, category, price, operatingSystem, battery,
                storage, memory, display, graphicsCard, graphicsCardType,
                processor, url, relativePath);

        // Handle the result of the operation
        if (deviceAdded) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=showAllDevicesAdmin&msg=add");

        } else {
            response.sendRedirect("Pages/HalamanAdmin.jsp?error=Device+gagal+ditambahkan");
        }
    }

    @Override
    public void editDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract parameters from the request
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        int price = Integer.parseInt(request.getParameter("price"));
        String operatingSystem = request.getParameter("operatingSystem");
        String battery = request.getParameter("battery");
        String storage = (request.getParameter("storage"));
        int memory = Integer.parseInt(request.getParameter("memory"));
        String display = request.getParameter("display");
        String graphicsCard = request.getParameter("graphicsCard");
        String graphicsCardType = request.getParameter("graphicsCardType");
        String processor = request.getParameter("processor");
        String url = request.getParameter("url");
        String idDevice = request.getParameter("idDevice");
        int id = Integer.parseInt(idDevice);

        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();
        String filePath = uploadDirectory + File.separator + fileName;

        // Save the file to the server4
        File fileSaveDir = new File(uploadDirectory);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs(); // Create the directory if it does not exist
        }
        filePart.write(filePath);

        // Relative path to store in the database
        String relativePath = "images_device/" + fileName;
        // Call the DAO to insert the device into the database
        boolean deviceEdited = deviceDAO.editDevice(id,
                name, brand, category, price, operatingSystem, battery,
                storage, memory, display, graphicsCard, graphicsCardType,
                processor, url, relativePath);

        // Handle the result of the operation
        if (deviceEdited) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=showAllDevicesAdmin&msg=edit");
        } else {
            response.sendRedirect("Pages/HalamanAdmin.jsp?error=Device+gagal+diubah");
        }
    }

    @Override
    public void deleteDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idDevice = request.getParameter("idDevice");

        try {
            int deviceId = Integer.parseInt(idDevice);

            // Call the DAO to delete the device
            boolean isDeleted = deviceDAO.deleteDevice(deviceId);

            if (isDeleted) {
                // If successful, redirect to the admin page with updated device list
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=showAllDevicesAdmin&msg=del");
            } else {
                // If failed, redirect to the admin page with an error message
                response.sendRedirect("Pages/HalamanAdmin.jsp?error=Device+gagal+dihapus");
            }
        } catch (NumberFormatException e) {
            // Handle invalid device ID format
            response.sendRedirect("Pages/HalamanAdmin.jsp?error=ID+perangkat+tidak+valid");
        }
    }

    protected void showAllDevices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Device> devices = deviceDAO.showAllDevices();

        if (devices == null || devices.isEmpty()) {
            request.getSession().setAttribute("allDevices", null);
        } else {
            request.getSession().setAttribute("allDevices", devices);
        }
    }

    public void invalidSession(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Pages/login.jsp?error=Session+invalid,+silakan+login+kembali");
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
