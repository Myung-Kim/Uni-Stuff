package com.company;

import java.util.Scanner;

public class Station {
    private String name;
    private Boolean isIC;

    public Station(String name, Boolean isIC) {
        this.name = name;
        this.isIC = isIC;
    }

    public static Station read(Scanner scanner) {
        Station station = new Station("", false);
        if (scanner.next().equals("IC-STATION:")) {
            station.isIC = true;
        }
        station.name = scanner.next();
        return station;
    }

    // need to change
    @Override
    public String toString() {
        if (this.isIC) {
            return "\t----(" + this.name + ")\n";
        } else {
            return "\t---" + this.name + "\n";
        }

    }

    public String getName() {
        return name;
    }

    public Boolean getIC() {
        return isIC;
    }
}
