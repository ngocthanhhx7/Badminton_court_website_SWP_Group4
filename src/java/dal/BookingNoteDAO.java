package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.BookingNotesDTO;
import utils.DBUtils;
import java.time.LocalDateTime;

public class BookingNoteDAO {

    public boolean addNote(BookingNotesDTO note) {
    String sql = """
            INSERT INTO BookingNotes (BookingID, CustomerID, NoteType, NoteDetails, Rating, Status, CreatedAt, CreatedBy)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, note.getBookingID());
            ps.setInt(2, note.getCustomerID());
            ps.setString(3, note.getNoteType());
            ps.setString(4, note.getNoteDetails());
            ps.setInt(5, note.getRating());
            ps.setString(6, note.getStatus());
            ps.setTimestamp(7, Timestamp.valueOf(note.getCreatedAt()));
            ps.setInt(8, note.getCreatedBy());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int noteId = rs.getInt(1);
                        note.setNoteID(noteId); 
                    }
                }
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean updateNote(BookingNotesDTO note) {
        String sql = """
            UPDATE BookingNotes
            SET NoteType = ?, NoteDetails = ?, Rating = ?, Status = ?
            WHERE NoteID = ?
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, note.getNoteType());
            ps.setString(2, note.getNoteDetails());
            ps.setInt(3, note.getRating());
            ps.setString(4, note.getStatus());
            ps.setInt(5, note.getNoteID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNote(int noteId) {
        String sql = "DELETE FROM BookingNotes WHERE NoteID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noteId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BookingNotesDTO> findByBookingId(int bookingId) {
        String sql = "SELECT * FROM BookingNotes WHERE BookingID = ?";
        List<BookingNotesDTO> notes = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingNotesDTO note = new BookingNotesDTO();
                note.setNoteID(rs.getInt("NoteID"));
                note.setBookingID(rs.getInt("BookingID"));
                note.setCustomerID(rs.getInt("CustomerID"));
                note.setNoteType(rs.getString("NoteType"));
                note.setNoteDetails(rs.getString("NoteDetails"));
                note.setRating(rs.getInt("Rating"));
                note.setStatus(rs.getString("Status"));
                note.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                note.setCreatedBy(rs.getInt("CreatedBy"));
                notes.add(note);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return notes;
    }
    
    public List<BookingNotesDTO> findByBookingIdAndCustomerID(int bookingId, int customerId) {
        String sql = "SELECT * FROM BookingNotes WHERE BookingID = ? AND CustomerID = ?";
        List<BookingNotesDTO> notes = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingNotesDTO note = new BookingNotesDTO();
                note.setNoteID(rs.getInt("NoteID"));
                note.setBookingID(rs.getInt("BookingID"));
                note.setCustomerID(rs.getInt("CustomerID"));
                note.setNoteType(rs.getString("NoteType"));
                note.setNoteDetails(rs.getString("NoteDetails"));
                note.setRating(rs.getInt("Rating"));
                note.setStatus(rs.getString("Status"));
                note.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                note.setCreatedBy(rs.getInt("CreatedBy"));
                notes.add(note);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return notes;
    }

    public double getAverageRatingByCourtId(int courtId) {
        String sql = """
            SELECT AVG(bn.Rating) AS AvgRating
            FROM BookingNotes bn
            JOIN Bookings b ON bn.BookingID = b.BookingID
            JOIN BookingDetails bd ON b.BookingID = bd.BookingID
            WHERE bd.CourtID = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courtId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("AvgRating");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public List<String> getTop3RatingNotesByCourtId(int courtId) {
        String sql = """
            SELECT TOP 3 bn.NoteDetails
            FROM BookingNotes bn
            JOIN Bookings b ON bn.BookingID = b.BookingID
            JOIN BookingDetails bd ON b.BookingID = bd.BookingID
            WHERE bd.CourtID = ?
            ORDER BY bn.Rating DESC
        """;

        List<String> topNotes = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courtId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                topNotes.add(rs.getString("NoteDetails"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return topNotes;
    }

}
