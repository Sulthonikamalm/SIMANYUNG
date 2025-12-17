/*
 * ============================================================
 * UserBehavior.java - Interface untuk Customer/User Servlet
 * ============================================================
 * Deskripsi: Interface yang mendefinisikan perilaku Customer
 *            Kompatibel dengan Servlet yang sudah ada
 * ============================================================
 */
package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Interface UserBehavior
 * Diimplementasikan oleh UserServlet
 */
public interface UserBehavior {

        /**
         * Method untuk update preference user
         */
        void UpdatePreference(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException;

        /**
         * Method untuk mendapatkan rekomendasi device
         */
        void getRekomendasiDevice(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException;

        /**
         * Method untuk filter device berdasarkan kategori
         */
        void getDeviceByCategory(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException;
}
