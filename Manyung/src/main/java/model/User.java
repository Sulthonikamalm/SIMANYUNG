/*
 * ============================================================
 * User.java - Parent Class (ERD Baru)
 * ============================================================
 * Deskripsi: Kelas induk untuk Admin dan Customer
 *            Kompatibel dengan UserServlet yang sudah ada
 * ============================================================
 */
package model;

public class User {

    // ========================================
    // ATRIBUT (Kompatibel dengan kode lama)
    // ========================================
    protected int id;
    protected String username;
    protected String email;
    protected String password;
    protected int preference_id;
    protected Preference preference;
    protected String userType;

    // ========================================
    // CONSTRUCTORS
    // ========================================

    /**
     * Default Constructor
     */
    public User() {
    }

    /**
     * Constructor untuk kompatibilitas dengan kode lama
     */
    public User(int user_id, String username, String email, String password, int preference_id) {
        this.id = user_id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.preference_id = preference_id;
    }

    /**
     * Constructor dengan parameter dasar
     */
    public User(int id, String email, String password) {
        this.id = id;
        this.email = email;
        this.password = password;
    }

    /**
     * Constructor lengkap dengan user type
     */
    public User(int id, String email, String password, String userType) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.userType = userType;
    }

    // ========================================
    // METHOD LOGIN (Return Type: boolean)
    // ========================================

    /**
     * Method untuk login user
     * 
     * @return true jika login berhasil, false jika gagal
     */
    public boolean login() {
        // Implementasi dasar
        return true;
    }

    // ========================================
    // METHOD LOGOUT (Return Type: void)
    // ========================================

    /**
     * Method untuk logout user
     */
    public void logout() {
        this.id = 0;
        this.email = null;
        this.password = null;
        this.userType = null;
    }

    // ========================================
    // GETTERS (Kompatibel dengan kode lama)
    // ========================================

    public int getId() {
        return id;
    }

    /**
     * Alias untuk getId() - kompatibilitas dengan kode lama
     */
    public int getUser_id() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public int getPreference_id() {
        return preference_id;
    }

    public Preference getPreference() {
        return preference;
    }

    public String getUserType() {
        return userType;
    }

    // ========================================
    // SETTERS (Kompatibel dengan kode lama)
    // ========================================

    public void setId(int id) {
        this.id = id;
    }

    /**
     * Alias untuk setId() - kompatibilitas dengan kode lama
     */
    public void setUser_id(int user_id) {
        this.id = user_id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setPreference_id(int preference_id) {
        this.preference_id = preference_id;
    }

    public void setPreference(Preference preference) {
        this.preference = preference;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    // ========================================
    // HELPER METHODS
    // ========================================

    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.userType);
    }

    public boolean isCustomer() {
        return "customer".equalsIgnoreCase(this.userType);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", userType='" + userType + '\'' +
                '}';
    }
}
