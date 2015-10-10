//
//  FDCodeBasedViewController.m
//  FDStackViewDemo
//
//  Created by sunnyxx on 15/10/10.
//  Copyright © 2015年 forkingdog. All rights reserved.
//

#import "FDCodeBasedViewController.h"

@implementation FDCodeBasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *forkingLabel = [[UILabel alloc] init];
    forkingLabel.text = @"forking";
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forkingdog"]];
    UILabel *dogLabel = [[UILabel alloc] init];
    dogLabel.text = @"dog";
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[forkingLabel, logoImageView, dogLabel]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    [self.view addSubview:stackView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
