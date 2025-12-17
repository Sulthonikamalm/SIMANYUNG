/*
 * ============================================================
 * AdminBehavior.java - Interface untuk Admin Servlet
 * ============================================================
 * Deskripsi: Interface yang mendefinisikan perilaku Admin
 *            Kompatibel dengan Servlet yang sudah ada
 * ============================================================
 */
package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Interface AdminBehavior
 * Diimplementasikan oleh kelas Admin dan AdminServlet
 */
public interface AdminBehavior {

    /**
     * Method untuk menambahkan data device baru
     * Kompatibel dengan AdminServlet
     */
    void tambahDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;

    /**
     * Method untuk mengedit data device
     * Kompatibel dengan AdminServlet
     */
    void editDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;

    /**
     * Method untuk menghapus data device
     * Kompatibel dengan AdminServlet
     */
    void deleteDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}
