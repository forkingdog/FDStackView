// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "FDStackViewDistributionLayoutArrangement.h"
#import "FDStackViewExtensions.h"
#import "FDGapLayoutGuide.h"

@interface FDStackViewDistributionLayoutArrangement ()

@property (nonatomic, strong) NSMapTable<UIView *, FDGapLayoutGuide *> *spacingOrCenteringGuides;
@property (nonatomic, strong) NSMapTable<UIView *, NSLayoutConstraint *> *edgeToEdgeConstraints;
@property (nonatomic, strong) NSMapTable<UIView *, NSLayoutConstraint *> *relatedDimensionConstraints;
@property (nonatomic, strong) NSMapTable<UIView *, NSLayoutConstraint *> *hiddingDimensionConstraints;

@end

@implementation FDStackViewDistributionLayoutArrangement

- (instancetype)initWithItems:(NSArray *)items onAxis:(UILayoutConstraintAxis)axis {
    self = [super initWithItems:items onAxis:axis];
    if (self) {
        _spacingOrCenteringGuides = [NSMapTable weakToWeakObjectsMapTable];
        _edgeToEdgeConstraints = [NSMapTable weakToWeakObjectsMapTable];
        _relatedDimensionConstraints = [NSMapTable weakToWeakObjectsMapTable];
        _hiddingDimensionConstraints = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

- (void)setCanvas:(FDStackView *)canvas {
    [super setCanvas:canvas];
}

- (NSLayoutRelation)edgeToEdgeRelation {
    return self.distribution >= UIStackViewDistributionEqualSpacing ? NSLayoutRelationGreaterThanOrEqual : NSLayoutRelationEqual;
}

- (void)resetFillEffect {
    // spacing - edge to edge
    [self.canvas removeConstraints:self.edgeToEdgeConstraints.fd_allObjects];
    [self.edgeToEdgeConstraints removeAllObjects];
    [self.canvas removeConstraints:self.hiddingDimensionConstraints.fd_allObjects];
    [self.hiddingDimensionConstraints removeAllObjects];

    UIView *offset = self.items.car;
    UIView *last = self.items.lastObject;
    for (UIView *view in self.items.cdr) {
        NSLayoutAttribute attribute = [self minAttributeForGapConstraint];
        NSLayoutRelation relation = [self edgeToEdgeRelation];
        NSLayoutConstraint *spacing = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:relation toItem:offset attribute:attribute + 1 multiplier:1 constant:self.spacing];
        spacing.identifier = @"FDSV-spacing";
        [self.canvas addConstraint:spacing];
        [self.edgeToEdgeConstraints setObject:spacing forKey:offset];
        if (offset.hidden || (view == last && view.hidden)) {
            spacing.constant = 0;
        }
        offset = view;
    }
    // hidding dimensions
    for (UIView *view in self.items) {
        if (view.hidden) {
            NSLayoutAttribute dimensionAttribute = [self dimensionAttributeForCurrentAxis];
            NSLayoutConstraint *dimensionConstraint = [NSLayoutConstraint constraintWithItem:view attribute:dimensionAttribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
            dimensionConstraint.identifier = @"FDSV-hiding";
            [self.canvas addConstraint:dimensionConstraint];
            [self.hiddingDimensionConstraints setObject:dimensionConstraint forKey:view];
        }
    }
}

- (void)resetEquallyEffect {
    [self.canvas removeConstraints:self.relatedDimensionConstraints.fd_allObjects];
    [self.relatedDimensionConstraints removeAllObjects];
    
    NSArray<UIView *> *visiableViews = self.visiableItems;
    UIView *offset = visiableViews.car;
    CGFloat order = 0;
    for (UIView *view in visiableViews.cdr) {
        NSLayoutAttribute attribute = [self dimensionAttributeForCurrentAxis];
        NSLayoutRelation relation = NSLayoutRelationEqual;
        CGFloat multiplier = self.distribution == UIStackViewDistributionFillEqually ? 1: ({
            CGSize size1 = offset.intrinsicContentSize;
            CGSize size2 = view.intrinsicContentSize;
            CGFloat multiplier = 1;
            if (attribute == NSLayoutAttributeWidth) {
                multiplier = size1.width / size2.width;
            } else {
                multiplier = size1.height / size2.height;
            }
            multiplier;
        });
        NSLayoutConstraint *equally = [NSLayoutConstraint constraintWithItem:offset attribute:attribute relatedBy:relation toItem:view attribute:attribute multiplier:multiplier constant:0];
        equally.priority = UILayoutPriorityRequired - (++order);
        equally.identifier = self.distribution == UIStackViewDistributionFillEqually ? @"FDSV-fill-equally" : @"FDSV-fill-proportionally";
        [self.canvas addConstraint:equally];
        [self.relatedDimensionConstraints setObject:equally forKey:offset];
        
        offset = view;
    }
}

- (NSArray<UIView *> *)visiableItems {
    return [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden=NO"]];
}

- (void)resetGapEffect {
    [self resetSpacingOrCenteringGuides];
    [self resetSpacingOrCenteringGuideRelatedDimensionConstraints];
}

- (void)resetSpacingOrCenteringGuides {
    [self.spacingOrCenteringGuides.fd_allObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.spacingOrCenteringGuides removeAllObjects];
    NSArray<UIView *> *visiableItems = self.visiableItems;
    if (visiableItems.count <= 1) {
        return;
    }
    
    [[visiableItems subarrayWithRange:(NSRange){0, visiableItems.count - 1}] enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        FDGapLayoutGuide *guide = [FDGapLayoutGuide new];
        [self.canvas addSubview:guide];
        guide.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *relatedToItem = visiableItems[idx+1];
        
        NSLayoutAttribute minGapAttribute = [self minAttributeForGapConstraint];
        NSLayoutAttribute minContentAttribute;
        NSLayoutAttribute maxContentAttribute;
        if (self.distribution == UIStackViewDistributionEqualCentering) {
            minContentAttribute = self.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
            maxContentAttribute = minContentAttribute;
        } else {
            minContentAttribute = minGapAttribute;
            maxContentAttribute = minGapAttribute + 1;
        }
        
        NSLayoutConstraint *beginGap = [NSLayoutConstraint constraintWithItem:guide attribute:minGapAttribute relatedBy:NSLayoutRelationEqual toItem:item attribute:maxContentAttribute multiplier:1 constant:0];
        beginGap.identifier = @"FDSV-distributing-edge";
        NSLayoutConstraint *endGap = [NSLayoutConstraint constraintWithItem:relatedToItem attribute:minContentAttribute relatedBy:NSLayoutRelationEqual toItem:guide attribute:minGapAttribute + 1 multiplier:1 constant:0];
        endGap.identifier = @"FDSV-distributing-edge";
        [self.canvas addConstraint:beginGap];
        [self.canvas addConstraint:endGap];
        
        [self.spacingOrCenteringGuides setObject:guide forKey:item];
    }];
}

- (void)resetSpacingOrCenteringGuideRelatedDimensionConstraints {
    [self.canvas removeConstraints:self.relatedDimensionConstraints.fd_allObjects];
    NSArray<UIView *> *visiableItems = self.visiableItems;
    if (visiableItems.count <= 1) return;

    FDGapLayoutGuide *firstGapGuide = [self.spacingOrCenteringGuides objectForKey:visiableItems.car];
    [self.spacingOrCenteringGuides.fd_allObjects enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (firstGapGuide == obj) return;
        NSLayoutAttribute dimensionAttribute = [self dimensionAttributeForCurrentAxis];
        NSLayoutConstraint *related = [NSLayoutConstraint constraintWithItem:firstGapGuide attribute:dimensionAttribute relatedBy:NSLayoutRelationEqual toItem:obj attribute:dimensionAttribute multiplier:1 constant:0];
        related.identifier = @"FDSV-fill-equally";
        [self.relatedDimensionConstraints setObject:related forKey:obj];
        [self.canvas addConstraint:related];
    }];
}

- (void)resetCanvasConnectionsEffect {
    [self.canvas removeConstraints:self.canvasConnectionConstraints];
    if (!self.items.count) return;
    
    NSMutableArray *canvasConnectionConstraints = [NSMutableArray new];
    NSLayoutAttribute minAttribute = [self minAttributeForCanvasConnections];
    NSLayoutConstraint *head = [NSLayoutConstraint constraintWithItem:self.canvas attribute:minAttribute relatedBy:NSLayoutRelationEqual toItem:self.items.firstObject attribute:minAttribute multiplier:1 constant:0];
    [canvasConnectionConstraints addObject:head];
    head.identifier = @"FDSV-canvas-connection";
    
    NSLayoutConstraint *end = [NSLayoutConstraint constraintWithItem:self.canvas attribute:minAttribute+1 relatedBy:NSLayoutRelationEqual toItem:self.items.lastObject attribute:minAttribute+1 multiplier:1 constant:0];
    [canvasConnectionConstraints addObject:end];
    head.identifier = @"FDSV-canvas-connection";

    self.canvasConnectionConstraints = canvasConnectionConstraints;
    [self.canvas addConstraints:canvasConnectionConstraints];
}

- (void)resetAllConstraints {
    [self resetCanvasConnectionsEffect];
    [self resetFillEffect];
    
    switch (self.distribution) {
        case UIStackViewDistributionFillEqually:
        case UIStackViewDistributionFillProportionally:
            // related dimension
            [self resetEquallyEffect];
            break;
            
        case UIStackViewDistributionEqualCentering:
        case UIStackViewDistributionEqualSpacing:
            // spacing or centering
            [self resetGapEffect];
            break;
            
        default:
            break;
    }
}

- (void)removeDeprecatedConstraints {
    [self.canvas removeConstraints:self.edgeToEdgeConstraints.fd_allObjects];
    [self.edgeToEdgeConstraints removeAllObjects];

    [self.canvas removeConstraints:self.relatedDimensionConstraints.fd_allObjects];
    [self.relatedDimensionConstraints removeAllObjects];

    [self.canvas removeConstraints:self.hiddingDimensionConstraints.fd_allObjects];
    [self.hiddingDimensionConstraints removeAllObjects];

    [self.spacingOrCenteringGuides.fd_allObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.spacingOrCenteringGuides removeAllObjects];
}

- (NSLayoutRelation)layoutRelationForCanvasConnectionForAttribute:(NSLayoutAttribute)attribute {
    return NSLayoutRelationEqual;
}

- (NSLayoutAttribute)minAttributeForCanvasConnections {
    return self.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
}

- (NSLayoutAttribute)centerAttributeForCanvasConnections {
    return NSLayoutAttributeCenterY - self.axis; // wtf
}

- (NSLayoutAttribute)dimensionAttributeForCurrentAxis {
    return NSLayoutAttributeWidth + self.axis; // wtf
}

- (NSLayoutAttribute)minAttributeForGapConstraint {
    return self.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
}

- (void)updateCanvasConnectionConstraintsIfNecessary {
    [self resetAllConstraints];
}

@end
