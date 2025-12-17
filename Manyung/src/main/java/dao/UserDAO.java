/*
 * ============================================================
 * UserDAO.java - Data Access Object untuk User
 * ============================================================
 * Deskripsi: DAO untuk operasi database pada tabel user
 *            Kompatibel dengan UserServlet dan struktur baru
 *            Database: manyung
 * ============================================================
 */
package dao;

import java.sql.*;
import model.Preference;
import model.User;

public class UserDAO {

    // ========================================
    // DATABASE CONNECTION SETTINGS
    // ========================================
    // Database manyung
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
    // VALIDATE USER (untuk login - bukan admin)
    // ========================================

    /**
     * Validasi user dengan email dan password
     * 
     * @param email    Email user
     * @param password Password user
     * @return true jika user valid dan BUKAN admin
     */
    public boolean validateUser(String email, String password) {
        String sql = "SELECT u.id, u.user_type FROM user u " +
                "INNER JOIN customer c ON u.id = c.user_id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true jika ditemukan customer

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // VALIDATE ADMIN (untuk login admin)
    // ========================================

    /**
     * Validasi admin dengan email dan password
     * 
     * @param email    Email admin
     * @param password Password admin
     * @return true jika user valid dan ADALAH admin
     */
    public boolean validateAdmin(String email, String password) {
        String sql = "SELECT u.id, u.user_type FROM user u " +
                "INNER JOIN admin a ON u.id = a.user_id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true jika ditemukan admin

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // SELECT USER (untuk login)
    // ========================================

    /**
     * Get user by email and password
     * Kompatibel dengan UserServlet
     */
    public User selectUser(String email, String password) {
        // Coba cari di customer dulu
        String sqlCustomer = "SELECT u.id, c.username, u.email, u.password, u.user_type " +
                "FROM user u " +
                "INNER JOIN customer c ON u.id = c.user_id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlCustomer)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setUserType(rs.getString("user_type"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Jika tidak ditemukan di customer, cari di admin
        String sqlAdmin = "SELECT u.id, a.username, u.email, u.password, u.user_type " +
                "FROM user u " +
                "INNER JOIN admin a ON u.id = a.user_id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlAdmin)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setUserType(rs.getString("user_type"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // ========================================
    // SELECT PREFERENCE
    // ========================================

    /**
     * Get preference by user_id
     * Kompatibel dengan UserServlet
     */
    public Preference selectPreference(int userId) {
        // Dapatkan customer_id dari user_id
        String sqlCustomer = "SELECT customer_id FROM customer WHERE user_id = ?";
        int customerId = -1;

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlCustomer)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (customerId == -1) {
            return null;
        }

        // Dapatkan preference dari customer_id
        String sqlPref = "SELECT preference_id, customer_id, processor, graphicsCardType, memory " +
                "FROM preference WHERE customer_id = ? ORDER BY preference_id DESC LIMIT 1";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlPref)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Preference pref = new Preference();
                pref.setPreferenceId(rs.getInt("preference_id"));
                pref.setCustomerId(rs.getInt("customer_id"));
                pref.setProcessor(rs.getString("processor"));
                pref.setGraphicsCardType(rs.getString("graphicsCardType"));
                pref.setMemory(rs.getInt("memory"));
                return pref;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // ========================================
    // INSERT USER (Register)
    // ========================================

    /**
     * Insert user baru (register customer)
     * Kompatibel dengan UserServlet
     */
    public boolean insertUser(String username, String email, String password) {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Cek apakah email sudah ada
            String checkSql = "SELECT COUNT(*) FROM user WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet checkRs = checkStmt.executeQuery();
            if (checkRs.next() && checkRs.getInt(1) > 0) {
                return false; // Email sudah ada
            }

            // Insert ke tabel user
            String sqlUser = "INSERT INTO user (email, password, user_type) VALUES (?, ?, 'customer')";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, email);
            stmtUser.setString(2, password);
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

            // Insert ke tabel customer
            String sqlCustomer = "INSERT INTO customer (user_id, username) VALUES (?, ?)";
            PreparedStatement stmtCustomer = conn.prepareStatement(sqlCustomer);
            stmtCustomer.setInt(1, userId);
            stmtCustomer.setString(2, username);
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

    /**
     * Insert user (overload untuk kompatibilitas)
     */
    public int insertUser(User user, String userType) {
        String sql = "INSERT INTO user (email, password, user_type) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, userType);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }

            return -1;

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ========================================
    // INSERT PREFERENCE
    // ========================================

    /**
     * Insert preference baru
     * Kompatibel dengan UserServlet
     */
    public boolean insertPreference(int userId, String processor, String graphicsCardType, String memory)
            throws SQLException {
        // Dapatkan customer_id dari user_id
        String sqlCustomer = "SELECT customer_id FROM customer WHERE user_id = ?";
        int customerId = -1;

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlCustomer)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }

        }

        if (customerId == -1) {
            return false;
        }

        // Insert preference
        String sql = "INSERT INTO preference (customer_id, processor, graphicsCardType, memory) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            stmt.setString(2, processor);
            stmt.setString(3, graphicsCardType);
            stmt.setInt(4, Integer.parseInt(memory));

            return stmt.executeUpdate() > 0;

        }
    }

    // ========================================
    // UPDATE PREFERENCE
    // ========================================

    /**
     * Update preference
     * Kompatibel dengan UserServlet
     */
    public boolean updatePreference(int userId, String processor, String graphicsCardType, String memory)
            throws SQLException {
        // Dapatkan customer_id dari user_id
        String sqlCustomer = "SELECT customer_id FROM customer WHERE user_id = ?";
        int customerId = -1;

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlCustomer)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }

        }

        if (customerId == -1) {
            return false;
        }

        // Update preference
        String sql = "UPDATE preference SET processor = ?, graphicsCardType = ?, memory = ? WHERE customer_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, processor);
            stmt.setString(2, graphicsCardType);
            stmt.setInt(3, Integer.parseInt(memory));
            stmt.setInt(4, customerId);

            return stmt.executeUpdate() > 0;

        }
    }

    // ========================================
    // GET USER BY EMAIL AND PASSWORD
    // ========================================

    /**
     * Get user by email and password (untuk ERD baru)
     */
    public User getUserByEmailAndPassword(String email, String password) {
        return selectUser(email, password);
    }

    // ========================================
    // GET USER BY ID
    // ========================================

    public User getUserById(int id) {
        String sql = "SELECT id, email, password, user_type FROM user WHERE id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setUserType(rs.getString("user_type"));
                return user;
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // UPDATE USER
    // ========================================

    public boolean updateUser(User user) {
        String sql = "UPDATE user SET email = ?, password = ? WHERE id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword());
            stmt.setInt(3, user.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // DELETE USER
    // ========================================

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM user WHERE id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // CHECK EMAIL EXISTS
    // ========================================

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
