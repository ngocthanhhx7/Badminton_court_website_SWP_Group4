/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author PC - ACER
 */
public class ServiceDTO {

    private int ServiceID;
    private String ServiceName;
    private String ServiceType;
    private String Description;
    private String Unit;
    private double Price;
    private String Status;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
   

    public ServiceDTO() {
    }

    public ServiceDTO(int ServiceID, String ServiceName, String ServiceType, String Description, String Unit, double Price, String Status, Integer CreatedBy, Timestamp CreatedAt, Timestamp UpdatedAt) {
        this.ServiceID = ServiceID;
        this.ServiceName = ServiceName;
        this.ServiceType = ServiceType;
        this.Description = Description;
        this.Unit = Unit;
        this.Price = Price;
        this.Status = Status;
        this.CreatedBy = CreatedBy;
        this.CreatedAt = CreatedAt;
        this.UpdatedAt = UpdatedAt;
    }

    public int getServiceID() {
        return ServiceID;
    }

    public void setServiceID(int ServiceID) {
        this.ServiceID = ServiceID;
    }

    public String getServiceName() {
        return ServiceName;
    }

    public void setServiceName(String ServiceName) {
        this.ServiceName = ServiceName;
    }

    public String getServiceType() {
        return ServiceType;
    }

    public void setServiceType(String ServiceType) {
        this.ServiceType = ServiceType;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public String getUnit() {
        return Unit;
    }

    public void setUnit(String Unit) {
        this.Unit = Unit;
    }

    public double getPrice() {
        return Price;
    }

    public void setPrice(double Price) {
        this.Price = Price;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public Integer getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(Integer CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp CreatedAt) {
        this.CreatedAt = CreatedAt;
    }

    public Timestamp getUpdatedAt() {
        return UpdatedAt;
    }

    public void setUpdatedAt(Timestamp UpdatedAt) {
        this.UpdatedAt = UpdatedAt;
    }

}
