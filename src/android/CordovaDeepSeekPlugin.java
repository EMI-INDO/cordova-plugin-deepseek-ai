package emi.indo.cordova.plugin.deepseek.ai;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

/**
 * Created by EMI INDO So on 30/01/2025
 */
public class CordovaDeepSeekPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("sendRequest")) {
            JSONObject options = args.getJSONObject(0);
            String apiUrl = options.getString("apiUrl"); // DeepSeek API endpoint URL “https://api.deepseek.com/v1/your-endpoint”; // Replace with an appropriate endpoint
            String apiKey = options.getString("apiKey"); // YOUR_API_KEY
            String prompt = options.getString("prompt"); // hai
            int maxTokens = options.getInt("maxTokens"); // 100
            double temperature = options.getDouble("temperature"); // 0.7
            try {
                this.sendRequest(apiUrl, apiKey, prompt, maxTokens, temperature, callbackContext);
            } catch (Exception e) {
                callbackContext.error("Exception: " + e.getMessage());
            }
            return true;
        }
        return false;
    }

    private void sendRequest(String apiUrl, String apiKey, String prompt, int maxTokens, double temperature, CallbackContext callbackContext) {
        cordova.getThreadPool().execute(() -> {
            try {

                String jsonInputString = "{"
                        + "\"prompt\": \"" + prompt + "\","
                        + "\"max_tokens\": " + maxTokens + ","
                        + "\"temperature\": " + temperature
                        + "}";

                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setRequestProperty("Authorization", "Bearer "+apiKey);
                conn.setDoOutput(true);

                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = jsonInputString.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }


                int responseCode = conn.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) { // 200 OK
                    Scanner scanner = new Scanner(conn.getInputStream(), "utf-8");
                    String response = scanner.useDelimiter("\\A").next();
                    scanner.close();
                    callbackContext.success(response);
                } else {
                    Scanner scanner = new Scanner(conn.getErrorStream(), "utf-8");
                    String errorResponse = scanner.useDelimiter("\\A").next();
                    scanner.close();
                    callbackContext.error("Error: " + responseCode + " - " + errorResponse);
                }

                conn.disconnect();
            } catch (Exception e) {
                callbackContext.error("Exception: " + e.getMessage());
            }
        });
    }
}
