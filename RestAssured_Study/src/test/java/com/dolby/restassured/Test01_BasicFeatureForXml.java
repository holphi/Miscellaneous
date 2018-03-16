package com.dolby.restassured;

import org.testng.annotations.Test;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class Test01_BasicFeatureForXml {
	
	/*
	 * To test xml response for single body content
	 * */
	@Test
	public void testSingleContent()
	{
		given()
			.get("http://www.thomas-bayer.com/sqlrest/CUSTOMER/10").
		then()
			.statusCode(200)
			.body("CUSTOMER.ID", equalTo("10"))
			.log().all();
	}
	
	/*
	 * To test xml response for multiple body content
	 * */
	@Test
	public void testMultipleContent()
	{
		given()
			.get("http://www.thomas-bayer.com/sqlrest/CUSTOMER/10").
		then()
			.body("CUSTOMER.ID", equalTo("10"))
			.body("CUSTOMER.FIRSTNAME", equalTo("Sue"))
			.body("CUSTOMER.LASTNAME", equalTo("Fuller"))
			.body("CUSTOMER.CITY", equalTo("Dallas"));
	}
	
	/*
	 * Compare complete text in one go
	 * */
	@Test
	public void testCompleteTextInOneGo()
	{
		given()
			.get("http://www.thomas-bayer.com/sqlrest/CUSTOMER/10").
		then()
			.body("CUSTOMER.text()", equalTo("10SueFuller135 Upland Pl.Dallas"));
	}
	
	/*
	 * XPath can also be used to find values
	 * */
	@Test
	public void testUsingXPath1()
	{
		given()
			.get("http://www.thomas-bayer.com/sqlrest/CUSTOMER/10").
		then()
			.body(hasXPath("/CUSTOMER/FIRSTNAME"), containsString("Sue"));
	}
	
	/*
	 * xPath types
	 * */
	@Test
	public void testUsingXPath2()
	{
		when()
			.get("http://www.thomas-bayer.com/sqlrest/INVOICE/").
		then()
			.body(hasXPath("/INVOICEList/INVOICE[text()='40']"))
			.log().everything();
	}
}
