package com.dolby.restassured;

import org.testng.annotations.Test;

import io.restassured.http.Cookie;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.response.Response;

import static org.hamcrest.Matchers.*;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.*;
import static io.restassured.path.json.JsonPath.*;

public class Test08_GetHeadersAndCookies 
{
	
	/*
	 * To get response headers
	 * */
	@Test
	public void testResponseHeaders() 
	{
		Response response = get("http://jsonplaceholder.typicode.com/photos");
		
		//to get single header
		String headerCFRAY = response.getHeader("CF-RAY");
		System.out.println(">>>>>> Header: " + headerCFRAY);
		
		System.out.println("");
		
		//to get all headers
		Headers headers = response.getHeaders();
		for(Header h: headers){
			System.out.println(h.getName()+":"+h.getValue());
		}
	}
	
	/*
	 * To get cookies
	 * */
	@Test
	public void testCookies() 
	{	
		Response response = get("http://jsonplaceholder.typicode.com/photos");
		Map<String, String> cookies = response.getCookies();
		
		for(Map.Entry<String, String> entry : cookies.entrySet())
		{
			System.out.println(entry.getKey() + ":" + entry.getValue());
		}	
	}
	
	/**
	 * To get detailed cookies
	 * */
	@Test
	public void testDetailedCookies()
	{
		Response response = get("http://jsonplaceholder.typicode.com/photos");
		
		Cookie a = response.getDetailedCookie("__cfduid");
		System.out.println("Detailed: " + a.hasExpiryDate());
		System.out.println("Detailed: " + a.getExpiryDate());
		System.out.println("Detailed: " + a.hasValue());
	}
	
	
}
