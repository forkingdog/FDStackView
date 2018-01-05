# FDStackView

Use UIStackView as if it supports iOS6.
![forkingdog](https://cloud.githubusercontent.com/assets/219689/7244961/4209de32-e816-11e4-87bc-b161c442d348.png)

# Problem

UIStackView is a very handy tool to build flow layout, but it's available only when iOS9+, we've found some great compatible replacements like OAStackView, but we want more:  

- **Perfect downward compatible**, no infectivity, use UIStackView **directly** as if it's shipped from iOS6.
- **Interface builder support**, live preview.
- Keep layout constraints as closely as UIStackView constructs.

# Usage

#### Podfile
```ruby
platform :ios, '7.0'
pod "FDStackView", "1.0"
```

**Import nothing, learn nothing, it just works.**

- It will automatically replace the symbol for UIStackView into FDStackView at runtime before iOS9. 

``` objc
// Works in iOS6+, use it directly.
UIStackView *stackView = [[UIStackView alloc] init];
stackView.axis = UILayoutConstraintAxisHorizontal;
stackView.distribution = UIStackViewDistributionFill;
stackView.alignment = UIStackViewAlignmentTop;
[stackView addArrangedSubview:[[UILabel alloc] init]];
[self.view addSubview:stackView];
```

- Interface Builder Support

Set `Builds for` option to `iOS 9.0 and later` to eliminate the version error in Xcode:

![How to use in IB](https://raw.githubusercontent.com/forkingdog/FDStackView/master/Snapshots/snapshot0.png)

Now, use UIStackView as you like and its reactive options and live preview: 

![UIStackView preview in IB](https://raw.githubusercontent.com/forkingdog/FDStackView/master/Snapshots/snapshot1.png)

# Requirements

- Xcode 7+ (For interface builder supports and the latest Objective-C Syntax)
- Base SDK iOS 9.0+ (To link UIStackView symbol in UIKit)

# Versions

- 1.0.1 is the lastest version. We released it after we have used it in our official application. And it was successfully passed through the App Store's review. So you have no concern to use it.

# License

 The MIT License (MIT)

 Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

