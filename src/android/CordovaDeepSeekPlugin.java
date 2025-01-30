package emi.indo.cordova.plugin.deepseek.ai;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
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
            String apiUrl = options.getString("apiUrl"); // DeepSeek or OpenAi API request url endpoint
            String apiKey = options.getString("apiKey");
            String prompt = options.getString("prompt");
            int maxTokens = options.getInt("maxTokens"); 
            double temperature = options.getDouble("temperature");
            try {
                this.sendRequest(apiUrl, apiKey, prompt, maxTokens, temperature, callbackContext);
            } catch (Exception e) {
                callbackContext.error("Exception: " + e.getMessage());
            }
            return true;
        } else if (action.equals("sendRequestAdvanced")) {
            JSONObject options = args.getJSONObject(0);
            this.sendRequestAdvanced(options, callbackContext);
            return true;
        }
        return false;
    }


    private void sendRequestAdvanced(JSONObject options, CallbackContext callbackContext) {
        cordova.getThreadPool().execute(() -> {
            try {
                String apiUrl = options.getString("apiUrl"); // DeepSeek or OpenAi API request url endpoint
                String apiKey = options.getString("apiKey");
                String model = options.getString("model");
                JSONArray messages = options.getJSONArray("messages");
                double temperature = options.optDouble("temperature", 0.7);

                if (apiKey.isEmpty() || model.isEmpty() || messages.length() == 0) {
                    callbackContext.error("Missing required parameters");
                    return;
                }

                URL url = new URL(apiUrl);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();

                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json");
                connection.setRequestProperty("Authorization", "Bearer " + apiKey);

                JSONObject requestBody = new JSONObject();
                requestBody.put("model", model);
                requestBody.put("messages", messages);
                requestBody.put("temperature", temperature);

                if (options.has("max_tokens")) {
                    requestBody.put("max_tokens", options.getInt("max_tokens"));
                }
                if (options.has("top_p")) {
                    requestBody.put("top_p", options.getDouble("top_p"));
                }

                connection.setDoOutput(true);
                OutputStream os = connection.getOutputStream();
                os.write(requestBody.toString().getBytes());
                os.flush();
                os.close();

                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    StringBuilder response = new StringBuilder();
                    String inputLine;

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    JSONObject jsonResponse = new JSONObject(response.toString());
                    String result = jsonResponse.getJSONArray("choices")
                            .getJSONObject(0)
                            .getJSONObject("message")
                            .getString("content");
                    callbackContext.success(result);
                } else {
                    callbackContext.error("API Error: " + responseCode);
                }
            } catch (JSONException e) {
                callbackContext.error("JSON Error: " + e.getMessage());
            } catch (Exception e) {
                callbackContext.error("Network Error: " + e.getMessage());
            }
        });
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
