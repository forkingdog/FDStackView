
Pod::Spec.new do |s|
  s.name         = "FDStackView"
  s.version      = "1.0"
  s.summary      = "Use UIStackView as if it supports iOS6+."

  s.description  = <<-DESC
                   # Problem

                   UIStackView is a very handy tool to build flow layout, but it's available only when iOS9+, we've found some great compatible replacements like OAStackView, but we want more:  

                   - **Perfect downward compatible**, no infectivity, use UIStackView **directly** as if it's shipped from iOS6.
                   - **Interface builder support**, live preview.
                   - Keep layout constraints as closely as UIStackView constructs.

                   # Usage

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
                   DESC

  s.homepage     = "https://github.com/forkingdog/FDStackView"
  
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "MIT", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "forkingdog group" => "https://github.com/forkingdog" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "6.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/forkingdog/FDStackView.git", :tag => "1.0" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "FDStackView/*.{h,m}"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
