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

#import "FDStackView.h"
#import <objc/runtime.h>
#import "FDTransformLayer.h"
#import "FDStackViewAlignmentLayoutArrangement.h"
#import "FDStackViewDistributionLayoutArrangement.h"

@interface FDStackView ()
@property (nonatomic, strong) NSMutableArray *mutableArrangedSubviews;
@property (nonatomic, strong) FDStackViewAlignmentLayoutArrangement *alignmentArrangement;
@property (nonatomic, strong) FDStackViewDistributionLayoutArrangement *distributionArrangement;
@end

@implementation FDStackView

+ (Class)layerClass {
    return FDTransformLayer.class;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        // Attributes of UIStackView in interface builder that archived.
        [self commonInitializationWithArrangedSubviews:[decoder decodeObjectForKey:@"UIStackViewArrangedSubviews"]];
        self.axis = [decoder decodeIntegerForKey:@"UIStackViewAxis"];
        self.distribution = [decoder decodeIntegerForKey:@"UIStackViewDistribution"];
        self.alignment = [decoder decodeIntegerForKey:@"UIStackViewAlignment"];
        self.spacing = [decoder decodeDoubleForKey:@"UIStackViewSpacing"];
        self.baselineRelativeArrangement = [decoder decodeBoolForKey:@"UIStackViewBaselineRelative"];
        self.layoutMarginsRelativeArrangement = [decoder decodeBoolForKey:@"UIStackViewLayoutMarginsRelative"];
    }
    return self;
}

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInitializationWithArrangedSubviews:views];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializationWithArrangedSubviews:nil];
    }
    return self;
}

- (void)commonInitializationWithArrangedSubviews:(NSArray<__kindof UIView *> *)arrangedSubviews {
    self.mutableArrangedSubviews = (arrangedSubviews ?: @[]).mutableCopy;
    for (UIView *view in self.mutableArrangedSubviews) {
        [self addHiddenObserverForView:view];
    }
    
    self.distributionArrangement = [[FDStackViewDistributionLayoutArrangement alloc] initWithItems:arrangedSubviews onAxis:self.axis];
    self.distributionArrangement.canvas = self;
    self.alignmentArrangement = [[FDStackViewAlignmentLayoutArrangement alloc] initWithItems:arrangedSubviews onAxis:self.axis];
    self.alignmentArrangement.canvas = self;
    for (UIView *view in arrangedSubviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
}

#pragma mark - Public Arranged Subviews Operations

- (NSArray<UIView *> *)arrangedSubviews {
    return self.mutableArrangedSubviews.copy;
}

- (void)addArrangedSubview:(UIView *)view {
    if (!view || [self.mutableArrangedSubviews containsObject:view]) {
        return;
    }
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mutableArrangedSubviews addObject:view];
    [self.alignmentArrangement addItem:view];
    [self.distributionArrangement addItem:view];
    [self addHiddenObserverForView:view];
    [self updateLayoutArrangements];
}

- (void)removeArrangedSubview:(UIView *)view {
    if (![self.mutableArrangedSubviews containsObject:view] || ![view isDescendantOfView:self]) {
        return;
    }
    [self removeHiddenObserverForView:view];
    [self.mutableArrangedSubviews removeObject:view];
    [view removeFromSuperview];
    [self.alignmentArrangement removeItem:view];
    [self.distributionArrangement removeItem:view];
    [self updateLayoutArrangements];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if (!view || [self.mutableArrangedSubviews containsObject:view]) {
        return;
    }
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:view atIndex:stackIndex];
    [self.mutableArrangedSubviews insertObject:view atIndex:stackIndex];
    [self.alignmentArrangement insertItem:view atIndex:stackIndex];
    [self.distributionArrangement insertItem:view atIndex:stackIndex];
    [self addHiddenObserverForView:view];
    [self updateLayoutArrangements];
}

#pragma mark - Public Setters

- (void)setAxis:(UILayoutConstraintAxis)axis {
    if (_axis != axis) {
        _axis = axis;
        self.distributionArrangement.axis = axis;
        self.alignmentArrangement.axis = axis;
        [self updateLayoutArrangements];
    }
}

- (void)setDistribution:(UIStackViewDistribution)distribution {
    if (_distribution != distribution) {
        _distribution = distribution;
        self.distributionArrangement.distribution = distribution;
        [self updateLayoutArrangements];
    }
}

- (void)setAlignment:(UIStackViewAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        self.alignmentArrangement.alignment = alignment;
        [self updateLayoutArrangements];
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        self.distributionArrangement.spacing = spacing;
        [self updateLayoutArrangements];
    }
}

