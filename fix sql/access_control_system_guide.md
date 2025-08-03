# Hệ thống Phân quyền BadmintonHub

## 📋 Tổng quan

Hệ thống BadmintonHub có 3 loại người dùng với các quyền khác nhau:

### 👥 **Phân loại người dùng:**

1. **Admin** - Quản trị viên hệ thống
2. **Staff** - Nhân viên 
3. **Customer** - Khách hàng

## 🔐 **Chi tiết phân quyền:**

### **Admin (AdminDTO)**
- ✅ **Quyền truy cập:** Tất cả trang quản lý
- ✅ **Trang có thể truy cập:**
  - `/user-manager` - Quản lý người dùng
  - `/admin-manager` - Quản lý admin
  - `/court-manager` - Quản lý sân
  - `/service-manager` - Quản lý dịch vụ
  - `/court-rates-manager` - Quản lý giá sân
  - Tất cả trang khác

### **Staff (UserDTO với Role = "Staff")**
- ✅ **Quyền truy cập:** Trang quản lý cơ bản
- ❌ **Bị chặn:** Các trang quản lý hệ thống
- ✅ **Trang có thể truy cập:**
  - `/home` → Chuyển hướng về `/page-manager`
  - `/page-manager` - Trang quản lý cơ bản
  - Các trang người dùng thông thường
- ❌ **Trang bị chặn:**
  - `/user-manager` → Chuyển hướng về `/access-denied.jsp`
  - `/admin-manager` → Chuyển hướng về `/access-denied.jsp`
  - `/court-manager` → Chuyển hướng về `/access-denied.jsp`
  - `/service-manager` → Chuyển hướng về `/access-denied.jsp`
  - `/court-rates-manager` → Chuyển hướng về `/access-denied.jsp`

### **Customer (UserDTO với Role = "Customer")**
- ✅ **Quyền truy cập:** Chỉ trang người dùng
- ❌ **Bị chặn:** Tất cả trang quản lý
- ✅ **Trang có thể truy cập:**
  - `/home` - Trang chủ
  - Các trang người dùng thông thường

## 🛡️ **Hệ thống Filter:**

### **1. StaffAccessFilter**
- **Mục đích:** Chuyển hướng Staff khỏi trang `/home`
- **URL pattern:** `/home`
- **Logic:** Nếu Staff truy cập `/home` → Chuyển hướng về `/page-manager`

### **2. StaffManagerAccessFilter** ⭐ **MỚI**
- **Mục đích:** Chặn Staff truy cập các trang manager
- **URL patterns:** 
  - `/user-manager`
  - `/admin-manager`
  - `/court-manager`
  - `/service-manager`
  - `/court-rates-manager`
- **Logic:** Nếu Staff truy cập → Chuyển hướng về `/access-denied.jsp`

### **3. ManagerAccessFilter**
- **Mục đích:** Chỉ cho phép Admin/Staff truy cập trang manager
- **URL patterns:** 
  - `/*-manager`
  - `/*-manager.jsp`
  - `/pages/ui-manager/*`
- **Logic:** Kiểm tra quyền qua `AccessControlUtil.hasManagerAccess()`

### **4. ProfileCheckFilter**
- **Mục đích:** Kiểm tra profile hoàn chỉnh của User
- **URL pattern:** `/*`
- **Logic:** Nếu User chưa hoàn thành profile → Chuyển hướng về `/profile-setup.jsp`

## 🔧 **Cấu hình web.xml:**

