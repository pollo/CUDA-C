package org.n52.wps.server.algorithm.FBK; /************/

import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
//import org.geotools.coverage.FactoryFinder;
import org.geotools.coverage.grid.GridCoverage2D;
import org.geotools.coverage.grid.GridCoverageFactory;
import org.geotools.gce.geotiff.GeoTiffWriter;
import org.geotools.geometry.Envelope2D;
import org.n52.wps.io.data.IData;
import org.n52.wps.io.data.binding.literal.LiteralStringBinding;
import org.n52.wps.server.AbstractAlgorithm;
import org.n52.wps.server.algorithm.FBK.Tools.Models; //****/
import org.n52.wps.server.algorithm.FBK.Tools.RemoteDataHandler;  /***/

public class BotrixGeneral extends AbstractAlgorithm {
  Logger LOGGER = Logger.getLogger(BotrixGeneral.class);
  private List<String> errors = new ArrayList<String>();
  
  @Override
  public List<String> getErrors() {
    return errors;
  }
  
  @SuppressWarnings("unchecked")
    @Override
  public Class getInputDataType(String id) {
    
    if (id.equalsIgnoreCase("USER")) {
      return LiteralStringBinding.class;
    }
    
    if (id.equalsIgnoreCase("YEAR")) {
      return LiteralStringBinding.class;
    }
    if (id.equalsIgnoreCase("BBOX")) {
      return LiteralStringBinding.class;
    }
    return null;
  }
  
  @SuppressWarnings("unchecked")
    @Override
  public Class getOutputDataType(String id) {
    if (id.equalsIgnoreCase("result")) {
      return LiteralStringBinding.class;
    }return null;
  }
  
