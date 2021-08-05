package com.vianvi.test;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    public static String ENV = "stage";

    @Karate.Test
    Karate testAllTheTests() {
        return Karate.run("classpath:com/vianvi/feature/test/").karateEnv(ENV);
    }

}
