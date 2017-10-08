//
//  OfferCell.h
//  Talaat
//
//  Created by Bibin Mathew on 10/8/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailLabel;

@end
