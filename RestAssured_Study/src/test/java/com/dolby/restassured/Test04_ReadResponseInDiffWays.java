package com.dolby.restassured;

import static org.hamcrest.Matchers.*;
import static io.restassured.RestAssured.*;

import org.testng.annotations.Test;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

import java.io.IOException;
import java.io.InputStream;

public class Test04_ReadResponseInDiffWays 
{
	/*
	 * To get all response as string
	 * */
	@Test
	public void testGetResponseAsString() {
		String responseAsString = get("http://services.groupkt.com/country/search?text=lands").asString();
		System.out.println("My Response:" + "\n\n\n" + responseAsString);
	}
	
	/*
	 * To get all response as input stream
	 * */
	@Test
	public void testGetResponseAsInputStream() throws IOException{
		InputStream stream = get("http://services.groupkt.com/country/get/iso2code/IN").asInputStream();
		System.out.println("The length of input stream:" + stream.toString().length());
		stream.close();
	}
	
	/*
	 * To get all response as byte array
	 * */
	@Test
	public void testGetResponseAsByteArray(){
		byte[] byteArray = get("http://services.groupkt.com/country/get/iso2code/IN").asByteArray();
		System.out.println("The lenght of byte array:" + byteArray.length);
	}
	
	/*
	 * Extract details using path
	 * */
	@Test
	public void testExtractDetailsUsingPath()
	{
		String url = 
		when()
			.get("http://jsonplaceholder.typicode.com/photos/1").
		then()
			.statusCode(200)
			.contentType(ContentType.JSON)
			.body("albumId", equalTo(1)).
		extract()
			.path("url");
		
		System.out.println(url);
		
		when().get(url).then().statusCode(200);
	}
	
	/*
	 * Extract details using path in one line
	 * */
	@Test
	public void testExtractPathInOneLine()
	{
		String requestUrl = "http://jsonplaceholder.typicode.com/photos/1";

		//type 1:
		String href1 = get(requestUrl).path("thumbnailUrl");
		System.out.println("Fetched URL 1:" + href1);
		when().get(href1).then().statusCode(200);
		
		//type 2:
		String href2 = get(requestUrl).andReturn().jsonPath().getString("thumbnailUrl");
		System.out.println("Fetched URL 2:" + href2);
		when().get(href2).then().statusCode(200);
	}
	
	/*
	 * Extract details as Response for further use
	 * */
	@Test
	public void testExtractDetailsUsingResponse()
	{
		Response response = 
		when().
			get("http://jsonplaceholder.typicode.com/photos/1").
		then().
		extract().
			response();
		
		System.out.println("Content Type: " + response.contentType());
		System.out.println("Href:" + response.path("url"));
		System.out.println("Status code: " + response.statusCode());
	}
}
