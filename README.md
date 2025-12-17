# 🐟 MANYUNG - Sistem Informasi Rekomendasi Laptop

![Manyung Logo](https://img.shields.io/badge/Manyung-v1.0-red?style=for-the-badge)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)

> **Sistem Informasi Rekomendasi Laptop Berbasis Web**  
> Final Project - Pemrograman Berorientasi Objek (PBO)

---

## 📋 Deskripsi Project

**Manyung** adalah aplikasi web yang menyediakan sistem rekomendasi laptop berdasarkan preferensi pengguna. Aplikasi ini membantu pengguna menemukan laptop yang sesuai dengan kebutuhan mereka (gaming, productivity, content creation, dll) melalui mekanisme filtering berdasarkan spesifikasi hardware.

### ✨ Fitur Utama

#### 👤 **User Features**
- 🔐 User Authentication (Login/Register)
- 📱 Browse Laptop Catalog (85+ devices)
- 🔍 Search & Filter by Category
- ⭐ Preference-based Recommendation
- 📊 View Detailed Specifications
- 💾 Save User Preferences

#### 🔧 **Admin Features**
- 📦 Full CRUD Operations for Devices
- ➕ Add New Products with Image Upload
- ✏️ Edit Product Information
- 🗑️ Delete Products
- 📊 Dashboard Statistics
- 🎨 Consistent Data Entry (Dropdown Selects)

---

## 🏗️ Teknologi Stack

### Backend
- **Framework:** Jakarta EE (JAX-RS)
- **Language:** Java 11+
- **Server:** Apache Tomcat 10.1
- **Build Tool:** Maven
- **Database:** MySQL 8.0

### Frontend
- **HTML5** - Structure
- **CSS3** - Styling (Modern Design System)
- **JavaScript (Vanilla)** - Interactivity
- **JSP** - Server-side Rendering

### Database
- **RDBMS:** MySQL
- **ORM Pattern:** DAO (Data Access Object)
- **Connection Pool:** Built-in

---

## 📊 Database ERD

```
user (Parent)
  ├── admin (1:1 via user_id)
  └── customer (1:1 via user_id)
        └── preference (1:M via customer_id)

device (Standalone)
```

### Tables:
- `user` - Parent table untuk semua users
- `admin` - Admin users (extends user)
- `customer` - Regular users (extends user)
- `preference` - User preferences untuk recommendation
- `device` - Laptop catalog (85 devices)

---

## 🚀 Installation & Setup

### Prerequisites
```bash
- Java JDK 11 or higher
- Apache Tomcat 10.1+
- MySQL 8.0+
- Maven 3.6+
- Git
```

### 1. Clone Repository
```bash
git clone https://github.com/Sulthonikamalm/SIMANYUNG.git
cd SIMANYUNG
```

### 2. Database Setup
```bash
# Login to MySQL
mysql -u root -p

# Import database
source manyung_final.sql
```

### 3. Configure Database Connection
Edit `Manyung/src/main/webapp/META-INF/context.xml`:
```xml
<Resource name="jdbc/manyung" 
          auth="Container"
          type="javax.sql.DataSource"
          username="root"
          password="your_password"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/manyung"/>
```

### 4. Build Project
```bash
cd Manyung
mvn clean package
```

### 5. Deploy to Tomcat
```bash
# Copy WAR file to Tomcat webapps
cp target/Manyung.war $TOMCAT_HOME/webapps/
```

### 6. Run Application
```bash
# Start Tomcat
$TOMCAT_HOME/bin/startup.sh  # Linux/Mac
$TOMCAT_HOME/bin/startup.bat # Windows

# Access application
http://localhost:8080/Manyung
```

---

## 👥 Default Login Credentials

### Admin Account
```
Email: admin@gmail.com
Password: 123
```

### User Account
```
Email: user@manyung.com
Password: user123
```

---

## 📁 Project Structure

```
SIMANYUNG/
├── Manyung/                          # Main application
│   ├── src/main/
│   │   ├── java/
│   │   │   ├── com.mycompany.manyung/   # REST API
│   │   │   ├── dao/                     # Data Access Objects
│   │   │   ├── model/                   # Entity Models
│   │   │   └── web/                     # Servlets
│   │   ├── webapp/
│   │   │   ├── Pages/                   # JSP Pages
│   │   │   ├── css/                     # Stylesheets
│   │   │   ├── images_device/           # Product Images
│   │   │   └── META-INF/                # Configuration
│   │   └── resources/
│   └── pom.xml                       # Maven Config
├── manyung_final.sql                # Database Schema & Data
├── DOKUMENTASI_MIGRASI_ERD.md       # ERD Documentation
├── FORM_IMPROVEMENT_DROPDOWN.md     # Form Enhancement Docs
└── README.md                        # This file
```

---

## 🎯 Key Features Implementation

### 1. **Inheritance Pattern (User → Admin/Customer)**
```java
// Table Per Subclass Pattern
user (parent table)
  ↓ FK relationship
admin.user_id → user.id
customer.user_id → user.id
```

### 2. **Recommendation Engine**
```java
// Preference-based filtering
Processor: Intel/AMD
Graphics: Dedicated/Integrated
Memory: 4GB/8GB/16GB/32GB+
```

### 3. **Data Consistency**
- Dropdown selects for Brand & Category
- Predefined values: Gaming, Creators, Office, Students, Home
- Brand options: Asus, Acer, MSI, Lenovo, Dell, HP

---

## 📈 Database Statistics

| Entity | Count | Description |
|--------|-------|-------------|
| Users | 11 | 1 Admin + 10 Customers |
| Devices | 85 | Complete laptop catalog |
| Brands | 4 | Asus, Acer, MSI, Lenovo |
| Categories | 5 | Gaming, Creators, Office, Students, Home |

---

## 🎨 Design System

- **Primary Color:** Red (#DC2626)
- **Typography:** System fonts (-apple-system, BlinkMacSystemFont)
- **Layout:** Responsive grid system
- **Components:** Modern cards, modals, forms
- **UX:** Clean, minimal, user-friendly

---

## 📝 API Endpoints

### User Endpoints
```
GET  /UserServlet?action=showAllDevices  - View all devices
GET  /UserServlet?action=searchDevice    - Search devices
POST /UserServlet?action=login           - User login
POST /UserServlet?action=register        - User registration
GET  /UserServlet?action=logout          - Logout
```

### Admin Endpoints
```
GET  /AdminServlet?action=showAllDevicesAdmin - Admin dashboard
GET  /AdminServlet?action=showDeviceEdit      - Edit form
POST /AdminServlet?action=tambahDevice        - Add device
POST /AdminServlet?action=editDevice          - Update device
GET  /AdminServlet?action=deleteDevice        - Delete device
```

---

## 🔒 Security Features

- Password validation
- Session management
- SQL injection prevention (PreparedStatement)
- XSS protection (Input sanitization)
- Admin-only access control

---

## 📚 Documentation

- `DOKUMENTASI_MIGRASI_ERD.md` - Database design & ERD
- `FORM_IMPROVEMENT_DROPDOWN.md` - Form enhancement rationale
- Code comments - Inline documentation

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

This project is created for educational purposes as part of the Object-Oriented Programming (PBO) course.

---

## 👨‍💻 Team

**Kelompok 2 - PBO Semester 5**

- Project Lead & Developer
- Database Architect
- UI/UX Designer
- Quality Assurance

---

## 📞 Contact

For questions or support:
- GitHub: [@Sulthonikamalm](https://github.com/Sulthonikamalm)
- Repository: [SIMANYUNG](https://github.com/Sulthonikamalm/SIMANYUNG)

---

## 🙏 Acknowledgments

- **Dosen PBO** - Guidance and mentorship
- **Jakarta EE Community** - Framework documentation
- **MySQL** - Database management system
- **Apache Tomcat** - Application server

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ for PBO Final Project

</div>
