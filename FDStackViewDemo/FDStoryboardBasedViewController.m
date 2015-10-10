//
//  FDStoryboardBasedViewController.m
//  FDStackViewDemo
//
//  Created by sunnyxx on 15/9/15.
//  Copyright © 2015 forkingdog. All rights reserved.
//

#import "FDStoryboardBasedViewController.h"

@interface FDStoryboardBasedViewController ()
@property (nonatomic, weak) IBOutlet UIStackView *stackView;
@property (nonatomic, weak) IBOutlet UIImageView *forkingdogImageView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *axisSegmentControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *alignmentSegmentControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *distributionSegmentControl;
@property (nonatomic, weak) IBOutlet UISlider *spacingSlider;
@property (nonatomic, weak) IBOutlet UILabel *spacingLabel;
@property (nonatomic, strong) NSMutableArray *mutableAddingViews;
@end

@implementation FDStoryboardBasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateFromStackViewAttributes];
}

- (void)updateFromStackViewAttributes {
    self.axisSegmentControl.selectedSegmentIndex = self.stackView.axis;
    self.alignmentSegmentControl.selectedSegmentIndex = self.stackView.alignment;
    self.distributionSegmentControl.selectedSegmentIndex = self.stackView.distribution;
    self.spacingLabel.text = [NSString stringWithFormat:@"Spacing (%.1lf)", self.stackView.spacing];
    CGSize headerSize = [self.tableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, headerSize.width ?: CGRectGetWidth(self.view.frame), headerSize.height);
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

#pragma mark - Actions

- (IBAction)axisSegmentControlValueChangedAction:(UISegmentedControl *)sender {
    self.stackView.axis = sender.selectedSegmentIndex;
    [self updateFromStackViewAttributes];
}

- (IBAction)alignmentSegmentControlValueChangedAction:(UISegmentedControl *)sender {
    self.stackView.alignment = sender.selectedSegmentIndex;
    [self updateFromStackViewAttributes];
}

- (IBAction)distributionSegmentControlValueChangedAction:(UISegmentedControl *)sender {
    self.stackView.distribution = sender.selectedSegmentIndex;
    [self updateFromStackViewAttributes];
}

- (IBAction)spacingSliderValueChangedAction:(UISlider *)sender {
    self.stackView.spacing = sender.value;
    [self updateFromStackViewAttributes];
}

- (IBAction)hideAction:(id)sender {
    self.forkingdogImageView.hidden ^= 1;
}

- (IBAction)addAction:(id)sender {
    if (!self.mutableAddingViews) {
        self.mutableAddingViews = @[].mutableCopy;
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:25];
    label.backgroundColor = [UIColor colorWithWhite:arc4random_uniform(255) / 255.0 alpha:1];
    label.text = @(self.mutableAddingViews.count).stringValue;
    [self.stackView addArrangedSubview:label];

    [self.mutableAddingViews addObject:label];
    [self updateFromStackViewAttributes];
}

- (IBAction)removeAction:(id)sender {
    if (self.mutableAddingViews.count == 0) {
        return;
    }
    UILabel *label = self.mutableAddingViews.lastObject;
    [label removeFromSuperview];
    [self.mutableAddingViews removeObject:label];
    [self updateFromStackViewAttributes];
}

@end
