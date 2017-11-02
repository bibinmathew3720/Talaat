//
//  InnerCVC.h
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ListVenues,
    ListOffers
} ListType;

@protocol InnerCVCDelegate;
@interface InnerCVC : UICollectionViewCell
@property (nonatomic, assign) ListType listType;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (weak, nonatomic) IBOutlet UITableView *innerTableView;
@property (nonatomic, assign) id <InnerCVCDelegate>innerCVCDelegate;
@end
@protocol InnerCVCDelegate<NSObject>
-(void)selectedVenue:(id)venueDetail;
@end
