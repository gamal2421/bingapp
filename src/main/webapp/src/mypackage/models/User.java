package mypackage.models;
import java.util.Date;

public class User {
    protected int id;
    protected String firstName;
    protected String lastName;
    protected String gender;
    protected Date dob;


    public void login() {}
    public void book() {}
    public void seeAvailableSlots() {}
    public void cancelSlot() {}
    public void showBookedSlots() {}

    public User(int id, String firstName, String lastName , String gender, Date dob ) {
        this.dob = dob;
        this.firstName = firstName;
        this.gender = gender;
        this.id = id;
        this.lastName = lastName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
