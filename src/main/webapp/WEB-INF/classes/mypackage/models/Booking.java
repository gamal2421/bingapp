package mypackage.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import mypackage.utl.DataBase;

public class Booking {
    private int bookingId;
    private Date gameDate;
    private String startTime;
    private String endTime;
    private String gameType;
   

    public Booking(int bookingId, Date gameDate, String startTime, String endTime, String gameType) {
        this.bookingId = bookingId;
        this.gameDate = gameDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.gameType = gameType;
   
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getGameDate() {
        return gameDate;
    }

    public void setGameDate(Date gameDate) {
        this.gameDate = gameDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getGameType() {
        return gameType;
    }

    public void setGameType(String gameType) {
        this.gameType = gameType;
    }

    
}