//
//  UrlGenerator.h
//  TWExperience
//
//  Created by Jay Krish on 29/12/15.
//  Copyright © 2015 AutoLink. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *BaseUrl = @"http://gogotests.com/talaat/api/"; //Test
//static NSString *BaseUrl = @"http://talaatqatar.com/api/"; //Production

static NSString *getAllVenueString =@"fetch_all_venue?";
static NSString *getAllOffersString =@"fetch_all_offers?";
static NSString *getVenueDetailsString =@"fetch_venue_by_id";


typedef NS_ENUM(NSInteger, TALAATURLTYPE ){
    TALAATURLTYPEGETALLVENUES= 1,
    TALAATURLTYPEGETALLOFFERS= 2,
    TALAATURLTYPEFETCHVENUEDETAILS = 3,
   
};


@interface UrlGenerator : NSObject

+(UrlGenerator *) sharedHandler;
- (NSURL *)urlForRequestType:(TALAATURLTYPE) type withURLParameter:(NSString *)urlParameter;

@end
