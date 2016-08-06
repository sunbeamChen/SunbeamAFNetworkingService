Pod::Spec.new do |s|
  s.name             = 'SunbeamAFNetworkingService'
  s.version          = '0.2.6'
  s.summary          = 'SunbeamAFNetworkingService is a simple structure for AFNetworking.'

  s.homepage         = 'https://github.com/sunbeamChen/SunbeamAFNetworkingService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunbeamChen' => 'chenxun1990@126.com' }
  s.source           = { :git => 'https://github.com/sunbeamChen/SunbeamAFNetworkingService.git', :tag => s.version.to_s }
  #s.social_media_url = 'http://sunbeamchen.github.io/'

  s.ios.deployment_target = '7.0'

  s.requires_arc = true

  s.source_files = 'SunbeamAFNetworkingService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SunbeamAFNetworkingService' => ['SunbeamAFNetworkingService/Assets/*.png']
  # }

  #s.prefix_header_file = 'SunbeamAFNetworkingService/Classes/Helper/SunbeamAFPrefix.pch'

  #s.prefix_header_contents = '#import "SunbeamAFServiceContext.h"','#import "SunbeamAFSingletonService.h"'

  s.public_header_files = 'SunbeamAFNetworkingService/Classes/SunbeamAFNetworkingService.h','SunbeamAFNetworkingService/Classes/Standard/*.h','SunbeamAFNetworkingService/Classes/HTTPClient/SunbeamAFResponse.h','SunbeamAFNetworkingService/Classes/Helper/SunbeamAFSingletonService.h'

  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'AFNetworking', '~> 2.6.3'
end