```xml
<!-- Staff Access Filter -->
<filter>
    <filter-name>StaffAccessFilter</filter-name>
    <filter-class>filter.StaffAccessFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>StaffAccessFilter</filter-name>
    <url-pattern>/home</url-pattern>
</filter-mapping>

<!-- Staff Manager Access Filter - Chặn Staff truy cập trang manager -->
<filter>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <filter-class>filter.StaffManagerAccessFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <url-pattern>/user-manager</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <url-pattern>/admin-manager</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <url-pattern>/court-manager</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <url-pattern>/service-manager</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>StaffManagerAccessFilter</filter-name>
    <url-pattern>/court-rates-manager</url-pattern>
</filter-mapping>

<!-- Manager Access Filter -->
<filter>
    <filter-name>ManagerAccessFilter</filter-name>
    <filter-class>filter.ManagerAccessFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ManagerAccessFilter</filter-name>
    <url-pattern>/*-manager</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>ManagerAccessFilter</filter-name>
    <url-pattern>/*-manager.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>ManagerAccessFilter</filter-name>
    <url-pattern>/pages/ui-manager/*</url-pattern>
</filter-mapping>

<!-- Profile Check Filter -->
<filter>
    <filter-name>ProfileCheckFilter</filter-name>
    <filter-class>filter.ProfileCheckFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ProfileCheckFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 🗄️ **Cấu trúc Database:**

### **Bảng Users:**
```sql
CREATE TABLE [dbo].[Users](
    [UserID] [int] IDENTITY(1,1) NOT NULL,
    [Username] [nvarchar](100) NOT NULL,
    [Password] [nvarchar](255) NOT NULL,
    [Email] [nvarchar](100) NOT NULL,
    [FullName] [nvarchar](100) NULL,
    [Dob] [date] NULL,
    [Gender] [nvarchar](20) NULL,
    [Phone] [nvarchar](15) NULL,
    [Address] [nvarchar](255) NULL,
    [SportLevel] [nvarchar](100) NULL,
    [Role] [nvarchar](20) NOT NULL,  -- 'Staff' hoặc 'Customer'
    [Status] [nvarchar](20) NULL,
    [CreatedBy] [int] NULL,
    [CreatedAt] [datetime] NULL,
    [UpdatedAt] [datetime] NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC)
)
```

### **Bảng Admins:**
```sql
CREATE TABLE [dbo].[Admins](
    [AdminID] [int] IDENTITY(1,1) NOT NULL,
    [Username] [nvarchar](100) NOT NULL,
    [Password] [nvarchar](255) NOT NULL,
    [FullName] [nvarchar](100) NOT NULL,
    [Email] [nvarchar](100) NOT NULL,
    [Status] [nvarchar](20) NULL,
    [CreatedAt] [datetime] NULL,
    [UpdatedAt] [datetime] NULL,
    PRIMARY KEY CLUSTERED ([AdminID] ASC)
)
```

## 🛠️ **Utils và Helper Classes:**

### **AccessControlUtil.java**
```java
public class AccessControlUtil {
    public static boolean hasManagerAccess(HttpServletRequest request)
    public static boolean isAdmin(HttpServletRequest request)
    public static boolean isStaff(HttpServletRequest request)
    public static UserDTO getCurrentUser(HttpServletRequest request)
    public static AdminDTO getCurrentAdmin(HttpServletRequest request)
}
```

## 🧪 **Test Cases:**

### **Test Admin Access:**
1. Login với tài khoản Admin
2. Truy cập `/user-manager` → ✅ Thành công
3. Truy cập `/admin-manager` → ✅ Thành công
4. Truy cập `/court-manager` → ✅ Thành công
5. Truy cập `/service-manager` → ✅ Thành công
6. Truy cập `/court-rates-manager` → ✅ Thành công

### **Test Staff Access:**
1. Login với tài khoản Staff
2. Truy cập `/home` → ❌ Chuyển hướng về `/page-manager`
3. Truy cập `/user-manager` → ❌ Chuyển hướng về `/access-denied.jsp`
4. Truy cập `/admin-manager` → ❌ Chuyển hướng về `/access-denied.jsp`
5. Truy cập `/court-manager` → ❌ Chuyển hướng về `/access-denied.jsp`
6. Truy cập `/service-manager` → ❌ Chuyển hướng về `/access-denied.jsp`
7. Truy cập `/court-rates-manager` → ❌ Chuyển hướng về `/access-denied.jsp`

### **Test Customer Access:**
1. Login với tài khoản Customer
2. Truy cập `/home` → ✅ Thành công
3. Truy cập `/user-manager` → ❌ Chuyển hướng về `/access-denied.jsp`

## 📝 **Ghi chú quan trọng:**

1. **Session Attributes:**
   - `acc`: Object chứa thông tin user (UserDTO hoặc AdminDTO)
   - `accType`: String xác định loại user ("admin", "user", "google")

2. **Role Values:**
   - Admin: Không có field Role (được xác định qua accType = "admin")
   - Staff: Role = "Staff" (case-insensitive)
   - Customer: Role = "Customer" (case-insensitive)

3. **Filter Order:**
   - ProfileCheckFilter chạy đầu tiên (/*)
   - StaffAccessFilter chạy cho /home
   - StaffManagerAccessFilter chạy cho các trang manager
   - ManagerAccessFilter chạy cuối cùng

4. **Access Denied Page:**
   - URL: `/access-denied.jsp`
   - Auto redirect sau 10 giây về `/home`
   - Hiển thị thông tin phân quyền hệ thống 