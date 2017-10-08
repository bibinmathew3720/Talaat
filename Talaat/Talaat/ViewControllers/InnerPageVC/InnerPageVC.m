//
//  InnerPageVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/4/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "InnerPageVC.h"

@interface InnerPageVC ()

@end

@implementation InnerPageVC

-(void)initView{
    [super initView];
    [self initialisation];
}

-(void)initialisation{
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
- (IBAction)phoneButtonAction:(UIButton *)sender {
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
