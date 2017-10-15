//
//  VenueDetailVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/9/17.
//  Copyright © 2017 Talaat. All rights reserved.
//
#import "OfferCell.h"

#import "VenueDetailVC.h"
typedef enum{
    PageTypeInfo,
    PageTypeOffers
} PageType;
@interface VenueDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoUnderLineView;
@property (weak, nonatomic) IBOutlet UIView *offerUndeLineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;

@property (nonatomic, assign) PageType pageType;

@end

@implementation VenueDetailVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self callingGetAllVenuesApi];
}

-(void)initialisation{
    self.pageType = PageTypeInfo;
    self.offerTableView.estimatedRowHeight = 60;
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Button Actions

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferCell *offCell= (OfferCell *)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    //offCell.offerDetail = [self.offersArray objectAtIndex:indexPath.row];
    return offCell;
}

#pragma mark - UITableView Dalegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - Get Venue Details Api

-(void)callingGetAllVenuesApi{
    NSString *venueIdString = [NSString stringWithFormat:@"venue_id=%@",self.venueId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:TALAATURLTYPEFETCHVENUEDETAILS withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:url withBody:venueIdString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[[responseObject valueForKey:@"result"] valueForKey:@"response"] isEqualToString:@"success"]){

        }
        
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        [[Utilities sharedHandler]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
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
