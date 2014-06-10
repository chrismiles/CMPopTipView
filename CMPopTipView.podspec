Pod::Spec.new do |s|
  s.name     = 'CMPopTipView'
  s.version  = '2.2.3'
  s.license  = 'MIT'
  s.summary  = 'Custom UIView for iOS that pops up an animated "bubble" pointing at a button or other view. Useful for popup tips.'
  s.homepage = 'https://github.com/vittoriom/CMPopTipView'
  s.source   = { :git => 'https://github.com/vittoriom/CMPopTipView.git', :tag => '2.2.3' }
  s.platform = :ios
  s.source_files = 'CMPopTipView/*.{h,m}'
  s.framework = 'UIKit'
  s.requires_arc = true
  s.ios.deployment_target = "6.0"
end
