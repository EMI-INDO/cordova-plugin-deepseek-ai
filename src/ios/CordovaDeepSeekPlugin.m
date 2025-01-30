/********* CordovaDeepSeekPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "CordovaDeepSeekPlugin.h"
#import <Foundation/Foundation.h>

/**
 * Created by EMI INDO So on 30/01/2025
 */

@implementation CordovaDeepSeekPlugin

- (void)sendRequest:(CDVInvokedUrlCommand*)command {
    NSLog(@"[CordovaDeepSeekPlugin] sendRequest called");

    [self.commandDelegate runInBackground:^{
        NSDictionary *options = [command.arguments objectAtIndex:0];

        NSString *apiUrl = [options valueForKey:@"apiUrl"];
        NSString *apiKey = [options valueForKey:@"apiKey"];
        NSString *prompt = [options valueForKey:@"prompt"];
        NSNumber *maxTokens = [options valueForKey:@"maxTokens"];
        NSNumber *temperature = [options valueForKey:@"temperature"];

        NSURL *url = [NSURL URLWithString:apiUrl];
        if (!url) {
            [self sendErrorResult:command message:@"Invalid API URL"];
            return;
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", apiKey] forHTTPHeaderField:@"Authorization"];

        NSDictionary *jsonBody = @{
            @"prompt": prompt,
            @"max_tokens": maxTokens,
            @"temperature": temperature
        };

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];

        if (error) {
            [self sendErrorResult:command message:@"JSON Error"];
            return;
        }

        [request setHTTPBody:jsonData];

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                [self sendErrorResult:command message:error.localizedDescription];
                return;
            }

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            if (httpResponse.statusCode != 200) {
                NSString *errorMessage = [NSString stringWithFormat:@"HTTP Error: %ld", (long)httpResponse.statusCode];
                [self sendErrorResult:command message:errorMessage];
                return;
            }

            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            if (jsonError) {
                [self sendErrorResult:command message:@"Invalid JSON Response"];
                return;
            }


            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonResponse];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];

        [task resume];
    }];
}

- (void)sendRequestAdvanced:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSDictionary *options = [command.arguments objectAtIndex:0];
            NSString *apiUrl = options[@"apiUrl"];
            NSString *apiKey = options[@"apiKey"];
            NSString *model = options[@"model"];
            NSArray *messages = options[@"messages"];
            NSNumber *temperature = options[@"temperature"] ?: @0.7;

            if (!apiUrl.length || !apiKey.length || !model.length || messages.count == 0) {
                [self sendPluginError:@"Missing required parameters" command:command];
                return;
            }

            NSError *error;
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiUrl]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", apiKey] forHTTPHeaderField:@"Authorization"];

            NSMutableDictionary *requestBody = [@{
                @"model": model,
                @"messages": messages,
                @"temperature": temperature
            } mutableCopy];

            if (options[@"max_tokens"]) {
                requestBody[@"max_tokens"] = options[@"max_tokens"];
            }
            if (options[@"top_p"]) {
                requestBody[@"top_p"] = options[@"top_p"];
            }

            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&error];
            if (error) {
                [self sendPluginError:@"JSON serialization error" command:command];
                return;
            }

            [request setHTTPBody:jsonData];

            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self sendPluginError:[NSString stringWithFormat:@"Network Error: %@", error.localizedDescription] command:command];
                    return;
                }

                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode != 200) {
                    [self sendPluginError:[NSString stringWithFormat:@"API Error: %ld", (long)httpResponse.statusCode] command:command];
                    return;
                }

                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (!jsonResponse) {
                    [self sendPluginError:@"Invalid API response" command:command];
                    return;
                }

                NSString *result = jsonResponse[@"choices"][0][@"message"][@"content"];
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];

            [task resume];

        } @catch (NSException *exception) {
            [self sendPluginError:[NSString stringWithFormat:@"Exception: %@", exception.reason] command:command];
        }
    }];
}

- (void)sendPluginError:(NSString *)errorMessage command:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendErrorResult:(CDVInvokedUrlCommand*)command message:(NSString*)message {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
