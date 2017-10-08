//
//  OfferCell.m
//  Talaat
//
//  Created by Bibin Mathew on 10/8/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "OfferCell.h"

@implementation OfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOfferDetail:(id)offerDetail{
    self.offerHeadingLabel.text = [NSString stringWithFormat:@"%@",[offerDetail valueForKey:@"title"]];
    self.offerDetailLabel.text = [NSString stringWithFormat:@"%@",[offerDetail valueForKey:@"description"]];
}

@end
