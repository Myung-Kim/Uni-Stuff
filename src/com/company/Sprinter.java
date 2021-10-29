package com.company;

import java.time.LocalTime;
import java.util.List;

public class Sprinter extends Train {
    public Sprinter(LocalTime departTime, LocalTime arrivalTime, List<Station> stations) {
        super(departTime, arrivalTime, stations);
    }

    @Override
    protected String getType() {
        return "SPRINTER";
    }

    /**
     * print all trains and it's time consumed
     *
     * @return returns string
     */
    @Override
    public String printShort() {
        String result = "";
        result = "Sprinter from " + getStations().get(0).getName() + " to " + getStations().get(getStations().size() - 1).getName() + "takes " + inMinutes() + " minutes\n";

        return result;
    }


    @Override
    public String toString() {
        String result = "";
        result = "Sprinter from " + getStations().get(0).getName() + " to " + getStations().get(getStations().size() - 1).getName() + "\n";
        result += "\t" + "Departure: " + getDepartTime() + "\n";
        result += "\t" + "Arrival: " + getArrivalTime() + "\n";

        for (Station station : getStations()) {
            result += "---" + station.getName() + "\n";
        }
        return result;
    }
}
