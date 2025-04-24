package mypackage.models;
import java.util.Date;
public class Booking {
    private int bookingId;
    private Date date;
    private String type;

    public Booking(int bookingId, Date date, String type) {
        this.bookingId = bookingId;
        this.date = date;
        this.type = type;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setStartTime(String string) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'setStartTime'");
    }
}
