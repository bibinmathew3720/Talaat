//
//  VenueDetailVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/9/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "VenueDetailVC.h"

@interface VenueDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *infoUnderLineView;
@property (weak, nonatomic) IBOutlet UIView *offerUndeLineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueDescriptionLabel;

@end

@implementation VenueDetailVC

-(void)initView{
    [super initView];
    [self initialisation];
}

-(void)initialisation{
    
}

#pragma mark - Button Actions

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)infoButtonAction:(UIButton *)sender {
}
- (IBAction)offersButtonAction:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