  @Override
  public Map<String, IData> run(Map<String, List<IData>> inputData) {
    int year = 0;
    double degrees = 0;
    String user = null;
    String bbox = null;
    if (inputData==null || !inputData.containsKey("USER")){
      throw new RuntimeException("Error while allocating input parameters");
    }
    List<IData> dataList = inputData.get("USER");
    if(dataList == null || dataList.size() != 1){
      throw new RuntimeException("Error while allocating input parameters");
    }
    
    user = ((LiteralStringBinding)dataList.get(0)).getPayload();
    
    if (inputData==null || !inputData.containsKey("BBOX")){
      throw new RuntimeException("Error while allocating input parameters");
    }
    dataList = inputData.get("BBOX");
    if(dataList == null || dataList.size() != 1){
      throw new RuntimeException("Error while allocating input parameters");
    }
    
    bbox = ((LiteralStringBinding)dataList.get(0)).getPayload();
    
    
    
    if (inputData==null || !inputData.containsKey("YEAR")){
      throw new RuntimeException("Error while allocating input parameters");
    }
    dataList = inputData.get("YEAR");
    if(dataList == null || dataList.size() != 1){
      throw new RuntimeException("Error while allocating input parameters");
    }
    try{
      year = Integer.parseInt(((LiteralStringBinding)dataList.get(0)).getPayload());
    }catch(Exception e){
      HashMap<String, IData> result = new HashMap<String, IData>();
      result.put("BOTRIX_RISK" , new LiteralStringBinding("Error during excecution. Invalid input parameters: YEAR."));  
      return result;
    }

    
    
    try{
      ColorModel colormodel = null;
      
      Envelope2D envelope = null;
      String workspace = "WPS_"+user+"_BotrixGeneral_"+year+"_"+degrees;
      String url_output = "/nfsmnt/tonga0/ssi/zarbo/apache/htdocs/data/"+workspace+"/";
      File output_file = new File(url_output);
      
      if(!output_file.exists()){
	if(output_file.mkdirs() == false){
	  throw new RuntimeException("Error while allocating the output space.");
	}
      }
      
      WritableRaster tempday = null;
      WritableRaster precday = null;
      WritableRaster botrix = null;
      
      GridCoverageFactory fact = new GridCoverageFactory();
      


      GridCoverage2D botrix_gc = null;
      BufferedImage img = null;






      
      String month,day;


      LinkedList<String> tp = new LinkedList<String>();

      String[] aspect_ratio; 


      
      
      for(int i=1; i<=12; i++){
	if (i<10) month = "0"+i;	 	
	else month = ""+i;
	for(int j=1; j<=31; j++){ 			  
	  if(j<10) day="0"+j;  			
	  else day = ""+j;
	  aspect_ratio = RemoteDataHandler.getAdjustedAspectRatio("http://geodata.fbk.eu:50003/geoserver/wcs", "Temperatures_"+year, "Tgrd_"+year+month+day+"_AVG", bbox, "EPSG:32632");
	  if(aspect_ratio != null){
	    tp.add("http://geodata.fbk.eu:50003/geoserver/wcs?service=WCS&request=GetCoverage&coverage=Temperatures_"+year+":Tgrd_"+year+month+day+"_AVG&version=1.0.0&format=geotiff&CRS=EPSG:32632&BBOX="+aspect_ratio[0]+"&width="+aspect_ratio[1]+"&height="+aspect_ratio[2]+"&srs=EPSG:32632");
	  }
	}
      }
      




      month = null;
      day = null;




      month = null;
      day = null;
      
      String[] date = new String[366];
      int k_julian = 0;
      for(int i=1; i<=12; i++){
	if(i<10) month = "0"+i;
	else month = ""+i;
	for(int j=1; j<=31; j++){
	  if(j<10) day="0"+j;
	  else day = ""+j;
	  
	  if(((i==2)|| (i==4) || (i==6) || (i==9) ||(i==11))&&(j==31)){
	    continue;
	  }
	  if((((year % 4) == 0) && ((year % 400) == 0)) ||(((year % 4) == 0) && ((year % 100) != 0))){
	    if((i==2) && (j==30)){
	      continue;
	    }
	  }else{
	    if((i==2) && ((j==30)||(j==29))){
	      continue;
	    }
	  }
	  
	  date[k_julian] = year+month+day;
	  k_julian++;
	  
	}
      }
      
      
      String request = null;
      BufferedImage img_1= null;
      BufferedImage img_2 = null;
      
      
      for (int i= 1; i < 367; i++){
	aspect_ratio = RemoteDataHandler.getAdjustedAspectRatio("http://geodata.fbk.eu:50003/geoserver/wcs", "WetLeaf", "pp_daily_"+i, bbox, "EPSG:32632");
	if(aspect_ratio != null){
	  request = "http://geodata.fbk.eu:50003/geoserver/wcs?service=WCS&request=GetCoverage&coverage=WetLeaf:pp_daily_"+i+"&version=1.0.0&format=geotiff&CRS=EPSG:32632&BBOX="+aspect_ratio[0]+"&width="+aspect_ratio[1]+"&height="+aspect_ratio[2]+"&srs=EPSG:32632";
	}
	else {
	  request = "http://geodata.fbk.eu:50003/geoserver/wcs?service=WCS&request=GetCoverage&coverage=WetLeaf:pp_daily_"+i+"&version=1.0.0&format=geotiff&CRS=EPSG:32632&BBOX="+bbox+"&width=582&height=489&srs=EPSG:32632";
	}
	//System.out.println(request);
	if ((img_2 = RemoteDataHandler.getBufferedImage(request))!= null && (img_1=RemoteDataHandler.getBufferedImage(tp.get(i-1)))!= null)
	{
	  if (envelope == null){
	    colormodel = img_1.getColorModel();
	    envelope = RemoteDataHandler.getEnvelope2D(tp.get(i));
	    botrix = img_1.getData().createCompatibleWritableRaster();
	    if(RemoteDataHandler.CreateWorkspace(workspace, "http://geodata.fbk.eu:50007", "geoserver", "admin") != false){
	      System.out.println("WorkSpace successfully create.");
	    }else{
	      throw new RuntimeException("Failed to create WorkSpace.");
	    }
	  }
	  tempday = img_1.copyData(null);
	  precday = img_2.copyData(null);
	  
	  if (tempday.getDataBuffer().getSize() != precday.getDataBuffer().getSize()){
	    System.out.println(tempday.getDataBuffer().getSize());
	    System.out.println(precday.getDataBuffer().getSize());
	    HashMap<String, IData> result = new HashMap<String, IData>();
	    result.put("BOTRIX_RISK", new LiteralStringBinding("Error Occour. Inputs mismatch."));
	    return result;
	  }
	  
	  for (int k = 0; k < tempday.getDataBuffer().getSize(); k++){
	    if(tempday.getDataBuffer().getElemFloat(k) != -9999 && precday.getDataBuffer().getElemFloat(k) != -9999){
	      if(tempday.getDataBuffer().getElemFloat(k) < 12) {
		tempday.getDataBuffer().setElemFloat(k, 12);
	      }
	      if(tempday.getDataBuffer().getElemFloat(k) > 32 && tempday.getDataBuffer().getElemFloat(k)< 40){
		tempday.getDataBuffer().setElemFloat(k, 32);
	      }
	      botrix.getDataBuffer().setElemFloat(k, (float) Models.BotrixIndex(tempday.getDataBuffer().getElemDouble(k), precday.getDataBuffer().getElemDouble(k)));
	      if(tempday.getDataBuffer().getElemFloat(k)>= 40) {
		botrix.getDataBuffer().setElemFloat(k, 0);
	      }
	      if(precday.getDataBuffer().getElemFloat(k) < 4){
		botrix.getDataBuffer().setElemFloat(k, 0);
	      }
	    }else{
	      botrix.getDataBuffer().setElemFloat(k, -9999);
	    }
	  }
	  
	  img = new BufferedImage(colormodel, botrix, false, null);
	  botrix_gc = fact.create("Botrix Risk", img, envelope);
	  
	  new GeoTiffWriter(new File(url_output+"botrix_risk_chardonnay_"+date[i-1]+"_E_.tif")).write(botrix_gc, null);
	  Process p = Runtime.getRuntime().exec("gdal_translate -a_srs EPSG:32632 "+url_output+"botrix_risk_chardonnay_"+date[i-1]+"_E_.tif"+" "+url_output+"botrix_risk_chardonnay_"+date[i-1]+".tif");
	  try {
	    p.waitFor();
	  } catch (InterruptedException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	  }
	  
	  new File(url_output+"botrix_risk_chardonnay_"+date[i-1]+"_E_.tif").delete();
	  
	  if(RemoteDataHandler.CreateCoverageStore(url_output+"botrix_risk_chardonnay_"+date[i-1]+".tif", workspace,"http://geodata.fbk.eu:50007", "geoserver", "admin")!= false){
	    System.out.println("CoverageStore successfully create.");
	    if(RemoteDataHandler.CreateCoverage(url_output+"botrix_risk_chardonnay_"+date[i-1]+".tif", workspace,"http://geodata.fbk.eu:50007", "geoserver", "admin", (botrix.getWidth()+""),(botrix.getHeight()+""), bbox )!= false){
	      System.out.println("Coverage successfully create.");
	      if(RemoteDataHandler.CreateLayer(url_output+"botrix_risk_chardonnay_"+date[i-1]+".tif", workspace,"http://geodata.fbk.eu:50007", "geoserver", "admin")!= false){
		System.out.println("Layer successfully create.");
	      }
	      else{
		throw new RuntimeException("Failed to create Layer.");
	      }
	    }
	    else{
	      throw new RuntimeException("Failed to create Coverage.");
	    }
	  }
	  else{
	    throw new RuntimeException("Failed to create Coveragestore.");
	  }
	  
	}
	
      }	    	    
      
      
      HashMap<String, IData> result = new HashMap<String, IData>();
      result.put("BOTRIX_RISK", new LiteralStringBinding(workspace));
      return result;
      
      
    }catch(IOException e){
      HashMap<String, IData> result = new HashMap<String, IData>();
      result.put("BOTRIX_RISK", new LiteralStringBinding("Error Occour."));
      return result;
    }
    
  }
  
}
