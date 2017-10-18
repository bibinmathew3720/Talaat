//
//  VenueDataCVC.h
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueDataCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venuDescriptionLabel;

@property (nonatomic, strong) id venueData;

@end
