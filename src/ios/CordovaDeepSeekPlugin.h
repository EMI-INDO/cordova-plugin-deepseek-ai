/********* CordovaDeepSeekPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

/**
 * Created by EMI INDO So on 30/01/2025
 */

@interface CordovaDeepSeekPlugin : CDVPlugin

- (void)sendRequest:(CDVInvokedUrlCommand*)command;
- (void)sendRequestAdvanced:(CDVInvokedUrlCommand*)command;

@end