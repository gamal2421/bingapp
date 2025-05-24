package mypackage.models;
import java.sql.Time;

public class GameSlot {
    private int slotId;
    private Time startTime;
    private Time endTime;
    private String genderGroup;
    private String status;

    public GameSlot(Time endTime, String genderGroup, int slotId, Time startTime, String status) {
        this.endTime = endTime;
        this.genderGroup = genderGroup;
        this.slotId = slotId;
        this.startTime = startTime;
        this.status = status;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public String getGenderGroup() {
        return genderGroup;
    }

    public void setGenderGroup(String genderGroup) {
        this.genderGroup = genderGroup;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

