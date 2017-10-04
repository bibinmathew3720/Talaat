//
//  InnerPageVC.h
//  Talaat
//
//  Created by Bibin Mathew on 10/4/17.
//  Copyright © 2017 Talaat. All rights reserved.
//

#import "BaseViewController.h"
typedef enum{
    EventTypeNightLife = 0,
    EventTypeDine = 1,
    EventTypeNightLifeAndDine = 2,
}EventType;
@interface InnerPageVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (nonatomic, assign) EventType type;
@end
