package com.company;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalTime;
import java.time.format.DateTimeFormatterBuilder;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;

public abstract class Train {
    private LocalTime departTime;
    private LocalTime arrivalTime;
    private List<Station> stations;

    public Train(LocalTime departTime, LocalTime arrivalTime, List<Station> stations) {
        this.departTime = departTime;
        this.arrivalTime = arrivalTime;
        this.stations = stations;
    }

    public static Train read(Scanner scanner) {
        scanner.next();  // skip TRAIN (and new line character after END too if there's any):

        Train train = null;
        List<Station> stations = null;
        if (scanner.next().equals("INTERCITY")) {
            train = new Intercity(LocalTime.parse("00:00"), LocalTime.parse("00:00"), new ArrayList<Station>());
        } else {
            train = new Sprinter(LocalTime.parse("00:00"), LocalTime.parse("00:00"), new ArrayList<Station>());
        }

        // skip DEPARTS
        scanner.next();
        String departString = scanner.next();
        departString = departString.replace(".", ":");
        train.departTime = LocalTime.parse(departString);
        // skip ARRIVES
        scanner.next();
        String arrivalString = scanner.next();
        arrivalString = arrivalString.replace(".", ":");
        train.arrivalTime = LocalTime.parse(arrivalString);

        //skip newline character
        scanner.nextLine();
        while (scanner.hasNext()) {

            String next = scanner.nextLine();
            train.stations.add(Station.read(new Scanner(next)));
        }

        var type = train.getType();

        return train;
    }


    protected abstract String getType();

    public LocalTime getDepartTime() {
        return departTime;
    }

    public LocalTime getArrivalTime() {
        return arrivalTime;
    }

    public List<Station> getStations() {
        return stations;
    }

    /**
     * method for printing
     *
     * @return the train and time costs
     */
    public abstract String printShort();

    public String inMinutes() {
        Duration diff = Duration.between(getDepartTime(), getArrivalTime());

        return Long.toString(diff.toMinutes());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Train train = (Train) o;
        return Objects.equals(departTime, train.departTime) && Objects.equals(arrivalTime, train.arrivalTime) && Objects.equals(stations, train.stations);
    }

}
