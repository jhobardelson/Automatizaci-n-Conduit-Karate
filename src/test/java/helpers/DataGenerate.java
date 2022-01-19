package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerate {

    public static JSONObject getRandomComment() {
        Faker faker = new Faker();
        String body = faker.gameOfThrones().quote();
        JSONObject json = new JSONObject();
        json.put("body", body);
        return json;
    }
    
}
