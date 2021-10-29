package com.company;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class TrainDB {
    private List<Train> trains;

    public TrainDB(List<Train> trains) {
        this.trains = trains;
    }

    public static TrainDB read(Scanner scanner) {
        List<Train> trains = new ArrayList<>();
        scanner.useDelimiter("END");
        while (scanner.hasNext()) {
            trains.add(Train.read(new Scanner(scanner.next())));
        }

        return new TrainDB(trains);
    }

    public void printOptions() {
        System.out.println("Please make your choice:\n" +
                "1 – Show all trains that are in the in-memory database on screen.\n" +
                "2 – Show the travel times of all train lines.\n" +
                "3 – Show all trains that stop at a given station.\n" +
                "4 – Stop the program\n");

    }

    public List<Train> getTrains() {
        return trains;
    }

    public void printShort() {
        for (Train train : trains) {
            System.out.println(train.printShort());
        }
    }

    public void stopsAt(String name) {
        //Predicate<Train> trainFilter = train -> train.getStations().forEach(s -> s.getName().contains("sd"));

        List<Train> result1 = trains.stream().filter(x -> x.getType().equals("INTERCITY"))
                .filter(
                        x -> x.getStations().stream().anyMatch(s -> s.getName().toLowerCase().contains(name.toLowerCase()) && s.getIC() == true))
                .collect(Collectors.toList());
        List<Train> result2 = trains.stream().filter(x -> x.getType().equals("SPRINTER")).filter(
                        x -> x.getStations().stream().anyMatch(s -> s.getName().toLowerCase().contains(name.toLowerCase())))
                .collect(Collectors.toList());

        // join two lists
        result1.addAll(result2);

        PrintWriter pw = new PrintWriter(System.out);

        result1.stream().forEach(train -> pw.print(train));
        pw.flush();
        System.out.printf("\n");


    }
}
