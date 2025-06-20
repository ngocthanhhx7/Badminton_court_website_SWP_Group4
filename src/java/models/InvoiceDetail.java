/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.math.BigDecimal;
import java.util.Date;

public class InvoiceDetail {
    private int invoiceDetailID;
    private int invoiceID;
    private String itemType;
    private int itemID;
    private String itemName;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private String status;
    private Integer createdBy;
    private Date createdAt;

    public InvoiceDetail(int invoiceDetailID, int invoiceID, String itemType, int itemID, String itemName,
                         int quantity, BigDecimal unitPrice, BigDecimal subtotal, String status,
                         Integer createdBy, Date createdAt) {
        this.invoiceDetailID = invoiceDetailID;
        this.invoiceID = invoiceID;
        this.itemType = itemType;
        this.itemID = itemID;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    public void setInvoiceDetailID(int invoiceDetailID) {
        this.invoiceDetailID = invoiceDetailID;
    }

    public void setInvoiceID(int invoiceID) {
        this.invoiceID = invoiceID;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

 
    public int getInvoiceDetailID() { return invoiceDetailID; }
    public int getInvoiceID() { return invoiceID; }
    public String getItemType() { return itemType; }
    public int getItemID() { return itemID; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getSubtotal() { return subtotal; }
    public String getStatus() { return status; }
    public Integer getCreatedBy() { return createdBy; }
    public Date getCreatedAt() { return createdAt; }
}

