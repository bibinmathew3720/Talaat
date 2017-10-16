//
//  VenueDetailVC.h
//  Talaat
//
//  Created by Bibin Mathew on 10/9/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VenueDetailVC : BaseViewController
@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, strong) NSString *headingString;
@property (nonatomic, strong) UIImage *image;
@end
