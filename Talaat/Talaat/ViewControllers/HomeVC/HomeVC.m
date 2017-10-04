//
//  HomeVC.m
//  Talaat
//
//  Created by Bibin Mathew on 10/4/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()
@property (weak, nonatomic) IBOutlet UIButton *nightLifeAndDineButton;
@property (weak, nonatomic) IBOutlet UIButton *dineButton;
@property (weak, nonatomic) IBOutlet UIButton *nightLifeButton;

@end

@implementation HomeVC

-(void)initView{
    [super initView];
    [self initialisation];
}

-(void)initialisation{
    [self customisingButton:self.nightLifeAndDineButton];
    [self customisingButton:self.dineButton];
    [self customisingButton:self.nightLifeButton];
}

-(void)customisingButton:(UIButton *)button{
    button.layer.cornerRadius = button.frame.size.height/2;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
