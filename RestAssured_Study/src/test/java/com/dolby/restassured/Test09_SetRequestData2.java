package com.dolby.restassured;

import org.testng.annotations.Test;

import static io.restassured.RestAssured.*;
import static io.restassured.path.json.JsonPath.*;
import static org.hamcrest.Matchers.*;

import io.restassured.http.ContentType;
import io.restassured.http.Cookie;
import io.restassured.http.Cookie.Builder;
import io.restassured.http.Cookies;

public class Test09_SetRequestData2 
{

	/**
	 * To path parameters type 2
	 * */
	@Test
	public void testSetPathParameters2()
	{
		given().
			pathParam("type", "json").
			pathParam("section","Domains").
		when().
			post("http://api.fonts.com/rest/{type}/{section}").
		then().
			statusCode(400);
	}
	
	/**
	 * Cookies can be set in request parameters
	 * */
	@Test
	public void testSetCookiesInRequest()
	{
		//To set single value
		given().
			cookie("__utmt", "1").
		when().
			get("http://webservicex.com/globalweather.asmx?=GetCitiesByCountry").
		then().
			statusCode(200);
	}
	
	/**
	 * Multiple Cookies can be set in request param
	 * Todo: test example not runnable code
	 * */
	@Test
	public void testSetMultiCookiesInRequest(){
		
		//to set multi value
		given().cookie("key", "val1", "val2"); //this will create two cookies key key=val1;key=val2
		
		//to set detailed cookie
		Cookie cookie = new Cookie.Builder("some_cookie", "some_value").setSecured(true).setComment("some comments").build();
		given().cookie(cookie).when().get("/cookie").then().assertThat().body(equalTo("x"));
		
		//to set multiple detailed cookies
		Cookie someCookie1 = new Cookie.Builder("some_cookie", "some_value").setSecured(true).setComment("some comments").build();
		Cookie someCookie2 = new Cookie.Builder("some_cookie", "some_value").setSecured(true).setComment("some comments").build();
		Cookies cookies = new Cookies(someCookie1, someCookie2);
		given().cookies(cookies).when().get("/cookie").then().assertThat().body(equalTo("x"));
	}
	
	/**
	 * We can pass single header, headers with multiple values and multiple headers
	 * */
	@Test
	public void testSetHeaders() {
		given().
			header("k", "v").
			header("k10", "val1", "val2", "val3").
			headers("k1", "v1", "k2", "v2").
		when().
			get("https://api.fonts.com/rest/json/Accounts/").
		then().
			statusCode(400).
			log().everything();
	}
	
	/**
	 * Content Type can also be set
	 * */
	@Test
	public void testSetContentType() {
		given().
			contentType(ContentType.JSON).
			contentType("application/json").		
		when().
			get("https://api.fonts.com/rest/json/Accounts/").
		then().
			statusCode(400);	
	}
}
