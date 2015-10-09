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

#import "FDStackViewLayoutArrangement.h"
#import "FDStackViewAlignmentLayoutArrangement.h"
#import "FDStackViewDistributionLayoutArrangement.h"

@implementation FDStackViewLayoutArrangement

- (instancetype)initWithItems:(NSArray *)items onAxis:(UILayoutConstraintAxis)axis {
    if (self = [super init]) {
        _mutableItems = [[NSMutableArray alloc] initWithArray:items];
        _canvasConnectionConstraints = [NSMutableArray array];
        _axis = axis;
    }
    return self;
}

- (void)addItem:(UIView *)item {
    [self.mutableItems addObject:item];
}

- (void)removeItem:(UIView *)item {
    [self.mutableItems removeObject:item];
}

- (void)insertItem:(UIView *)item atIndex:(NSUInteger)index {
    [self.mutableItems insertObject:item atIndex:index];
}

- (NSArray *)items {
    return self.mutableItems.copy;
}

- (void)intrinsicContentSizeInvalidatedForItem:(id)item {
    [self updateArrangementConstraints];
}

- (void)updateArrangementConstraints {
    [self updateCanvasConnectionConstraintsIfNecessary];
}

@end
