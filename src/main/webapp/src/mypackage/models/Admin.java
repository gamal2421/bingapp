package mypackage.models;
import java.util.Date;

public class Admin extends User {

    public Admin(int id, String firstName, String lastName, String gender, Date dob) {
        super(id, firstName, lastName, gender, dob);
    }

    public void delete() {}
    public void bookForOthers() {}
    public void viewReport() {}
    public void modifySlot() {}
    public void switchTime() {}


}
