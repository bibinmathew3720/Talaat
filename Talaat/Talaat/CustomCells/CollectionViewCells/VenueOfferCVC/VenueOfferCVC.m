//
//  VenueOfferCVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//
#import "OfferCell.h"
#import "VenueOfferCVC.h"
@interface VenueOfferCVC()<UITableViewDataSource>
@property (nonatomic, strong) NSArray *currentOffersArray;
@end
@implementation VenueOfferCVC

-(void)awakeFromNib{
    [super awakeFromNib];
    self.offerTableView.estimatedRowHeight = 60;
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)setOffersArray:(NSArray *)offersArray{
    self.currentOffersArray = offersArray;
    
    NSUInteger offerCount = offersArray.count;
    if(offerCount == 0){
        self.offerTableView.hidden = YES;
        self.noOfferAvailableLabel.hidden = NO;
    }
    else{
        self.offerTableView.hidden = NO;
        self.noOfferAvailableLabel.hidden = YES;
        [self.offerTableView reloadData];
    }
}

#pragma mark - UITableView Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentOffersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferCell *offCell= (OfferCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    offCell.offerDetail = [self.currentOffersArray objectAtIndex:indexPath.row];
    return offCell;
}

#pragma mark - UITableView Dalegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end
