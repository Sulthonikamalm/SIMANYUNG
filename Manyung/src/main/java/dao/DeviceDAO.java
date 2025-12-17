/*
 * ============================================================
 * DeviceDAO.java - Data Access Object untuk Device
 * ============================================================
 * Deskripsi: DAO untuk operasi database pada tabel device
 *            Database: manyung
 * 
 * CATATAN: Tabel device TIDAK BERUBAH strukturnya
 * ============================================================
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Device;

public class DeviceDAO {

    // ========================================
    // DATABASE CONNECTION SETTINGS
    // ========================================
    // Database manyung
    private final String url = "jdbc:mysql://localhost:3306/manyung";
    private final String user = "root";
    private final String pasword = "";

    // ========================================
    // CONSTRUCTOR
    // ========================================

    public DeviceDAO() {
    }

    // ========================================
    // SHOW ALL DEVICES
    // ========================================

    public List<Device> showAllDevices() {
        List<Device> devices = new ArrayList<>();
        String sql = "SELECT * FROM device";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;
    }

    // ========================================
    // GET RECOMMENDED DEVICES
    // ========================================

    public List<Device> getRecommendedDevice(String processor, String GpuType, int RAM, boolean isAdmin) {
        List<Device> devices = new ArrayList<>();
        String sql;

        // Query based on isAdmin flag
        if (isAdmin) {
            sql = "SELECT * FROM device";
        } else {
            sql = "SELECT * FROM device WHERE processor LIKE ? AND graphicsCardType LIKE ? AND memory >= ?";
        }

        // Database connection
        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Set parameters for non-admin query
            if (!isAdmin) {
                stmt.setString(1, "%" + processor + "%");
                stmt.setString(2, "%" + GpuType + "%");
                stmt.setInt(3, RAM);
            }

            // Execute query
            ResultSet rs = stmt.executeQuery();

            // Process results
            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;
    }

    // ========================================
    // GET DEVICES BY PREFERENCE (NEW METHOD)
    // ========================================

    /**
     * Get devices berdasarkan preference customer
     * Digunakan untuk rekomendasi device
     * 
     * @param processor        Tipe processor yang diinginkan
     * @param graphicsCardType Tipe graphics card (Dedicated/Integrated)
     * @param memory           Minimum memory yang diinginkan
     * @return ArrayList device yang sesuai
     */
    public ArrayList<Device> getDevicesByPreference(String processor, String graphicsCardType, int memory) {
        ArrayList<Device> devices = new ArrayList<>();
        String sql = "SELECT * FROM device WHERE " +
                "(processor LIKE ? OR graphicsCardType = ? OR memory >= ?) " +
                "ORDER BY " +
                "CASE WHEN processor LIKE ? THEN 1 ELSE 0 END + " +
                "CASE WHEN graphicsCardType = ? THEN 1 ELSE 0 END + " +
                "CASE WHEN memory >= ? THEN 1 ELSE 0 END DESC, " +
                "price ASC";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + processor + "%");
            stmt.setString(2, graphicsCardType);
            stmt.setInt(3, memory);
            stmt.setString(4, "%" + processor + "%");
            stmt.setString(5, graphicsCardType);
            stmt.setInt(6, memory);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;
    }

    // ========================================
    // SELECT BY CATEGORY (FILTER)
    // ========================================

    public List<Device> selectFilter(String category) {
        String sql = "SELECT * FROM device WHERE category = ?";
        List<Device> devices = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;
    }

    // ========================================
    // SELECT SINGLE DEVICE BY ID
    // ========================================

    public Device selectDevice(int device_id) {
        String sql = "SELECT * FROM device WHERE device_id = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, device_id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDevice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Alias untuk selectDevice - untuk konsistensi naming
     */
    public Device getDeviceById(int deviceId) {
        return selectDevice(deviceId);
    }

    // ========================================
    // INSERT DEVICE
    // ========================================

    public boolean insertDevice(String name, String brand, String category, int price, String operatingSystem,
            String battery,
            String storage, int memory, String display, String graphicsCard, String graphicsCardType, String processor,
            String Url, String poster_url) {
        // SQL Query (excluding device_id)
        String sql = "INSERT INTO device (name, brand, category, price, operatingSystem, battery, storage, memory, display, graphicsCard, graphicsCardType, processor, url, poster_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection and prepare statement
            try (Connection conn = DriverManager.getConnection(url, user, pasword);
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Set values for the query parameters
                stmt.setString(1, name);
                stmt.setString(2, brand);
                stmt.setString(3, category);
                stmt.setInt(4, price);
                stmt.setString(5, operatingSystem);
                stmt.setString(6, battery);
                stmt.setString(7, storage);
                stmt.setInt(8, memory);
                stmt.setString(9, display);
                stmt.setString(10, graphicsCard);
                stmt.setString(11, graphicsCardType);
                stmt.setString(12, processor);
                stmt.setString(13, Url);
                stmt.setString(14, poster_url);

                // Execute the query and check for success
                return stmt.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
        }

        return false;
    }

    /**
     * Insert device using Device object
     * Method ini untuk interface AdminBehavior
     * 
     * @param device Device object
     * @return true jika berhasil
     */
    public boolean insertDevice(Device device) {
        return insertDevice(
                device.getName(),
                device.getBrand(),
                device.getCategory(),
                device.getPrice(),
                device.getOperatingSystem(),
                device.getBattery(),
                device.getStorage(),
                device.getMemory(),
                device.getDisplay(),
                device.getGraphicsCard(),
                device.getGraphicsCardType(),
                device.getProcessor(),
                device.getUrl(),
                device.getPoster_url());
    }

    // ========================================
    // EDIT/UPDATE DEVICE
    // ========================================

    public boolean editDevice(int device_id, String name, String brand, String category, int price,
            String operatingSystem, String battery,
            String storage, int memory, String display, String graphicsCard, String graphicsCardType, String processor,
            String Url, String poster_url) {

        // SQL Query for updating the device
        String sql = "UPDATE device SET name = ?, brand = ?, category = ?, price = ?, operatingSystem = ?, battery = ?, "
                + "storage = ?, memory = ?, display = ?, graphicsCard = ?, graphicsCardType = ?, processor = ?, url = ?, poster_url = ? "
                + "WHERE device_id = ?";

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection and prepare statement
            try (Connection conn = DriverManager.getConnection(url, user, pasword);
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Set values for the query parameters
                stmt.setString(1, name);
                stmt.setString(2, brand);
                stmt.setString(3, category);
                stmt.setInt(4, price);
                stmt.setString(5, operatingSystem);
                stmt.setString(6, battery);
                stmt.setString(7, storage);
                stmt.setInt(8, memory);
                stmt.setString(9, display);
                stmt.setString(10, graphicsCard);
                stmt.setString(11, graphicsCardType);
                stmt.setString(12, processor);
                stmt.setString(13, Url);
                stmt.setString(14, poster_url);
                stmt.setInt(15, device_id);

                // Execute the query and check for success
                return stmt.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
        }

        return false;
    }

    /**
     * Update device using Device object
     * Method ini untuk interface AdminBehavior
     * 
     * @param device Device object dengan data baru
     * @return true jika berhasil
     */
    public boolean updateDevice(Device device) {
        return editDevice(
                device.getDeviceId(),
                device.getName(),
                device.getBrand(),
                device.getCategory(),
                device.getPrice(),
                device.getOperatingSystem(),
                device.getBattery(),
                device.getStorage(),
                device.getMemory(),
                device.getDisplay(),
                device.getGraphicsCard(),
                device.getGraphicsCardType(),
                device.getProcessor(),
                device.getUrl(),
                device.getPoster_url());
    }

    // ========================================
    // SEARCH DEVICE
    // ========================================

    public List<Device> searchDevice(String name) {
        List<Device> devices = new ArrayList<>();
        String sql = "SELECT * FROM device WHERE name LIKE ? OR brand LIKE ?";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + name + "%");
            stmt.setString(2, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return devices;
    }

    // ========================================
    // DELETE DEVICE
    // ========================================

    public boolean deleteDevice(int device_id) {
        // SQL Query for deleting the device
        String sql = "DELETE FROM device WHERE device_id = ?";

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection and prepare statement
            try (Connection conn = DriverManager.getConnection(url, user, pasword);
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Set the device_id for the query
                stmt.setInt(1, device_id);

                // Execute the query and check for success
                return stmt.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
        }

        return false;
    }

    // ========================================
    // GET DISTINCT CATEGORIES
    // ========================================

    /**
     * Get semua kategori unik dari tabel device
     * 
     * @return ArrayList kategori
     */
    public ArrayList<String> getAllCategories() {
        ArrayList<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM device ORDER BY category";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category.trim());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    // ========================================
    // GET DISTINCT BRANDS
    // ========================================

    /**
     * Get semua brand unik dari tabel device
     * 
     * @return ArrayList brand
     */
    public ArrayList<String> getAllBrands() {
        ArrayList<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM device ORDER BY brand";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String brand = rs.getString("brand");
                if (brand != null && !brand.trim().isEmpty()) {
                    brands.add(brand.trim());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return brands;
    }

    // ========================================
    // COUNT DEVICES
    // ========================================

    /**
     * Get total jumlah device
     * 
     * @return jumlah device
     */
    public int getDeviceCount() {
        String sql = "SELECT COUNT(*) FROM device";

        try (Connection conn = DriverManager.getConnection(url, user, pasword);
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ========================================
    // HELPER METHOD
    // ========================================

    /**
     * Map ResultSet ke Device object
     * Mengurangi duplikasi kode
     */
    private Device mapResultSetToDevice(ResultSet rs) throws SQLException {
        int device_id = rs.getInt("device_id");
        String name = rs.getString("name");
        String brand = rs.getString("brand");
        String category = rs.getString("category");
        int price = rs.getInt("price");
        String operatingSystem = rs.getString("operatingSystem");
        String battery = rs.getString("battery");
        String storage = rs.getString("storage");
        int memory = rs.getInt("memory");
        String display = rs.getString("display");
        String graphicsCard = rs.getString("graphicsCard");
        String graphicsCardType = rs.getString("graphicsCardType");
        String processor = rs.getString("processor");
        String deviceUrl = rs.getString("url");
        String poster_url = rs.getString("poster_url");

        Device device = new Device(device_id, name, brand, category, price, operatingSystem,
                battery, storage, memory, display, graphicsCard, graphicsCardType, processor, poster_url);
        device.setUrl(deviceUrl);

        return device;
    }
}
