package com.company;

import java.time.LocalTime;
import java.util.List;

public class Intercity extends Train {
    public Intercity(LocalTime departTime, LocalTime arrivalTime, List<Station> stations) {
        super(departTime, arrivalTime, stations);
    }

    @Override
    protected String getType() {
        return "INTERCITY";
    }

    public String printShort() {
        String result = "";
        result = "Intercity from " + getStations().get(0).getName() + " to " + getStations().get(getStations().size() - 1).getName() + "takes " + super.inMinutes() + " minutes\n";

        return result;
    }



    @Override
    public String toString() {
        String result = "";
        result = "Intercity from " + getStations().get(0).getName() + " to " + getStations().get(getStations().size() - 1).getName() + "\n";
        result += "\t" + "Departure: " + getDepartTime() + "\n";
        result += "\t" + "Arrival: " + getArrivalTime() + "\n";

        for (Station station : getStations()) {
            if (station.getIC()) {
                result += "---" + station.getName() + "\n";
            } else {
                result += "----(" + station.getName() + ")\n";
            }


        }
        return result;
    }


}
