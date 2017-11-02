//
//  InnerCVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/18/17.
//  Copyright © 2017 Talaat. All rights reserved.
//
#import "OfferCell.h"
#import "VenueCell.h"

#import "InnerCVC.h"
@interface InnerCVC()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) ListType currentListType;
@property (nonatomic, strong) NSArray *currentDataArray;
@end
@implementation InnerCVC
#pragma mark - UITableView Datasources

-(void)awakeFromNib{
    [super awakeFromNib];
    self.innerTableView.estimatedRowHeight = 60;
    self.innerTableView.rowHeight = UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger itemCount = self.currentDataArray.count;
    if(itemCount==0){
         self.noItemsLabel.hidden = NO;
        if(self.currentListType == ListOffers){
            self.noItemsLabel.text = @"No offers available";
        }
        else{
            self.noItemsLabel.text = @"No venues available";
        }
    }
    else{
        self.noItemsLabel.hidden = YES;
    }
        return self.currentDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(self.currentListType == ListOffers){
        OfferCell *offCell= (OfferCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
        offCell.offerDetail = [self.currentDataArray objectAtIndex:indexPath.row];
        cell= offCell;
    }
    else{
        VenueCell *venueCell= (VenueCell *)[tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
        venueCell.phoneButton.tag = indexPath.row;
        venueCell.venueDetail = [self.currentDataArray objectAtIndex:indexPath.row];
        cell= venueCell;
    }
    return cell;
}

#pragma mark - UITable View Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id venueDetail;
    if(self.currentListType == ListVenues){
        venueDetail = [self.currentDataArray objectAtIndex:indexPath.row];
    }
    else{
        venueDetail = [[self.currentDataArray objectAtIndex:indexPath.row] valueForKey:@"venue"];
    }
    if(self.innerCVCDelegate && [self.innerCVCDelegate respondsToSelector:@selector(selectedVenue:)]){
        [self.innerCVCDelegate selectedVenue:venueDetail];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)setListType:(ListType)listType{
    self.currentListType = listType;
}

-(void)setDataArray:(NSArray *)dataArray{
    self.currentDataArray = dataArray;
    [self.innerTableView reloadData];
}
@end
