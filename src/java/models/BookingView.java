package models;

import java.sql.Timestamp;

public class BookingView {
    private int bookingID;
    private String customerName;
    private String phone;
    private String email;
    private String courtName;
    private Timestamp bookingTime;
    private int durationHours;
    private String status;
    private String noteDetails;
    private String noteStatus;
    private double hourlyRate;
    private double subtotal;

    // Getters and Setters
    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCourtName() { return courtName; }
    public void setCourtName(String courtName) { this.courtName = courtName; }

    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }

    public int getDurationHours() { return durationHours; }
    public void setDurationHours(int durationHours) { this.durationHours = durationHours; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNoteDetails() { return noteDetails; }
    public void setNoteDetails(String noteDetails) { this.noteDetails = noteDetails; }

    public String getNoteStatus() { return noteStatus; }
    public void setNoteStatus(String noteStatus) { this.noteStatus = noteStatus; }

    public double getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(double hourlyRate) { this.hourlyRate = hourlyRate; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    @Override
    public String toString() {
        return "BookingView{" +
                "bookingID=" + bookingID +
                ", customerName='" + customerName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", courtName='" + courtName + '\'' +
                ", bookingTime=" + bookingTime +
                ", durationHours=" + durationHours +
                ", status='" + status + '\'' +
                ", noteDetails='" + noteDetails + '\'' +
                ", noteStatus='" + noteStatus + '\'' +
                ", hourlyRate=" + hourlyRate +
                ", subtotal=" + subtotal +
                '}';
    }
}

