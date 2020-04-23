#
# Be sure to run `pod lib lint DLBanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DLBanner'
  s.version          = '0.1.1'
  s.summary          = 'A Swift Banner.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jeremyzj/DLBanner'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackincitibank@gmail.com' => 'zhangjian@createcloud.com' }
  s.source           = { :git => 'https://github.com/jeremyzj/DLBanner.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DLBanner/Classes/**/*'
  
  s.swift_version  = "4.2"
  s.swift_versions = ['4.0', '4.2', '5.0']

  s.frameworks = 'UIKit'
  s.dependency 'Kingfisher', '4.10.1'

  s.requires_arc = true
end
