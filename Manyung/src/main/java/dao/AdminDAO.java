/*
 * ============================================================
 * AdminDAO.java - Data Access Object untuk Admin (BARU)
 * ============================================================
 * Deskripsi: DAO untuk operasi database pada tabel admin
 *            Database: manyung
 * ============================================================
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Admin;

public class AdminDAO {

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
    // GET ADMIN BY EMAIL AND PASSWORD (LOGIN)
    // ========================================

    /**
     * Get admin by email and password for login
     * 
     * @param email    Email
     * @param password Password
     * @return Admin object if found
     */
    public Admin getAdminByEmailAndPassword(String email, String password) {
        String sql = "SELECT a.admin_id, a.user_id, a.username, u.email, u.password " +
                "FROM admin a " +
                "INNER JOIN user u ON a.user_id = u.id " +
                "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET ADMIN BY USER ID
    // ========================================

    /**
     * Get admin by user ID
     * 
     * @param userId User ID dari tabel user
     * @return Admin object
     */
    public Admin getAdminByUserId(int userId) {
        String sql = "SELECT a.admin_id, a.user_id, a.username, u.email, u.password " +
                "FROM admin a " +
                "INNER JOIN user u ON a.user_id = u.id " +
                "WHERE a.user_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET ADMIN BY ADMIN ID
    // ========================================

    /**
     * Get admin by admin ID
     * 
     * @param adminId Admin ID dari tabel admin
     * @return Admin object
     */
    public Admin getAdminById(int adminId) {
        String sql = "SELECT a.admin_id, a.user_id, a.username, u.email, u.password " +
                "FROM admin a " +
                "INNER JOIN user u ON a.user_id = u.id " +
                "WHERE a.admin_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, adminId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET ALL ADMINS
    // ========================================

    /**
     * Get all admins
     * 
     * @return ArrayList of Admin
     */
    public ArrayList<Admin> getAllAdmins() {
        ArrayList<Admin> admins = new ArrayList<>();
        String sql = "SELECT a.admin_id, a.user_id, a.username, u.email, u.password " +
                "FROM admin a " +
                "INNER JOIN user u ON a.user_id = u.id";

        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return admins;
    }

    // ========================================
    // INSERT ADMIN
    // ========================================

    /**
     * Insert admin baru
     * 
     * @param admin Admin object
     * @return true jika berhasil
     */
    public boolean insertAdmin(Admin admin) {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Step 1: Insert ke tabel user
            String sqlUser = "INSERT INTO user (email, password, user_type) VALUES (?, ?, 'admin')";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, admin.getEmail());
            stmtUser.setString(2, admin.getPassword());
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

            // Step 2: Insert ke tabel admin
            String sqlAdmin = "INSERT INTO admin (user_id, username) VALUES (?, ?)";
            PreparedStatement stmtAdmin = conn.prepareStatement(sqlAdmin, Statement.RETURN_GENERATED_KEYS);
            stmtAdmin.setInt(1, userId);
            stmtAdmin.setString(2, admin.getUsername());
            stmtAdmin.executeUpdate();

            // Get generated admin ID
            ResultSet rsAdmin = stmtAdmin.getGeneratedKeys();
            if (rsAdmin.next()) {
                admin.setId(userId);
                admin.setAdminId(rsAdmin.getInt(1));
            }

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
    // UPDATE ADMIN
    // ========================================

    /**
     * Update admin data
     * 
     * @param admin Admin object dengan data baru
     * @return true jika berhasil
     */
    public boolean updateAdmin(Admin admin) {
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Update tabel user
            String sqlUser = "UPDATE user SET email = ?, password = ? WHERE id = ?";
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setString(1, admin.getEmail());
            stmtUser.setString(2, admin.getPassword());
            stmtUser.setInt(3, admin.getId());
            stmtUser.executeUpdate();

            // Update tabel admin
            String sqlAdmin = "UPDATE admin SET username = ? WHERE admin_id = ?";
            PreparedStatement stmtAdmin = conn.prepareStatement(sqlAdmin);
            stmtAdmin.setString(1, admin.getUsername());
            stmtAdmin.setInt(2, admin.getAdminId());
            stmtAdmin.executeUpdate();

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
    // DELETE ADMIN
    // ========================================

    /**
     * Delete admin
     * Catatan: Karena ON DELETE CASCADE, menghapus dari user
     * akan otomatis menghapus dari admin
     * 
     * @param userId User ID dari admin
     * @return true jika berhasil
     */
    public boolean deleteAdmin(int userId) {
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
    // CHECK IF USER IS ADMIN
    // ========================================

    /**
     * Cek apakah user adalah admin
     * 
     * @param userId User ID
     * @return true jika user adalah admin
     */
    public boolean isAdmin(int userId) {
        String sql = "SELECT COUNT(*) FROM admin WHERE user_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
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

    // ========================================
    // HELPER METHOD
    // ========================================

    /**
     * Map ResultSet ke Admin object
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setId(rs.getInt("user_id"));
        admin.setUsername(rs.getString("username"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        admin.setUserType("admin");
        return admin;
    }
}
