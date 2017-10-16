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
    NSString *validityString = @"";
    if([offerDetail valueForKey:@"validity"])
        validityString = [self getValidity:[offerDetail valueForKey:@"validity"]];
    if(validityString.length>0)
        validityString = [NSString stringWithFormat:@"*Offer valid till %@th",validityString];
    self.offerDetailLabel.text = [NSString stringWithFormat:@"%@\n%@",[offerDetail valueForKey:@"description"],validityString];
    [self.offerImageView sd_setImageWithURL:[NSURL URLWithString:[offerDetail valueForKey:@"image_path"]] placeholderImage:[UIImage imageNamed:PlaceholderImageName]];
}

-(NSString *)getValidity:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MMM dd"];
    return [dateFormatter stringFromDate:date];
}

@end
