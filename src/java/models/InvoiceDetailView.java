package models;

public class InvoiceDetailView {
    private int invoiceDetailID;
    private int invoiceID;
    private String itemType;
    private int itemID;
    private String itemName;
    private int quantity;
    private double unitPrice;
    private double subtotal;
    private String status;

    private String customerName; // thêm
    private String username;     // thêm

    public InvoiceDetailView(int invoiceDetailID, int invoiceID, String itemType, int itemID, String itemName,
                             int quantity, double unitPrice, double subtotal, String status) {
        this.invoiceDetailID = invoiceDetailID;
        this.invoiceID = invoiceID;
        this.itemType = itemType;
        this.itemID = itemID;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
        this.status = status;
    }

    // Constructor mở rộng nếu bạn muốn dùng khi truy vấn
    public InvoiceDetailView(int invoiceDetailID, int invoiceID, String itemType, int itemID, String itemName,
                             int quantity, double unitPrice, double subtotal, String status,
                             String customerName, String username) {
        this(invoiceDetailID, invoiceID, itemType, itemID, itemName, quantity, unitPrice, subtotal, status);
        this.customerName = customerName;
        this.username = username;
    }

    // Getters
    public int getInvoiceDetailID() { return invoiceDetailID; }
    public int getInvoiceID() { return invoiceID; }
    public String getItemType() { return itemType; }
    public int getItemID() { return itemID; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }
    public double getUnitPrice() { return unitPrice; }
    public double getSubtotal() { return subtotal; }
    public String getStatus() { return status; }

    public String getCustomerName() { return customerName; }
    public String getUsername() { return username; }

    // Setters (nếu cần set riêng)
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
