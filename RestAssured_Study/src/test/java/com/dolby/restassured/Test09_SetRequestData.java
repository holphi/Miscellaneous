package com.dolby.restassured;

import org.testng.annotations.Test;

import static io.restassured.RestAssured.*;
import static io.restassured.path.json.JsonPath.*;

import java.util.ArrayList;
import java.util.List;

/**
 * This class is to set different type of data in request call
 * */
public class Test09_SetRequestData {
	
	/**
	 * Generally CONNECZT used with HTTPS request
	 * */
	@Test
	public void testConnectRequest() {
		
		when().
			request("CONNECT", "https://api.fonts.com/rest/json/Accounts").
		then().
			statusCode(400);
	}
	
	/**
	 * In GET request we can set query parameter
	 * */
	@Test
	public void testQueryParameters()
	{
		given().
			queryParam("A", "A val").
			queryParam("B", "B val").
		when().
			get("https://api.fonts.com/rest/json/Accounts").
		then().
			statusCode(400);
	}
	
	/**
	 * In POST request we can set form parameter
	 * */
	@Test
	public void testFormParameters()
	{
		given().
			formParam("A", "A val").
			formParam("B", "B val").
		when().
			post("https://api.fonts.com/rest/json/Accounts").
		then().
			statusCode(400);
	}
	
	/*
	 * To set parameters -recommended way
	 * If request is GET then params will be treated as QueryParameter
	 * If request is POST then params will be treated as FormParameter
	 * **/
	@Test
	public void testSetParameters()
	{	
		given().
			param("A", "A-value").
			param("B", "B-value").
		when().
			get("https://api.fonts.com/rest/json/Accounts").
		then().
			statusCode(400);
	}
	
	/**
	 * To set multiple value parameters
	 * 
	 * We can pass list, multiple values or no values into param() method
	 * */
	@Test
	public void testSetMultiValueParameters(){
		
		List<String> list = new ArrayList<String>();
		list.add("one");
		list.add("two");
		
		given().
			param("A", "val1", "val2", "val3").
			param("B").
			param("C", list).
		when().
			get("https://api.fonts.com/rest/json/Accounts").
		then().
			statusCode(400);
	}
}
