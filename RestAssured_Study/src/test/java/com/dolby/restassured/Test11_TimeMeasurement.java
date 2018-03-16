package com.dolby.restassured;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

import java.util.concurrent.TimeUnit;

import org.testng.annotations.Test;

public class Test11_TimeMeasurement 
{
	/**
	 * Response time measurement
	 * 
	 * Please note time include HTTP round trip + rest assured processing time
	 * 
	 * */
	@Test
	public void testResponseTime() {
		long t = given().get("http://jsonplaceholder.typicode.com/photos").time();
		System.out.println("Time(ms): " + t);
	}
	
	@Test
	public void testResponseTimeInUnit(){
		long t = given().get("http://jsonplaceholder.typicode.com/photos/1").timeIn(TimeUnit.MILLISECONDS);
		System.out.println("Time(ms): " + t);
	}
	
	@Test
	public void testResponseTimeAssertion() {
		given().get("http://jsonplaceholder.typicode.com/photos").then().assertThat().time(lessThan(500L));
	}
}
