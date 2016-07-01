#
# Be sure to run `pod lib lint SunbeamAFNetworkingService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SunbeamAFNetworkingService'
  s.version          = '0.1.0'
  s.summary          = 'SunbeamAFNetworkingService is a simple structure for AFNetworking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
a simple structure for AFNetworking, you can use it to do http/https request with extend, and it's simple.
                       DESC

  s.homepage         = 'https://github.com/sunbeamChen/SunbeamAFNetworkingService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunbeamChen' => 'chenxun1990@126.com' }
  s.source           = { :git => 'https://github.com/sunbeamChen/SunbeamAFNetworkingService.git', :tag => s.version.to_s }
  # s.social_media_url = 'http://sunbeamchen.github.io/'

  s.ios.deployment_target = '7.0'

  s.requires_arc = true

  s.source_files = 'SunbeamAFNetworkingService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SunbeamAFNetworkingService' => ['SunbeamAFNetworkingService/Assets/*.png']
  # }

  s.prefix_header_contents = '#import "SunbeamAFServiceContext.h"','#import "SunbeamAFSingletonService.h"'

  s.public_header_files = 'SunbeamAFNetworkingService/Classes/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'AFNetworking', '~> 2.6.3'
end
