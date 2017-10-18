//
//  VenueDetailVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/9/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#define TopViewHeight 220
#import "OfferCell.h"

#import <MapKit/MapKit.h>

#import "VenueDetailVC.h"
typedef enum{
    PageTypeInfo,
    PageTypeOffers
} PageType;
@interface VenueDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoUnderLineView;
@property (weak, nonatomic) IBOutlet UIView *offerUndeLineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UILabel *noOffersLabel;

@property (nonatomic, assign) PageType pageType;
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
@end

@implementation VenueDetailVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self callingGetVenueDetailsApi];
}

-(void)initialisation{
    self.pageType = PageTypeInfo;
    self.offerTableView.estimatedRowHeight = 60;
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
    self.headingLabel.text = self.headingString;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -80, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.offersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferCell *offCell= (OfferCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    offCell.offerDetail = [self.offersArray objectAtIndex:indexPath.row];
    return offCell;
}

#pragma mark - UITableView Dalegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
            [self populateInfoViewWithReponse:[responseObject valueForKey:@"data"]];
            [self populateOfferListWithOffersArray:[[responseObject valueForKey:@"data"] valueForKey:@"offers"]];
        }
        
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        [[Utilities sharedHandler]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

-(void)populateInfoViewWithReponse:(id)response{
    self.phoneString = [NSString stringWithFormat:@"%@",[response valueForKey:@"phone"]];
    self.phoneLabel.text = self.phoneString;
    NSString *description = [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@",[response valueForKey:@"description"],[response valueForKey:@"address"],[response valueForKey:@"email"]];
    self.venueDescriptionLabel.text = description;
    NSString *startTimeString = [self getTimeInAmPmFormat:[response valueForKey:@"working_hours_start"]];
     NSString *endTimeString = [self getTimeInAmPmFormat:[response valueForKey:@"working_hours_end"]];
    self.timeLabel.text = [NSString stringWithFormat:@"OPEN: %@ - %@",startTimeString, endTimeString];
    self.imagesArray = [response valueForKey:@"venue_images"];
    self.latitude = [NSString stringWithFormat:@"%@",[response valueForKey:@"latittude"]];
    self.longitude = [NSString stringWithFormat:@"%@",[response valueForKey:@"longitude"]];
}

#pragma mark - Get Time In 24 Hours

-(NSString *)getTimeInAmPmFormat:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dateFormatter dateFromString:timeString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return [dateFormatter stringFromDate:time];
}

-(void)populateOfferListWithOffersArray:(NSArray *)offersArray{
    NSUInteger offerCount = offersArray.count;
    if(offerCount == 0){
        self.offerTableView.hidden = YES;
        self.noOffersLabel.hidden = NO;
    }
    else{
        self.offerTableView.hidden = NO;
        self.noOffersLabel.hidden = YES;
        self.offersArray = offersArray;
        [self.offerTableView reloadData];
    }
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
        [self.scrollView addSubview:gradientImageView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView){
        CGFloat pageWidth = self.scrollView.frame.size.width;
        float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        NSInteger Oripage = lround(fractionalPage);
        self.pageControl.currentPage = Oripage;
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
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@",self.latitude,self.longitude];
    if( ![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]] ){
        
    }
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonAction:(UIButton *)sender {
    self.pageType = PageTypeInfo;
    self.infoUnderLineView.hidden = NO;
    self.infoView.hidden = NO;
    self.offerView.hidden = YES;
    self.offerUndeLineView.hidden = YES;
}
- (IBAction)offersButtonAction:(UIButton *)sender {
    self.pageType = PageTypeOffers;
    self.infoUnderLineView.hidden = YES;
    self.infoView.hidden = YES;
    self.offerView.hidden = NO;
    self.offerUndeLineView.hidden = NO;
}

@end
