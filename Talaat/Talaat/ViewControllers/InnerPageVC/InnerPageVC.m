//
//  InnerPageVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/4/17.
//  Copyright © 2017 Talaat. All rights reserved.
//
#define CollectionCellReuseIdentifier @"innerCell"

#import "OfferCell.h"
#import "VenueCell.h"
#import "InnerPageVC.h"
#import "VenueDetailVC.h"
#import "InnerCVC.h"
typedef enum{
    PageVenues,
    PageOffers
} PageType;
@interface InnerPageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,InnerCVCDelegate>
@property (nonatomic, assign) PageType pageType;
@property (weak, nonatomic) IBOutlet UIView *venueUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *offerUnderLineView;
@property (weak, nonatomic) IBOutlet UICollectionView *innerCollectionView;

@property (nonatomic, strong) NSArray *venuesArray;
@property (nonatomic, strong) NSArray *offersArray;
@property (nonatomic,assign)int previousPage;
@end

@implementation InnerPageVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self callingGetAllVenuesApi];
}

-(void)initialisation{
    self.pageType = PageVenues;
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
    self.innerCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    [self settingVenuUnderLineView];
    self.pageType = PageVenues;
    [self.innerCollectionView reloadData];
    if(self.venuesArray.count == 0)
        [self callingGetAllVenuesApi];
    [self moveToVenues];
}

- (IBAction)offerButtonAction:(UIButton *)sender {
    [self settingOfferUnderLineView];
    self.pageType = PageOffers;
    [self.innerCollectionView reloadData];
    if(self.offersArray.count == 0)
        [self callingGetAllOffersApi];
    [self moveToOffers];
}

-(void)settingOfferUnderLineView{
    self.venueUnderlineView.hidden = YES;
    self.offerUnderLineView.hidden = NO;
}

-(void)settingVenuUnderLineView{
    self.venueUnderlineView.hidden = NO;
    self.offerUnderLineView.hidden = YES;
}

- (IBAction)phoneButtonAction:(UIButton *)sender {
    id venueDetails  = [self.venuesArray objectAtIndex:sender.tag];
    NSString *phoneNumberString = [NSString stringWithFormat:@"%@",[venueDetails valueForKey:@"phone"]];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:phoneNumberString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark - CollectionView Datasources

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InnerCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.listType = ListVenues;
        cell.dataArray = self.venuesArray;
    }
    else if(indexPath.row == 1){
        cell.listType = ListOffers;
        cell.dataArray = self.offersArray;
    }
    cell.innerCVCDelegate = self;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.view.frame.size.width;
    int fractionalPage = self.innerCollectionView.contentOffset.x / pageWidth;
    if(self.previousPage != fractionalPage) {
        self.previousPage= fractionalPage;
        if(fractionalPage == 0){
            self.pageType = PageVenues;
            if(self.venuesArray.count == 0)
                [self callingGetAllVenuesApi];
        }
        else if (fractionalPage == 1){
            self.pageType = PageOffers;
            if(self.offersArray.count == 0)
                [self callingGetAllOffersApi];
            [self settingOfferUnderLineView];
        }
       [self.innerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:fractionalPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(self.pageType == PageOffers){
       
    }
    else if (self.pageType == PageVenues){
         [self settingVenuUnderLineView];
    }
}
#pragma mark - Get All Venues Api

-(void)callingGetAllVenuesApi{
    NSString *categoryString = @"";
    if(self.type == EventTypeDine)
        categoryString = @"category=dine";
    else if (self.type == EventTypeNightLife)
        categoryString = @"category=night";
    if(self.venuesArray.count == 0)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:TALAATURLTYPEGETALLVENUES withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:url withBody:categoryString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[[responseObject valueForKey:@"result"] valueForKey:@"response"] isEqualToString:@"success"]){
            self.venuesArray = [responseObject valueForKey:@"data"];
            if(self.pageType == PageVenues){
                [self.innerCollectionView reloadData];
            }
        }
        
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [[Utilities sharedHandler]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

-(void)callingGetAllOffersApi{
    if(self.offersArray.count == 0)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *categoryString = @"";
    if(self.type == EventTypeDine)
        categoryString = @"category=dine";
    else if (self.type == EventTypeNightLife)
        categoryString = @"category=night";
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:TALAATURLTYPEGETALLOFFERS withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:url withBody:categoryString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[[responseObject valueForKey:@"result"] valueForKey:@"response"] isEqualToString:@"success"]){
            self.offersArray = [responseObject valueForKey:@"data"];
            if(self.pageType == PageOffers){
                [self.innerCollectionView reloadData];
            }
        }
        
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        [[Utilities sharedHandler]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)venueDetail{
    VenueDetailVC *venueDetailPage = (VenueDetailVC *)segue.destinationViewController;
    venueDetailPage.venueId = [venueDetail valueForKey:@"id"];
    venueDetailPage.headingString = [[venueDetail valueForKey:@"name"] uppercaseString];
    venueDetailPage.image = self.topImageView.image;
}

-(void)moveToOffers{
    [self.innerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)moveToVenues{
    [self.innerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - Inner Collection View Cell Delegate

-(void)selectedVenue:(id)venueDetail{
    [self performSegueWithIdentifier:@"toVenuDetailPage" sender:venueDetail];
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
