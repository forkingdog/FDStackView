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

#import "FDStackViewExtensions.h"
#import <objc/runtime.h>

@implementation NSMapTable (FDAllObjects)

- (NSArray *)fd_allObjects {
    return self.objectEnumerator.allObjects ?: @[];
}

@end

@implementation NSLayoutConstraint (FDStackViewExtensions)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // iOS6 patch
        if(!class_getProperty(self, "identifier")) {
            SEL getterSelector = sel_registerName("identifier");
            class_addMethod(self, getterSelector, imp_implementationWithBlock(^(id self) {
                return objc_getAssociatedObject(self, getterSelector);
            }), "@@");
            class_addMethod(self, sel_registerName("setIdentifier:"), imp_implementationWithBlock(^(id self, id value) {
                objc_setAssociatedObject(self, getterSelector, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
            }), "v@:@");
        }
    });
}

@end

@implementation NSArray (FDCarAndCdr)

- (id)car {
    return self.firstObject;
}

- (NSArray *)cdr {
    if (self.count <= 1) return nil;
    return [self subarrayWithRange:(NSRange){1, self.count - 1}];
}

@end
