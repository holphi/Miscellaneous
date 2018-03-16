package com.dolby.restassured;

import static org.hamcrest.Matchers.*;
import static io.restassured.RestAssured.*;
import static io.restassured.path.json.JsonPath.*;

import org.testng.annotations.Test;
import java.util.List;

public class Test06_GroovyFeatures 
{
  
	/*
	 * Verify if some expected name present in response or not
	 * */
	@Test
	public void testPresenceOfElements() 
	{
		given().
			get("http://services.groupkt.com/country/search?text=lands").
		then().
			body("RestResponse.result.name", hasItems("Cayman Islands", "Marshall Islands")).log().all();
	}
	
	/*
	 * RestAssured implemented in Groovy and hence Groovy advantages can be taken
	 * Here we are adding length of all "alpha2_code" coming in response
	 * */
	@Test
	public void testLengthOfResponse()
	{
		given().
			get("http://services.groupkt.com/country/search?text=lands").
		then().
			body("RestResponse.result.alpha3_code*.length().sum()", greaterThan(40));
	}
	
	/*
	 * To get all attribute as List
	 * */
	@Test
	public void testGetResponseAsList()
	{
		String response = get("http://services.groupkt.com/country/search?text=lands").asString();
		
		List<String> ls = from(response).getList("RestResponse.result.name");
		
		System.out.println(ls.size());
		
		for(String country: ls){
			if(country.equals("Solomon Island"))
				System.out.println("Found my place");
		}
	}
	
	/*
	 * To get response as List and apply some conditions on it
	 * 
	 * The Groovy has an implict variable called 'it' which represents current item in the list
	 * 
	 * */
	@Test
	public void testConditionsOnList()
	{
		String response = get("http://services.groupkt.com/country/search?text=lands").asString();
		
		List<String> ls = from(response).getList("RestResponse.result.findAll{ it.name.length() > 40}.name");
		
		System.out.println(ls);
	}
}
