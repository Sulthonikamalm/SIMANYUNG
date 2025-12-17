/*
 * ============================================================
 * Admin.java - Child Class (extends User)
 * ============================================================
 * Deskripsi: Kelas Admin yang mewarisi dari User
 *            Untuk model data Admin
 * ============================================================
 */
package model;

import dao.DeviceDAO;
import java.util.ArrayList;

public class Admin extends User {

    // ========================================
    // ATRIBUT TAMBAHAN (Spesifik Admin)
    // ========================================
    private int adminId;

    // ========================================
    // CONSTRUCTORS
    // ========================================

    /**
     * Default Constructor
     */
    public Admin() {
        super();
        this.setUserType("admin");
    }

    /**
     * Constructor dengan parameter dari User parent
     */
    public Admin(int id, String email, String password) {
        super(id, email, password, "admin");
    }

    /**
     * Constructor lengkap
     */
    public Admin(int id, int adminId, String username, String email, String password) {
        super(id, email, password, "admin");
        this.adminId = adminId;
        this.setUsername(username);
    }

    // ========================================
    // METHOD TAMBAHAN
    // ========================================

    /**
     * Method untuk menambahkan device
     */
    public boolean addDeviceData(Device device) {
        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            return deviceDAO.insertDevice(device);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method untuk menghapus device
     */
    public boolean removeDeviceData(int deviceId) {
        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            return deviceDAO.deleteDevice(deviceId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method untuk mengedit device
     */
    public boolean editDeviceData(Device device) {
        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            return deviceDAO.updateDevice(device);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method DeviceComparison
     */
    public ArrayList<Device> DeviceComparison(Device device1, Device device2) {
        ArrayList<Device> comparisonList = new ArrayList<>();
        comparisonList.add(device1);
        comparisonList.add(device2);
        return comparisonList;
    }

    // ========================================
    // GETTERS
    // ========================================

    public int getAdminId() {
        return adminId;
    }

    // ========================================
    // SETTERS
    // ========================================

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    // ========================================
    // OVERRIDE METHODS
    // ========================================

    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", username='" + getUsername() + '\'' +
                ", id=" + id +
                ", email='" + email + '\'' +
                '}';
    }
}
