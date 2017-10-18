//
//  VenueOfferCVC.h
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueOfferCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *noOfferAvailableLabel;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (nonatomic, strong) NSArray *offersArray;
@end
