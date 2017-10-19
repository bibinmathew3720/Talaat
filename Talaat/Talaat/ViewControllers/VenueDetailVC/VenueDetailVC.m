//
//  VenueDetailVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/9/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#define VenueDataCVCIdentifier @"venueData"
#define VenueOfferCVCIdentifier @"venueOffer"

#define TopViewHeight 220
#import "OfferCell.h"
#import "VenueDataCVC.h"
#import "VenueOfferCVC.h"

#import <MapKit/MapKit.h>

#import "VenueDetailVC.h"
typedef enum{
    PageTypeInfo,
    PageTypeOffers
} PageType;
@interface VenueDetailVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoUnderLineView;
@property (weak, nonatomic) IBOutlet UIView *offerUndeLineView;
@property (weak, nonatomic) IBOutlet UICollectionView *venueCollectionView;

@property (nonatomic, strong) NSArray *offersArray;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (nonatomic, assign) BOOL isApiGetFired;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSString *phoneString;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic,assign)int previousPage;
@property (nonatomic, strong) id venueDetails;
@end

@implementation VenueDetailVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self callingGetVenueDetailsApi];
}

-(void)initialisation{
    self.headingLabel.text = self.headingString;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -80, 0);
    self.venueCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Venue Details Api

-(void)callingGetVenueDetailsApi{
    NSString *venueIdString = [NSString stringWithFormat:@"venue_id=%@",self.venueId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:TALAATURLTYPEFETCHVENUEDETAILS withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:url withBody:venueIdString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Response Object:%@",responseObject);
        if([[[responseObject valueForKey:@"result"] valueForKey:@"response"] isEqualToString:@"success"]){
            self.isApiGetFired = YES;
            self.venueDetails = [responseObject valueForKey:@"data"];
            [self populateInfoViewWithReponse:[responseObject valueForKey:@"data"]];
            [self.venueCollectionView reloadData];
            [self populateOfferListWithOffersArray:[[responseObject valueForKey:@"data"] valueForKey:@"offers"]];
        }
        
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        [[Utilities sharedHandler]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

-(void)populateInfoViewWithReponse:(id)response{
    self.phoneString = [NSString stringWithFormat:@"%@",[response valueForKey:@"phone"]];
    self.imagesArray = [response valueForKey:@"venue_images"];
    self.latitude = [NSString stringWithFormat:@"%@",[response valueForKey:@"latittude"]];
    self.longitude = [NSString stringWithFormat:@"%@",[response valueForKey:@"longitude"]];
    self.address = [NSString stringWithFormat:@"%@",[response valueForKey:@"address"]];
}



-(void)populateOfferListWithOffersArray:(NSArray *)offersArray{
    self.offersArray = offersArray;
    [self.venueCollectionView reloadData];
}

-(void)viewWillLayoutSubviews{
    if(self.isApiGetFired)
        [self settingBackGroundImages];
    self.scrollView.frame = CGRectMake(0, -20, self.view.frame.size.width, TopViewHeight);
    self.scrollView.contentSize = CGSizeMake(self.imagesArray.count*self.view.frame.size.width, TopViewHeight);
}

- (void)settingBackGroundImages{
    self.pageControl.numberOfPages = self.imagesArray.count;
    UIImageView *gradientImageView;
    for (int i = 0; i < self.imagesArray.count; i++)
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        //self.imageView.clipsToBounds = YES;
        gradientImageView = [[UIImageView alloc] init];
        gradientImageView.contentMode = UIViewContentModeScaleToFill;
       // gradientImageView.clipsToBounds = YES;
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width,TopViewHeight);
        frame.origin.x = self.view.frame.size.width*i;
        frame.origin.y = 0.0f;
        self.imageView.frame = frame;
        gradientImageView.frame = CGRectMake(0, 0, self.view.frame.size.width,TopViewHeight);
        [self.imageView sd_setImageWithURL:[[self.imagesArray objectAtIndex:i] valueForKey:@"path"] placeholderImage:[UIImage imageNamed:PlaceholderImageName]];
        gradientImageView.image = [UIImage imageNamed:@"venueTopGradient"];
        [self.scrollView addSubview:self.imageView];
        [self.imageView addSubview:gradientImageView];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Actions

- (IBAction)phoneButtonAction:(UIButton *)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phoneString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)locationButtonAction:(UIButton *)sender {
    [self loadMapWithCoordinates:self.latitude andLongitude:self.longitude];
//    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@",self.latitude,self.longitude];
//    if( ![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]] ){
//
//    }
}

-(void)loadMapWithCoordinates:(NSString *)lat andLongitude:(NSString *)lon{
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    endingItem.name = self.address;
    [endingItem openInMapsWithLaunchOptions:nil];
//    let coordinates = CLLocationCoordinate2DMake(29.2745571, 47.8433472)
//    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//    let mapItem = MKMapItem(placemark: placemark)
//    mapItem.name = self.name
//    mapItem.openInMaps(launchOptions: nil)
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonAction:(UIButton *)sender {
    [self settingInfoUnderLineView];
   [self.venueCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (IBAction)offersButtonAction:(UIButton *)sender {
    [self settingOfferUnderLineView];
    [self.venueCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


#pragma mark - CollectionView Datasources

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(indexPath.row == 0){
        VenueDataCVC *venueDataCell = [collectionView dequeueReusableCellWithReuseIdentifier:VenueDataCVCIdentifier forIndexPath:indexPath];
        venueDataCell.venueData = self.venueDetails;
        cell = venueDataCell;
    }
    else if(indexPath.row == 1){
        VenueOfferCVC *venueOfferCell = [collectionView dequeueReusableCellWithReuseIdentifier:VenueOfferCVCIdentifier forIndexPath:indexPath];
        venueOfferCell.offersArray = self.offersArray;
        cell = venueOfferCell;
    }
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
    if(scrollView == self.scrollView){
        CGFloat pageWidth = self.scrollView.frame.size.width;
        float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        NSInteger Oripage = lround(fractionalPage);
        self.pageControl.currentPage = Oripage;
    }
    else{
        CGFloat pageWidth = self.view.frame.size.width;
        int fractionalPage = self.venueCollectionView.contentOffset.x / pageWidth;
        if(self.previousPage != fractionalPage) {
            self.previousPage= fractionalPage;
            if(fractionalPage == 0){
                [self settingInfoUnderLineView];
            }
            else if (fractionalPage == 1){
                [self settingOfferUnderLineView];
            }
            [self.venueCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:fractionalPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

-(void)settingOfferUnderLineView{
    self.infoUnderLineView.hidden = YES;
    self.offerUndeLineView.hidden = NO;
}
-(void)settingInfoUnderLineView{
    self.infoUnderLineView.hidden = NO;
    self.offerUndeLineView.hidden = YES;
}
@end
