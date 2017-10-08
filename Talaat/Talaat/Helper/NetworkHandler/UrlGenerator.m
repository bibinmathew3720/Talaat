//
//  UrlGenerator.m
//  TWExperience
//
//  Created by Jay Krish on 29/12/15.
//  Copyright © 2015 AutoLink. All rights reserved.
//

#import "UrlGenerator.h"

@implementation UrlGenerator

+(UrlGenerator *) sharedHandler {
    static UrlGenerator *handler;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (NSURL *)urlForRequestType:(TALAATURLTYPE) type withURLParameter:(NSString *)urlParameter {
    NSString *appendingUrl;
    switch (type) {
        case TALAATURLTYPEGETALLVENUES: {
            appendingUrl = getAllVenueString;
        }
            break;
        case TALAATURLTYPEGETALLOFFERS: {
            appendingUrl = getAllOffersString;
        }
            break;
        case TALAATURLTYPEFETCHVENUEDETAILS: {
            appendingUrl = [getVenueDetailsString stringByAppendingString:urlParameter];;
        }
            break;
        default:
            break;
    }
    if([appendingUrl rangeOfString:@"%"].location != NSNotFound) {
        return  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,appendingUrl]];
    }
    NSString *finalUrlString = [NSString stringWithFormat:@"%@%@",BaseUrl,appendingUrl];
    NSString *escapedUrlString = [finalUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return [NSURL URLWithString:escapedUrlString];
}

@end
