class Assignment3_2 {

    public static int max(int[] seq) {
        int max = Integer.MIN_VALUE;
        for (int i : seq) {
            if (i > max) {
                max = i;
            }

        }
        return max;
    }

    public static int index(int[] seq, int el) {

        for (int i = 0; i < seq.length; i++) {
            if (seq[i] == el) {
                return i;
            }
        }
        return -1;
    }

    public static boolean contains(int[] seq, int el) {
        for (int i : seq) {
            if (i == el) {
                return true;
            }
        }
        return false;
    }

    public static boolean isPrime(int el) {
        if (el > 1) {
            for (int i = 2; i < el; i++) {
                if (el % i == 0) {
                    return false;
                }
            }
            return true;
        } else {
            throw new IllegalArgumentException();
        }
    }

    public static int countPrimes(int[] seq) {
        int primes = 0;

        for (int number : seq) {

            boolean isPrime = true;

            for (int i = 2; i < number; i++) {
                if (number % i == 0) {
                    isPrime = false;
                    break; // jump to next number if it is prime
                }
            }

            if (isPrime == true) {
                primes++;
            }


        }

        return primes;
    }

    public static int[] primesIn(int[] seq) {
        int primes = 0;
        int n = seq.length;
        int[] primeSeq = new int[n];

        for (int number : seq) {

            boolean isPrime = true;

            for (int i = 2; i < number; i++) {
                if (number % i == 0) {
                    isPrime = false;
                    break; // jump to next number if it is prime
                }
            }

            if (isPrime == true) {
                primeSeq[primes] = number;
                primes++;
            }

        }

        int[] compact = new int[primes];
        for (int i = 0; i < primes; i++) {
            compact[i] = primeSeq[i];
        }
        return compact;
    }

    public static int[] primesUpTo(int n) {

        int primes = 0;
        int[] primeSeq = new int[n];

        for (int i = 2; i < n; i++) {
            boolean isPrime = true;

            for (int j = 2; j < i; j++) {
                if (i % j == 0) {
                    isPrime = false;
                    break; // jump to next number if it is prime
                }
            }

            if (isPrime == true) {
                primeSeq[primes] = i;
                primes++;
            }
        }


        int[] compact = new int[primes];
        for (int i = 0; i < primes; i++) {
            compact[i] = primeSeq[i];
        }
        return compact;
    }

}
