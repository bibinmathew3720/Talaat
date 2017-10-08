//
//  VenueCell.h
//  Talaat
//
//  Created by Bibin Mathew on 10/8/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueHeadingLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (nonatomic, strong) id venueDetail;
@end
