import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;

import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.Before;
import org.junit.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class GetToken {

    @Before
    public void setUp() {
        RestAssured.baseURI = "https://api.realworld.io";
        RestAssured.basePath = "/api";
        RestAssured.filters(new ResponseLoggingFilter(), new RequestLoggingFilter());
        RestAssured.requestSpecification = new RequestSpecBuilder()
                .setContentType(ContentType.JSON)
                .build();
    }


    public static Response GetToken() {
        String Body = "{\"user\":{\"email\":\"testCS@gmail.com\",\"password\":\"123456789\"}}";
        Response response = given()
                .body(Body)
                .when()
                .post("/users/login")
                .then()
                .statusCode(200)
                .extract().response();
        return response;
    }

    @Test
    public void getArticles() {
        String token = GetToken().path("user.token");
        Response response = given()
                .auth()
                .oauth2(token)
                .when()
                .get("/articles?limit=10&offset=0")
                .then()
                .statusCode(200)
                .extract().response();


        int statusCode = response.getStatusCode();

        assertThat(statusCode, equalTo(200));

    }
}



