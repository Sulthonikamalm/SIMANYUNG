/*
 * ============================================================
 * Preference.java - Composition with Customer
 * ============================================================
 * Deskripsi: Kelas Preference yang memiliki relasi Composition
 *            dengan Customer (belah ketupat hitam)
 * 
 * COMPOSITION RULE:
 * - Jika Customer dihapus, semua Preference-nya HARUS ikut terhapus
 * - Preference tidak dapat eksis tanpa Customer
 * - Diimplementasikan dengan ON DELETE CASCADE di database
 * 
 * Atribut (dari ERD Baru):
 * - preferenceId: int (Primary Key)
 * - processor: String
 * - graphicsCardType: String
 * - memory: int
 * - customerId: int (Foreign Key ke Customer - PERUBAHAN dari user_id)
 * 
 * Method:
 * - Constructor, Getters, Setters
 * ============================================================
 */
package model;

public class Preference {

    // ========================================
    // ATRIBUT (dari ERD Baru)
    // ========================================
    private int preferenceId;
    private int customerId; // PERUBAHAN: dari user_id ke customer_id
    private String processor;
    private String graphicsCardType;
    private int memory;

    // ========================================
    // CONSTRUCTORS
    // ========================================

    /**
     * Default Constructor
     */
    public Preference() {
    }

    /**
     * Constructor dari ERD
     * Preference(processor: String, memory: int, graphicsCardType: String)
     */
    public Preference(String processor, int memory, String graphicsCardType) {
        this.processor = processor;
        this.memory = memory;
        this.graphicsCardType = graphicsCardType;
    }

    /**
     * Constructor dengan semua parameter (tanpa preferenceId untuk insert baru)
     * 
     * @param customerId       Customer ID (FK)
     * @param processor        Tipe processor
     * @param graphicsCardType Tipe graphics card
     * @param memory           Kapasitas memory (GB)
     */
    public Preference(int customerId, String processor, String graphicsCardType, int memory) {
        this.customerId = customerId;
        this.processor = processor;
        this.graphicsCardType = graphicsCardType;
        this.memory = memory;
    }

    /**
     * Constructor lengkap
     * 
     * @param preferenceId     Preference ID (PK)
     * @param customerId       Customer ID (FK) - PERUBAHAN dari user_id
     * @param processor        Tipe processor
     * @param graphicsCardType Tipe graphics card
     * @param memory           Kapasitas memory (GB)
     */
    public Preference(int preferenceId, int customerId, String processor, String graphicsCardType, int memory) {
        this.preferenceId = preferenceId;
        this.customerId = customerId;
        this.processor = processor;
        this.graphicsCardType = graphicsCardType;
        this.memory = memory;
    }

    /**
     * Constructor untuk kompatibilitas dengan kode lama
     * (menggunakan user_id yang sekarang menjadi customer_id)
     */
    @Deprecated
    public static Preference createFromLegacy(int preferenceId, int userId, String processor,
            String graphicsCardType, int memory) {
        // Dalam migrasi, userId akan dipetakan ke customerId
        return new Preference(preferenceId, userId, processor, graphicsCardType, memory);
    }

    // ========================================
    // GETTERS
    // ========================================

    public int getPreferenceId() {
        return preferenceId;
    }

    /**
     * Get Customer ID
     * PERUBAHAN: Menggantikan getUser_id()
     */
    public int getCustomerId() {
        return customerId;
    }

    /**
     * @deprecated Gunakan getCustomerId() sebagai pengganti
     */
    @Deprecated
    public int getUser_id() {
        return customerId;
    }

    public String getProcessor() {
        return processor;
    }

    public String getGraphicsCardType() {
        return graphicsCardType;
    }

    public int getMemory() {
        return memory;
    }

    // ========================================
    // SETTERS
    // ========================================

    public void setPreferenceId(int preferenceId) {
        this.preferenceId = preferenceId;
    }

    /**
     * Set Customer ID
     * PERUBAHAN: Menggantikan setUser_id()
     */
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    /**
     * @deprecated Gunakan setCustomerId() sebagai pengganti
     */
    @Deprecated
    public void setUser_id(int userId) {
        this.customerId = userId;
    }

    public void setProcessor(String processor) {
        this.processor = processor;
    }

    public void setGraphicsCardType(String graphicsCardType) {
        this.graphicsCardType = graphicsCardType;
    }

    public void setMemory(int memory) {
        this.memory = memory;
    }

    // ========================================
    // HELPER METHODS
    // ========================================

    /**
     * Validasi apakah preference valid
     * 
     * @return true jika semua field terisi
     */
    public boolean isValid() {
        return processor != null && !processor.trim().isEmpty() &&
                graphicsCardType != null && !graphicsCardType.trim().isEmpty() &&
                memory > 0;
    }

    /**
     * Cek apakah preference match dengan device tertentu
     * 
     * @param device Device untuk di-compare
     * @return true jika device sesuai dengan preference
     */
    public boolean matchesDevice(Device device) {
        if (device == null)
            return false;

        boolean processorMatch = device.getProcessor() != null &&
                device.getProcessor().toLowerCase().contains(this.processor.toLowerCase());

        boolean graphicsMatch = device.getGraphicsCardType() != null &&
                device.getGraphicsCardType().equalsIgnoreCase(this.graphicsCardType);

        boolean memoryMatch = device.getMemory() >= this.memory;

        // Return true jika minimal 2 dari 3 kriteria terpenuhi
        int matchCount = 0;
        if (processorMatch)
            matchCount++;
        if (graphicsMatch)
            matchCount++;
        if (memoryMatch)
            matchCount++;

        return matchCount >= 2;
    }

    // ========================================
    // OVERRIDE METHODS
    // ========================================

    @Override
    public String toString() {
        return "Preference{" +
                "preferenceId=" + preferenceId +
                ", customerId=" + customerId +
                ", processor='" + processor + '\'' +
                ", graphicsCardType='" + graphicsCardType + '\'' +
                ", memory=" + memory +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || getClass() != obj.getClass())
            return false;

        Preference that = (Preference) obj;
        return preferenceId == that.preferenceId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(preferenceId);
    }
}
