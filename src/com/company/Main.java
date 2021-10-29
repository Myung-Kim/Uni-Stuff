package com.company;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        // write your code here
        TrainDB db = null;
        try {
            db = TrainDB.read(new Scanner(new File("resources/trains.txt")));
        } catch (IOException e) {
            e.printStackTrace();
        }

        PrintWriter pw = new PrintWriter(System.out);

        Scanner sc = new Scanner(System.in);

        db.printOptions();
        while (sc.hasNextInt()) {
            int option = sc.nextInt();
            switch (option) {
                case 1:
                    for (Train train : db.getTrains()) {
                        pw.print(train);
                    }
                    pw.flush();
                    System.out.printf("\n");
                    break;
                case 2:
                    db.printShort();
                    break;
                case 3:
                    Scanner stopSc = new Scanner(System.in);
                    System.out.println("enter station name: ");

                    db.stopsAt(stopSc.next());
            }
            db.printOptions();
            if (option == 4) {
                break;
            }
        }

        pw.flush();


    }
}
