//
//  InnerPageVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/4/17.
//  Copyright © 2017 Talaat. All rights reserved.
//
#import "OfferCell.h"
#import "VenueCell.h"
#import "InnerPageVC.h"
typedef enum{
    PageVenues,
    PageOffers
} PageType;
@interface InnerPageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *innerTableView;
@property (nonatomic, assign) PageType pageType;
@property (weak, nonatomic) IBOutlet UIView *venueUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *offerUnderLineView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation InnerPageVC

-(void)initView{
    [super initView];
    [self initialisation];
}

-(void)initialisation{
    self.pageType = PageVenues;
    self.innerTableView.estimatedRowHeight = 60;
    self.innerTableView.rowHeight = UITableViewAutomaticDimension;
    if(self.type == EventTypeNightLife){
        self.titleLabel.text = @"NIGHTLIFE";
        self.topImageView.image = [UIImage imageNamed:@"nightLifeTopImage"];
    }
    else if(self.type == EventTypeDine){
        self.titleLabel.text = @"DINE";
        self.topImageView.image = [UIImage imageNamed:@"dineTopImage"];
    }
    else if (self.type == EventTypeNightLifeAndDine){
        self.titleLabel.text = @"NIGHTLIFE & DINE";
        self.topImageView.image = [UIImage imageNamed:@"nightLifeAnddDineImage"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)venueButtonAction:(UIButton *)sender {
    self.venueUnderlineView.hidden = NO;
    self.offerUnderLineView.hidden = YES;
    self.pageType = PageVenues;
    [self.innerTableView reloadData];
}

- (IBAction)offerButtonAction:(UIButton *)sender {
    self.venueUnderlineView.hidden = YES;
    self.offerUnderLineView.hidden = NO;
    self.pageType = PageOffers;
    [self.innerTableView reloadData];
}

- (IBAction)phoneButtonAction:(UIButton *)sender {
}

#pragma mark - UITableView Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(self.pageType == PageOffers){
        OfferCell *offCell= (OfferCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
        cell= offCell;
    }
    else{
         VenueCell *venueCell= (VenueCell *)[tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
         venueCell.phoneButton.tag = indexPath.row;
         cell= venueCell;
    }
    return cell;
}

#pragma mark - UITableView Dalegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
