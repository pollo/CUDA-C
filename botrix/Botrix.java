import java.io.*;

public class Botrix
{
  public static void main(String[] args)
    {
      float temp[]=new  float[284672];
      float prec[]=new  float[284672];
      float botrix[]=new  float[284672];
      int i=0;
      try {
	File file_temp = new File("Tgrd_20040815_AVG.txt");
	BufferedReader read_temp= new BufferedReader(new FileReader(file_temp));
	String line=read_temp.readLine();
	i=0;
	for (String tmp:line.split(" "))
	{
	  temp[i]=Float.valueOf(tmp);
	  i+=1;
	}
	File file_prec = new File("Pgrd_20010115_AVG.txt");
	BufferedReader read_prec= new BufferedReader(new FileReader(file_prec));
	line=read_prec.readLine();
	i=0;
	for (String tmp:line.split(" "))
	{
	  prec[i]=Float.valueOf(tmp);
	  i+=1;
	}
      } catch (IOException e) {}


      long startTime = System.currentTimeMillis();
      for (int j=0; j<367; j++)
      { 
	for (int k = 0; k < i; k++)
	{
	  if(temp[k] != -9999 && prec[k] != -9999)
	  {
	    if(temp[k] < 12) {
	      temp[k]=12;
	    }
	    if(temp[k] > 32 && temp[k]< 40){
	      temp[k]=32;
	    }
	    botrix[k]= (float) botrixIndex(temp[k],prec[k]);
	    if(temp[k]>= 40) {
	      botrix[k]=0;
	    }
	    if(prec[k] < 4){
	      botrix[k]= 0;
	    }
	  }else{
	    botrix[k]= -9999;
	  }
	}
      }
      long endTime = System.currentTimeMillis();
      System.out.println( "Tempo impiegato java:\n" + ((endTime - startTime)/1000.0) );


      try {
	File file_temp = new File("output_java.txt");
	BufferedWriter writer= new BufferedWriter(new FileWriter(file_temp));
	for (int k =0; k<i; k++)
	{
	  writer.write(Float.toString(botrix[k])+" ");
	}
      } catch (IOException e) {}
    }

  static public double botrixIndex (double x, double y)
    {
        double b0 = -2.647866;
        double b1 = -0.374927;
        double b2 = 0.061601;
        double b3 = -0.001511;
       
	return Math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))) / (1+Math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))));
    }
}