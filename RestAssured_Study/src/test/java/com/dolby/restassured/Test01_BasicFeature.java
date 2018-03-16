package com.dolby.restassured;

import org.testng.annotations.Test;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class Test01_BasicFeature {
	
	/*
	 * Check status code
	 * */
	//@Test
	public void testStatusCode() 
	{
		given()
			.get("http://jsonplaceholder.typicode.com/posts/3").
		then()
			.statusCode(200);
	}
	
	/*
	 * It will verify code and print complete response in console
	 * */
	//@Test
	public void testLogging()
	{
		given()
			.get("http://services.groupkt.com/country/get/iso2code/in").
		then().
			statusCode(200).
			log().all();
	}
	
	
	/*
	 * Parameters and headers can be set
	 * */
	//@Test
	public void testParametersandHeaders()
	{
		given()
			.param("key1", "value1")
			.header("head1", "value1").
		when()
			.get("http://services.groupkt.com/country/get/iso2code/gb").
		then()
			.statusCode(200)
			.log().all();
	}
	
	/*
	 * Verify multiple content using org.harmcrest.Matchers library
	 * */
	@Test
	public void testHasItems()
	{
		given()
			.get("http://services.groupkt.com/country/get/all").
		then()
			.body("RestResponse.result.name", hasItems("Australia", "Argentina", "Afghanistan"));
	}
	
	/*
	 * 
	 * */
	@Test
	public void testEqualToFunction()
	{
		given()
			.get("http://services.groupkt.com/country/iso2code/us").
		then().
			body("RestResponse.result.name", equalTo("United States of America"));
	}
	
	/*
	 * Using 'and' to improve readability
	 * generally used when writing in one line xPath style
	 * */
	@Test
	public void testAndFeatureForReadability()
	{
		given().param("key1", "value1").header("head1", "value1").when().get("http://services.groupkt.com/country/get/iso2code/cn").then().statusCode(200).and().body("RestResponse.result.alpha3_code", equalTo("cn"));
	}
}
