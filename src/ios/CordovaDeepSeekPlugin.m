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

- (void)sendErrorResult:(CDVInvokedUrlCommand*)command message:(NSString*)message {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
