//
//  VenueDataCVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "VenueDataCVC.h"

@implementation VenueDataCVC

-(void)setVenueData:(id)venueData{
    if(venueData!=nil){
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",[venueData valueForKey:@"phone"]];
    NSString *description = [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@",[venueData valueForKey:@"description"],[venueData valueForKey:@"address"],[venueData valueForKey:@"email"]];
    self.venuDescriptionLabel.text = description;
    NSString *startTimeString = [self getTimeInAmPmFormat:[venueData valueForKey:@"working_hours_start"]];
    NSString *endTimeString = [self getTimeInAmPmFormat:[venueData valueForKey:@"working_hours_end"]];
    self.timeLabel.text = [NSString stringWithFormat:@"OPEN: %@ - %@",startTimeString, endTimeString];
    
    }
}

#pragma mark - Get Time In 24 Hours

-(NSString *)getTimeInAmPmFormat:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dateFormatter dateFromString:timeString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return [dateFormatter stringFromDate:time];
}
@end
