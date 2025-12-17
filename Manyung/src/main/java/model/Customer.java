/*
 * ============================================================
 * Customer.java - Child Class (extends User)
 * ============================================================
 * Deskripsi: Kelas Customer yang mewarisi dari User
 *            Untuk model data Customer (end-user)
 * ============================================================
 */
package model;

import dao.DeviceDAO;
import dao.PreferenceDAO;
import java.util.ArrayList;
import java.util.List;

public class Customer extends User {

    // ========================================
    // ATRIBUT TAMBAHAN (Spesifik Customer)
    // ========================================
    private int customerId;
    private List<Preference> preferences;

    // ========================================
    // CONSTRUCTORS
    // ========================================

    /**
     * Default Constructor
     */
    public Customer() {
        super();
        this.setUserType("customer");
        this.preferences = new ArrayList<>();
    }

    /**
     * Constructor dengan parameter dari User parent
     */
    public Customer(int id, String email, String password) {
        super(id, email, password, "customer");
        this.preferences = new ArrayList<>();
    }

    /**
     * Constructor lengkap
     */
    public Customer(int id, int customerId, String username, String email, String password) {
        super(id, email, password, "customer");
        this.customerId = customerId;
        this.setUsername(username);
        this.preferences = new ArrayList<>();
    }

    // ========================================
    // METHOD REGISTER
    // ========================================

    /**
     * Method untuk registrasi customer baru
     */
    public static Customer register(String username, String email, String password) {
        Customer newCustomer = new Customer();
        newCustomer.setUsername(username);
        newCustomer.setEmail(email);
        newCustomer.setPassword(password);
        return newCustomer;
    }

    // ========================================
    // SEARCH DEVICE
    // ========================================

    /**
     * Method untuk mencari device berdasarkan nama
     */
    public ArrayList<Device> searchDevice(String deviceName) {
        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            return new ArrayList<>(deviceDAO.searchDevice(deviceName));
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ========================================
    // FILTER BY CATEGORY
    // ========================================

    /**
     * Method untuk filter device berdasarkan kategori
     */
    public ArrayList<Device> filterByCriteria(String category) {
        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            return new ArrayList<>(deviceDAO.selectFilter(category));
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ========================================
    // DEVICE COMPARISON
    // ========================================

    /**
     * Method untuk membandingkan device
     */
    public String deviceComparison(String deviceIds) {
        if (deviceIds == null || deviceIds.trim().isEmpty()) {
            return "Tidak ada device untuk dibandingkan";
        }

        try {
            DeviceDAO deviceDAO = new DeviceDAO();
            String[] ids = deviceIds.split(",");
            StringBuilder comparison = new StringBuilder();
            comparison.append("=== PERBANDINGAN DEVICE ===\n\n");

            for (String id : ids) {
                int deviceId = Integer.parseInt(id.trim());
                Device device = deviceDAO.selectDevice(deviceId);

                if (device != null) {
                    comparison.append("Device: ").append(device.getName()).append("\n");
                    comparison.append("Brand: ").append(device.getBrand()).append("\n");
                    comparison.append("Price: Rp ").append(String.format("%,d", device.getPrice())).append("\n");
                    comparison.append("-----------------------------------\n\n");
                }
            }

            return comparison.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error dalam perbandingan device";
        }
    }

    // ========================================
    // METHOD PREFERENCE (Composition)
    // ========================================

    /**
     * Tambahkan preference baru untuk customer
     */
    public boolean addPreference(Preference preference) {
        try {
            if (preference != null) {
                preference.setCustomerId(this.customerId);
                this.preferences.add(preference);

                PreferenceDAO prefDAO = new PreferenceDAO();
                return prefDAO.insertPreference(preference);
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Dapatkan rekomendasi device berdasarkan preference
     */
    public ArrayList<Device> getDeviceRecommendation() {
        try {
            Preference pref = this.getPreference();
            if (pref == null) {
                return new ArrayList<>();
            }

            DeviceDAO deviceDAO = new DeviceDAO();
            return deviceDAO.getDevicesByPreference(
                    pref.getProcessor(),
                    pref.getGraphicsCardType(),
                    pref.getMemory());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ========================================
    // GETTERS
    // ========================================

    public int getCustomerId() {
        return customerId;
    }

    public List<Preference> getPreferences() {
        return preferences;
    }

    // ========================================
    // SETTERS
    // ========================================

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public void setPreferences(List<Preference> preferences) {
        this.preferences = preferences;
    }

    // ========================================
    // OVERRIDE METHODS
    // ========================================

    @Override
    public String toString() {
        return "Customer{" +
                "customerId=" + customerId +
                ", username='" + getUsername() + '\'' +
                ", id=" + id +
                ", email='" + email + '\'' +
                '}';
    }
}
