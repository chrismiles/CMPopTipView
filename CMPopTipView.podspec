Pod::Spec.new do |s|
  s.name         = "CMPopTipView"
  s.version      = "2.3.0"
  s.summary      = "Custom UIView for iOS that pops up an animated \"bubble\" pointing at a button or other view. Useful for popup tips."
  s.homepage     = "https://github.com/chrismiles/CMPopTipView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Chris Miles" => "http://chrismiles.info/" }
  s.source       = { :git => "https://github.com/chrismiles/CMPopTipView.git", :tag => "2.3.0" }
  s.platform     = :ios, "6.0"
  s.requires_arc = true
  s.source_files = "CMPopTipView/*.{h,m}"
  s.framework    = "UIKit"
end
