# FDStackView

Use UIStackView as if it supports iOS6.

# Problem

UIStackView is a very handy tool to build flow layout, but it's available only when iOS9+, we've found some great compatible replacements like OAStackView, but we want more:  

- **Perfect downward compatible**, no infectivity, use UIStackView **directly** as if it's shipped from iOS6.
- Interface builder support, live preview.
- Keep layout constraints as closely as UIStackView constructs.

# Usage

**Import nothing, learn nothing, it just works.**

- It will automatically replace the symbol for UIStackView into FDStackView at runtime before iOS9. 

``` objc
// Works in iOS6+
UIStackView *stackView = [[UIStackView alloc] init];
stackView.axis = UILayoutConstraintAxisHorizontal;
stackView.distribution = UIStackViewDistributionFill;
stackView.alignment = UIStackViewAlignmentTop;
[stackView addArrangedSubview:[[UILabel alloc] init]];
[self.view addSubview:stackView];
```

- Interface Builder Support

Set `Builds for` option to `iOS 9.0 and later` to eliminate the version error in Xcode:

![How to use in IB](https://git.oschina.net/sunnyxx/FDStackView/raw/master/Snapshots/snapshot0.png?dir=0&filepath=Snapshots%2Fsnapshot0.png&oid=4b839935a0da5538fe4b0639e87783a982d51ee4&sha=8f3b47fc70f96a40e2e5ec595aebdb2a1db57dab)

Now, use UIStackView as you like and its reactive options and live preview: 

![UIStackView preview in IB](https://git.oschina.net/sunnyxx/FDStackView/raw/master/Snapshots/snapshot1.png?dir=0&filepath=Snapshots%2Fsnapshot1.png&oid=791307e2d501dbbfcb65ca48f443222482b29acc&sha=7c0b8ddedd02a6551151517f88dc38c3ea1ca799)

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

