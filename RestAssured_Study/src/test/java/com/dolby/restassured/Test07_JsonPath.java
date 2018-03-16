package com.dolby.restassured;

import static org.hamcrest.Matchers.*;

import java.util.List;

import static io.restassured.RestAssured.*;
import static io.restassured.path.json.JsonPath.*;

import org.testng.annotations.Test;
import io.restassured.path.json.JsonPath;

public class Test07_JsonPath 
{
	/*
	 * Extract details as String and further details w/o using json path 
	 * */
	@Test
	public void testJsonPath1() {
		
		String responseAsString = 
				when().
					get("http://jsonplaceholder.typicode.com/photos").
				then().
					extract().asString();
		
		List<Integer> albumIDs = from(responseAsString).get("id");
		System.out.println(albumIDs.size());
	}
	
	
	/*
	 * Extract details as String and further details using json path 
	 * */
	@Test
	public void testJsonPath2() {
		
		String json = 
				when().
					get("http://services.groupkt.com/country/get/all").
				then().
					extract().asString();
		
		JsonPath jsonPath = new JsonPath(json).setRoot("RestResponse.result");
		
		List<String> list = jsonPath.get("name");
		System.out.println(list.size());
	}
}
