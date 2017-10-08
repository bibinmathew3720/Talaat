//
//  ResponseHandler.h
//  TWExperience
//
//  Created by Jay Krish on 29/12/15.
//  Copyright © 2015 AutoLink. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TWERESPONSETYPE ){
    TWERESPONSETYPELogin = 1,
    TWERESPONSETYPEREGISTER = 2,
    TWERESPONSETYPEFORGOTpassword = 3,
    TWERESPONSETYPEDELETEPRODUCT = 4,
    TWERESPONSETYPEGETALLUSER = 5
    
};

@interface ResponseHandler : NSObject

+(ResponseHandler *) sharedHandler;
- (BOOL)processResponse:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode;
- (NSString *)processError:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode withError:(NSError *)error;

@end
