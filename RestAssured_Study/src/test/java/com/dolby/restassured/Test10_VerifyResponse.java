package com.dolby.restassured;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

import org.hamcrest.Matcher;
import org.testng.annotations.Test;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.matcher.ResponseAwareMatcher;

public class Test10_VerifyResponse 
{
	String testUrl = "http://jsonplaceholder.typicode.com/photos";
	
	/**
	 * Status code verification
	 * */
	@Test
	public void testStatusInResponse() {
		
		given().get(testUrl).then().assertThat().statusCode(200).log().all();
		given().get(testUrl).then().assertThat().statusLine("HTTP/1.1 200 OK");
		given().get(testUrl).then().statusLine(containsString("OK"));
	}
	
	/**
	 * headers verification
	 * */
	@Test
	public void testHeadersInResponse()
	{
		given().get(testUrl).then().assertThat().header("X-Powered-By", "Express");
		given().get(testUrl).then().assertThat().headers("Vary", "Accept-Encoding", "Content-Type", containsString("json"));
	}
	
	/**
	 * content type verification
	 * */
	@Test
	public void testContentTypeInResponse() {
		given().get(testUrl).then().assertThat().contentType(ContentType.JSON);
	}
	
	/**
	 * body text verification
	 * */
	@Test
	public void testBodyInResponse() {
		String responseString = get(testUrl).asString();
		given().get(testUrl).then().assertThat().body(equalTo(responseString));
	}
	
	/**
	 * body attribute verification using java 8 lambda expression
	 * */
	@Test
	public void testBodyParametersInResponse()
	{
		//Java 7
		given().
			get("http://jsonplaceholder.typicode.com/photos/1").
		then().
			body("thumbnailUrl", new ResponseAwareMatcher<Response>() {
				public Matcher<?> matcher(Response response) {
					return equalTo("http://placehold.it/150/92c952");
				}
			});
		
		//With Java 8 lambda expression
		given().get("http://jsonplaceholder.typicode.com/photos/1").then().body("thumbnailUrl", response->equalTo("http://placehold.it/150/92c952"));
		
		given().get("http://jsonplaceholder.typicode.com/photos/1").then().body("thumbnailUrl", endsWith("92c952"));
	}
	
	/**
	 * todo: cookie value changing on every hit
	 * */
	@Test
	public void testCookieInResponse()
	{
		given().get("http://jsonplaceholder.typicode.com/comments").then().log().all().assertThat().cookie("__cfduid", "daf9a2bb4f7a5eb20aec6583aa55d8b811507699249");
	}
}
