package com.dolby.restassured;

import org.testng.annotations.Test;
import static io.restassured.RestAssured.*;

public class Test03_PostRequests 
{

	@Test
	public void testPostReq() {
		given()
			.headers("AppKey", "key-value")
			.param("wfsfirst_name", "first")
			.param("wfslast_name", "last")
			.param("wfsemail", "test@test.com").
		when()
			.post("http://api.fonts.com/rest/json/Accounts").
		then()
			.statusCode(503).log().all();
	}
}
