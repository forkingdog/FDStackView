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

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
#error "FDStackView must be compiled under iOS9 SDK at least"
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000
#warning "No need for FDStackView with a deploy iOS version greater than 9.0"
#endif

// No need to use this class directly, it is the internal class that actually works before iOS9.
@interface FDStackView : UIView

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views;

@property (nonatomic, copy, readonly) NSArray<__kindof UIView *> *arrangedSubviews;

- (void)addArrangedSubview:(UIView *)view;
- (void)removeArrangedSubview:(UIView *)view;
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;

@property (nonatomic, assign) UILayoutConstraintAxis axis;
@property (nonatomic, assign) UIStackViewDistribution distribution;
@property (nonatomic, assign) UIStackViewAlignment alignment;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign, getter=isBaselineRelativeArrangement) BOOL baselineRelativeArrangement;
@property (nonatomic, assign, getter=isLayoutMarginsRelativeArrangement) BOOL layoutMarginsRelativeArrangement;

@end
