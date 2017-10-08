//
//  ResponseHandler.m
//  TWExperience
//
//  Created by Jay Krish on 29/12/15.
//  Copyright © 2015 AutoLink. All rights reserved.
//

#import "ResponseHandler.h"



@implementation ResponseHandler

+(ResponseHandler *) sharedHandler {
    static ResponseHandler *handler;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

#pragma mark - Process Response

- (BOOL)processResponse:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode {
    BOOL isSuccess = false;
    switch (statusCode) {
        case 200:
            isSuccess = true;
            break;
            
        default:
            break;
    }
    return isSuccess;
}

#pragma mark - Process error

- (NSString *)processError:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode withError:(NSError *)error {
    NSString * errorMessage = @"";
#ifndef DEBUG
    errorMessage = error.localizedDescription;
#else
    switch (statusCode) {
        case 1024:
            errorMessage = @"No Internet Connection.Please check your connection settings and try again!";

            break;
        case 500:
            errorMessage = @"Internal server error, please try after sometime.";
            break;
        case 404:
            
            break;
        case 401:
            errorMessage = @"Authorization has been denied for this request. Please Login and try again.";
                       break;
        default:
             errorMessage = @"Unable to connect to the server, please try after sometime.";
            break;
    }
#endif
    return errorMessage;
}

@end