#pragma mark - Intrinsic Content Size Invalidation

// Use non-public API in UIView directly is dangerous, so we inject at runtime.
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selector = NSSelectorFromString(@"_intrinsicContentSizeInvalidatedForChildView:");
        Method method = class_getInstanceMethod(self, @selector(intrinsicContentSizeInvalidatedForChildView:));
        class_addMethod(self, selector, method_getImplementation(method), method_getTypeEncoding(method));
    });
}

- (void)intrinsicContentSizeInvalidatedForChildView:(UIView *)childView {
    [self.distributionArrangement intrinsicContentSizeInvalidatedForItem:childView];
    [self.alignmentArrangement intrinsicContentSizeInvalidatedForItem:childView];
}

#pragma mark - Layout

- (void)updateLayoutArrangements {
    [self.distributionArrangement removeDeprecatedConstraints];
    [self.alignmentArrangement removeDeprecatedConstraints];
    [self.distributionArrangement updateArrangementConstraints];
    [self.alignmentArrangement updateArrangementConstraints];
}

- (void)updateConstraints {
    [self updateLayoutArrangements];
    [super updateConstraints];
}

#pragma mark - Hidden KVO

static void *FDStackViewHiddenObservingContext = &FDStackViewHiddenObservingContext;

- (void)addHiddenObserverForView:(UIView *)view {
    [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:FDStackViewHiddenObservingContext];
}

- (void)removeHiddenObserverForView:(UIView *)view {
    [view removeObserver:self forKeyPath:@"hidden" context:FDStackViewHiddenObservingContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)view change:(NSDictionary *)change context:(void *)context {
    
    if (context != FDStackViewHiddenObservingContext) {
        return;
    }
    
    BOOL oldValue = [change[NSKeyValueChangeOldKey] boolValue];
    BOOL newValue = [change[NSKeyValueChangeNewKey] boolValue];
    if (newValue == oldValue) {
        return;
    }
    
    [self.alignmentArrangement updateArrangementConstraints];
    [self.distributionArrangement updateArrangementConstraints];
}

- (void)dealloc {
    for (UIView *view in _mutableArrangedSubviews) {
        [self removeHiddenObserverForView:view];
    }
}

@end

// ----------------------------------------------------
// Runtime injection start.
// Assemble codes below are based on:
// https://github.com/0xced/NSUUID/blob/master/NSUUID.m
// ----------------------------------------------------

#pragma mark - Runtime Injection

__asm(
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
#if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIStackView:\n"
      ".quad           _OBJC_CLASS_$_UIStackView\n"
#else
      ".align          2\n"
      "_OBJC_CLASS_UIStackView:\n"
      ".long           _OBJC_CLASS_$_UIStackView\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIStackView\n"
      );

// Constructors are called after all classes have been loaded.
__attribute__((constructor)) static void FDStackViewPatchEntry(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            // >= iOS9.
            if (objc_getClass("UIStackView")) {
                return;
            }
            
            Class *stackViewClassLocation = NULL;
            
#if TARGET_CPU_ARM
            __asm("movw %0, :lower16:(_OBJC_CLASS_UIStackView-(LPC0+4))\n"
                  "movt %0, :upper16:(_OBJC_CLASS_UIStackView-(LPC0+4))\n"
                  "LPC0: add %0, pc" : "=r"(stackViewClassLocation));
#elif TARGET_CPU_ARM64
            __asm("adrp %0, L_OBJC_CLASS_UIStackView@PAGE\n"
                  "add  %0, %0, L_OBJC_CLASS_UIStackView@PAGEOFF" : "=r"(stackViewClassLocation));
#elif TARGET_CPU_X86_64
            __asm("leaq L_OBJC_CLASS_UIStackView(%%rip), %0" : "=r"(stackViewClassLocation));
#elif TARGET_CPU_X86
            void *pc = NULL;
            __asm("calll L0\n"
                  "L0: popl %0\n"
                  "leal _OBJC_CLASS_UIStackView-L0(%0), %1" : "=r"(pc), "=r"(stackViewClassLocation));
#else
#error Unsupported CPU
#endif
            
            if (stackViewClassLocation && !*stackViewClassLocation) {
                Class class = objc_allocateClassPair(FDStackView.class, "UIStackView", 0);
                if (class) {
                    objc_registerClassPair(class);
                    *stackViewClassLocation = class;
                }
            }
        }
    });
}
