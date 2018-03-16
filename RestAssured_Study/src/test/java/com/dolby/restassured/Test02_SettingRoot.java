package com.dolby.restassured;

import org.testng.annotations.Test;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class Test02_SettingRoot 
{

	/*
	 * Basic way to test all parameters
	 * */
	@Test
	public void testWithoutRoot()
	{
		given()
			.get("http://services.groupkt.com/country/get/iso3code/ITA").
		then()
			.body("RestResponse.result.name", is("Italy"))
			.body("RestResponse.result.alpha2_code", is("IT"))
			.body("RestResponse.result.alpha3_code", is("ITA"));
	}
  
	/*
	 * Recommended way to test all parameters using root feature
	 * */
	@Test
	public void testWithRoot()
	{
		given()
			.get("http://services.groupkt.com/country/get/iso3code/ITA").
		then()
			.root("RestResponse.result")
			.body("name", is("Italy"))
			.body("alpha2_code", is("IT"))
			.body("alpha3_code", is("ITA"));
	}
	
	/*
	 * We can detach root path in between
	 * */
	@Test
	public void testDetachRoot()
	{
		given()
			.get("http://services.groupkt.com/country/get/iso3code/ITA").
		then()
			.root("RestResponse.result")
			.body("name", is("Italy"))
			.body("alpha2_code", is("IT"))
			.detachRoot("RestResponse.result")
			.body("RestResponse.result.alpha3_code", is("ITA"));
	}
}
