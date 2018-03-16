package com.dolby.restassured;

import static org.hamcrest.Matchers.*;
import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.when;

import org.testng.annotations.Test;

import io.restassured.http.ContentType;

public class Test03_SchemaCheck 
{
	/*
	 * Verify response type
	 * */
	@Test
	public void testContentType() {
		given().
			get("http://services.groupkt.com/country/get/iso3code/ITA").
		then().
			contentType(ContentType.JSON).
			statusCode(200);
	}
}
