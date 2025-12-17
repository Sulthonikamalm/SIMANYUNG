/*
 * ============================================================
 * CustomerDAO.java - Data Access Object untuk Customer (BARU)
 * ============================================================
 * Deskripsi: DAO untuk operasi database pada tabel customer
 *            Database: manyung
 * 
 * Customer adalah "User" lama dari ERD 1
 * yang sekarang menjadi child class dari User
 * ============================================================
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Customer;
import model.Preference;

public class CustomerDAO {

    // ========================================
    // DATABASE CONNECTION SETTINGS
    // ========================================
    private static final String DB_URL = "jdbc:mysql://localhost:3306/manyung";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // ========================================
    // GET CONNECTION
    // ========================================

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }

    // ========================================
    // REGISTER CUSTOMER
    // ========================================

    /**
     * Register customer baru
     * Langkah:
     * 1. Insert ke tabel user dengan user_type = 'customer'
     * 2. Insert ke tabel customer dengan user_id dari langkah 1
     * 
     * @param customer Customer object
     * @return true jika berhasil
     */
    public boolean registerCustomer(Customer customer) {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Insert ke tabel user
            String sqlUser = "INSERT INTO user (email, password, user_type) VALUES (?, ?, 'customer')";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, customer.getEmail());
            stmtUser.setString(2, customer.getPassword());
            stmtUser.executeUpdate();

            // Get generated user ID
            ResultSet rsUser = stmtUser.getGeneratedKeys();
            int userId = -1;
            if (rsUser.next()) {
                userId = rsUser.getInt(1);
            }

            if (userId == -1) {
                conn.rollback();
                return false;
            }

            // Step 2: Insert ke tabel customer
            String sqlCustomer = "INSERT INTO customer (user_id, username) VALUES (?, ?)";
            PreparedStatement stmtCustomer = conn.prepareStatement(sqlCustomer, Statement.RETURN_GENERATED_KEYS);
            stmtCustomer.setInt(1, userId);
            stmtCustomer.setString(2, customer.getUsername());
            stmtCustomer.executeUpdate();

            // Get generated customer ID
            ResultSet rsCustomer = stmtCustomer.getGeneratedKeys();
            if (rsCustomer.next()) {
                customer.setId(userId);
                customer.setCustomerId(rsCustomer.getInt(1));
            }

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // ========================================
    // GET CUSTOMER BY USER ID
    // ========================================

    /**
     * Get customer by user ID
     * 
     * @param userId User ID dari tabel user
     * @return Customer object
     */
    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT c.customer_id, c.user_id, c.username, u.email, u.password " +
                "FROM customer c " +
                "INNER JOIN user u ON c.user_id = u.id " +
                "WHERE c.user_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET CUSTOMER BY CUSTOMER ID
    // ========================================

    /**
     * Get customer by customer ID
     * 
     * @param customerId Customer ID dari tabel customer
     * @return Customer object
     */
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT c.customer_id, c.user_id, c.username, u.email, u.password " +
                "FROM customer c " +
                "INNER JOIN user u ON c.user_id = u.id " +
                "WHERE c.customer_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET CUSTOMER BY EMAIL AND PASSWORD (LOGIN)
    // ========================================

    /**
     * Get customer by email and password for login
     * 
     * @param email    Email
     * @param password Password
     * @return Customer object if found
     */
    public Customer getCustomerByEmailAndPassword(String email, String password) {
        String sql = "SELECT c.customer_id, c.user_id, c.username, u.email, u.password " +
                "FROM customer c " +
                "INNER JOIN user u ON c.user_id = u.id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET ALL CUSTOMERS
    // ========================================

    /**
     * Get all customers
     * 
     * @return ArrayList of Customer
     */
    public ArrayList<Customer> getAllCustomers() {
        ArrayList<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.user_id, c.username, u.email, u.password " +
                "FROM customer c " +
                "INNER JOIN user u ON c.user_id = u.id";

        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    // ========================================
    // GET CUSTOMER WITH PREFERENCES
    // ========================================

    /**
     * Get customer beserta preferences-nya
     * 
     * @param customerId Customer ID
     * @return Customer object dengan list preferences
     */
    public Customer getCustomerWithPreferences(int customerId) {
        Customer customer = getCustomerById(customerId);

        if (customer != null) {
            // Load preferences
            String sql = "SELECT preference_id, customer_id, processor, graphicsCardType, memory " +
                    "FROM preference WHERE customer_id = ?";

            try (Connection conn = getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, customerId);
                ResultSet rs = stmt.executeQuery();

                ArrayList<Preference> preferences = new ArrayList<>();
                while (rs.next()) {
                    Preference pref = new Preference(
                            rs.getInt("preference_id"),
                            rs.getInt("customer_id"),
                            rs.getString("processor"),
                            rs.getString("graphicsCardType"),
                            rs.getInt("memory"));
                    preferences.add(pref);
                }

                customer.setPreferences(preferences);
                if (!preferences.isEmpty()) {
                    customer.setPreference(preferences.get(0)); // Set first preference as main
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return customer;
    }

    // ========================================
    // UPDATE CUSTOMER
    // ========================================

    /**
     * Update customer data
     * 
     * @param customer Customer object dengan data baru
     * @return true jika berhasil
     */
    public boolean updateCustomer(Customer customer) {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Update tabel user
            String sqlUser = "UPDATE user SET email = ?, password = ? WHERE id = ?";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setString(1, customer.getEmail());
            stmtUser.setString(2, customer.getPassword());
            stmtUser.setInt(3, customer.getId());
            stmtUser.executeUpdate();

            // Update tabel customer
            String sqlCustomer = "UPDATE customer SET username = ? WHERE customer_id = ?";
            PreparedStatement stmtCustomer = conn.prepareStatement(sqlCustomer);
            stmtCustomer.setString(1, customer.getUsername());
            stmtCustomer.setInt(2, customer.getCustomerId());
            stmtCustomer.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // ========================================
    // DELETE CUSTOMER
    // ========================================

    /**
     * Delete customer
     * Catatan: Karena ON DELETE CASCADE:
     * - Menghapus dari tabel user akan otomatis menghapus dari tabel customer
     * - Semua preference customer juga akan terhapus (Composition)
     * 
     * @param userId User ID dari customer
     * @return true jika berhasil
     */
    public boolean deleteCustomer(int userId) {
        String sql = "DELETE FROM user WHERE id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // HELPER METHOD
    // ========================================

    /**
     * Map ResultSet ke Customer object
     */
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setId(rs.getInt("user_id"));
        customer.setUsername(rs.getString("username"));
        customer.setEmail(rs.getString("email"));
        customer.setPassword(rs.getString("password"));
        customer.setUserType("customer");
        return customer;
    }
}
