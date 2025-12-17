/*
 * ============================================================
 * PreferenceDAO.java - Data Access Object untuk Preference
 * ============================================================
 * Deskripsi: DAO untuk operasi database pada tabel preference
 *            Database: manyung
 * 
 * PERUBAHAN UTAMA:
 * - user_id diganti menjadi customer_id (Composition dengan Customer)
 * - ON DELETE CASCADE sudah diimplementasikan di database
 * ============================================================
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Preference;

public class PreferenceDAO {

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
    // INSERT PREFERENCE
    // ========================================

    /**
     * Insert preference baru untuk customer
     * 
     * @param preference Preference object
     * @return true jika berhasil
     */
    public boolean insertPreference(Preference preference) {
        // PERUBAHAN: user_id menjadi customer_id
        String sql = "INSERT INTO preference (customer_id, processor, graphicsCardType, memory) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, preference.getCustomerId());
            stmt.setString(2, preference.getProcessor());
            stmt.setString(3, preference.getGraphicsCardType());
            stmt.setInt(4, preference.getMemory());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    preference.setPreferenceId(generatedKeys.getInt(1));
                }
                return true;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // GET PREFERENCE BY ID
    // ========================================

    /**
     * Get preference by preference ID
     * 
     * @param preferenceId Preference ID
     * @return Preference object
     */
    public Preference getPreferenceById(int preferenceId) {
        String sql = "SELECT preference_id, customer_id, processor, graphicsCardType, memory FROM preference WHERE preference_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, preferenceId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPreference(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET PREFERENCES BY CUSTOMER ID
    // ========================================

    /**
     * Get all preferences for a customer
     * PERUBAHAN: Menggunakan customer_id bukan user_id
     * 
     * @param customerId Customer ID
     * @return ArrayList of Preference
     */
    public ArrayList<Preference> getPreferencesByCustomerId(int customerId) {
        ArrayList<Preference> preferences = new ArrayList<>();
        String sql = "SELECT preference_id, customer_id, processor, graphicsCardType, memory FROM preference WHERE customer_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                preferences.add(mapResultSetToPreference(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return preferences;
    }

    /**
     * @deprecated Gunakan getPreferencesByCustomerId() sebagai pengganti
     */
    @Deprecated
    public ArrayList<Preference> getPreferencesByUserId(int userId) {
        return getPreferencesByCustomerId(userId);
    }

    // ========================================
    // GET FIRST/MAIN PREFERENCE BY CUSTOMER ID
    // ========================================

    /**
     * Get main preference for a customer (first preference)
     * 
     * @param customerId Customer ID
     * @return Preference object or null
     */
    public Preference getMainPreferenceByCustomerId(int customerId) {
        String sql = "SELECT preference_id, customer_id, processor, graphicsCardType, memory " +
                "FROM preference WHERE customer_id = ? ORDER BY preference_id ASC LIMIT 1";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPreference(rs);
            }

            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // ========================================
    // GET ALL PREFERENCES
    // ========================================

    /**
     * Get all preferences
     * 
     * @return ArrayList of Preference
     */
    public ArrayList<Preference> getAllPreferences() {
        ArrayList<Preference> preferences = new ArrayList<>();
        String sql = "SELECT preference_id, customer_id, processor, graphicsCardType, memory FROM preference";

        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                preferences.add(mapResultSetToPreference(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return preferences;
    }

    // ========================================
    // UPDATE PREFERENCE
    // ========================================

    /**
     * Update preference data
     * 
     * @param preference Preference object dengan data baru
     * @return true jika berhasil
     */
    public boolean updatePreference(Preference preference) {
        String sql = "UPDATE preference SET processor = ?, graphicsCardType = ?, memory = ? WHERE preference_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, preference.getProcessor());
            stmt.setString(2, preference.getGraphicsCardType());
            stmt.setInt(3, preference.getMemory());
            stmt.setInt(4, preference.getPreferenceId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // DELETE PREFERENCE
    // ========================================

    /**
     * Delete preference by ID
     * 
     * @param preferenceId Preference ID
     * @return true jika berhasil
     */
    public boolean deletePreference(int preferenceId) {
        String sql = "DELETE FROM preference WHERE preference_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, preferenceId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // DELETE ALL PREFERENCES BY CUSTOMER ID
    // ========================================

    /**
     * Delete all preferences for a customer
     * Catatan: Ini juga akan terjadi otomatis karena CASCADE DELETE
     * ketika customer dihapus
     * 
     * @param customerId Customer ID
     * @return true jika berhasil
     */
    public boolean deleteAllPreferencesByCustomerId(int customerId) {
        String sql = "DELETE FROM preference WHERE customer_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            return stmt.executeUpdate() >= 0; // >= 0 karena mungkin tidak ada preference

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================
    // CHECK IF CUSTOMER HAS PREFERENCE
    // ========================================

    /**
     * Cek apakah customer sudah memiliki preference
     * 
     * @param customerId Customer ID
     * @return true jika customer sudah punya preference
     */
    public boolean customerHasPreference(int customerId) {
        String sql = "SELECT COUNT(*) FROM preference WHERE customer_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
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
    // UPSERT PREFERENCE (INSERT OR UPDATE)
    // ========================================

    /**
     * Insert or update preference untuk customer
     * Jika customer sudah punya preference, update. Jika belum, insert baru.
     * 
     * @param preference Preference object
     * @return true jika berhasil
     */
    public boolean upsertPreference(Preference preference) {
        if (preference.getPreferenceId() > 0) {
            // Update existing
            return updatePreference(preference);
        } else if (customerHasPreference(preference.getCustomerId())) {
            // Get existing preference ID and update
            Preference existing = getMainPreferenceByCustomerId(preference.getCustomerId());
            if (existing != null) {
                preference.setPreferenceId(existing.getPreferenceId());
                return updatePreference(preference);
            }
        }

        // Insert new
        return insertPreference(preference);
    }

    // ========================================
    // HELPER METHOD
    // ========================================

    /**
     * Map ResultSet ke Preference object
     */
    private Preference mapResultSetToPreference(ResultSet rs) throws SQLException {
        Preference preference = new Preference();
        preference.setPreferenceId(rs.getInt("preference_id"));
        preference.setCustomerId(rs.getInt("customer_id"));
        preference.setProcessor(rs.getString("processor"));
        preference.setGraphicsCardType(rs.getString("graphicsCardType"));
        preference.setMemory(rs.getInt("memory"));
        return preference;
    }
}
