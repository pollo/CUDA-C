public static double BotrixIndex (double x, double y){
        double b0 = -2.647866;
        double b1 = -0.374927;
        double b2 = 0.061601;
        double b3 = -0.001511;
       
       
        return Math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))) / (1+Math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))));
    }
