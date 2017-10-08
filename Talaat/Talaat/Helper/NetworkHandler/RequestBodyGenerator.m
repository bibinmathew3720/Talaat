//
//  RequestBodyGenerator.m
//  NetworkHandler
//
//  Created by Jay Krish on 3/9/15.
//  Copyright (c) 2015 Pumex. All rights reserved.
//

#import "RequestBodyGenerator.h"


@implementation RequestBodyGenerator

+(RequestBodyGenerator *) sharedBodyGenerator{
    static RequestBodyGenerator *sharedBodyGenerator;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        sharedBodyGenerator = [[self alloc] init];
    });
    return sharedBodyGenerator;
}

#pragma mark - Request body Generator

- (NSData *)requestBodyGeneratorWith:(id)contentDictionary {
    NSString * string = nil;
    if ([NSJSONSerialization isValidJSONObject:contentDictionary]) {
        string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contentDictionary
                                                                                options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",string);
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


@end

@implementation HeaderBodyGenerator


+(HeaderBodyGenerator *) sharedHeaderGenerator {
    static HeaderBodyGenerator *sharedBodyGenerator;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        sharedBodyGenerator = [[self alloc] init];
    });
    return sharedBodyGenerator;
}

- (NSMutableDictionary *)urlEncodedHeaderBody {
    NSMutableDictionary * headerDictionary = [[NSMutableDictionary alloc]init];
    //[headerDictionary setValue:@"Accept" forKey:@"application/json"];
    [headerDictionary setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    return headerDictionary;
}

- (NSMutableDictionary *)headerBody {
//    User *user = [User getUser];
    NSMutableDictionary * headerDictionary =   [[NSMutableDictionary alloc] init];
   // [headerDictionary setObject:[NSString stringWithFormat:@"Bearer %@",user.authToken] forKey:@"Authorization"];
    return headerDictionary;
//    NSMutableDictionary * headerDictionary = [[NSMutableDictionary alloc]init];
//    [headerDictionary setValue:@"application/json" forKey:@"Accept"];
//    [headerDictionary setValue:@"application/json" forKey:@"Content-Type"];
//    return headerDictionary;
}

@end
