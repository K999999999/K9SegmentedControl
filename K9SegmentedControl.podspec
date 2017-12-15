#
#  Be sure to run `pod spec lint K9SegmentedControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "K9SegmentedControl"
  s.version      = "0.0.2"
  s.summary      = "K9SegmentedControl"
  s.description  = "A common Segmented Control."
  s.homepage     = "https://github.com/K999999999/K9SegmentedControl"
  s.license      = "MIT"
  s.author       = { "K999999999" => "peishen_duan@pinssible.com" }
  s.source       = { :git => "https://github.com/K999999999/K9SegmentedControl.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.ios.deployment_target = "8.0"
  s.default_subspec = 'K9SegmentedControl'

  s.subspec 'K9SegmentedControl' do |ss|
    ss.ios.source_files  = 'K9SegmentedControl/*.{h,m}',
    ss.public_header_files = 'K9SegmentedControl/*.h'
  end

  s.dependency 'Masonry'

end