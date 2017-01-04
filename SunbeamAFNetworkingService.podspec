Pod::Spec.new do |s|
  s.name             = 'SunbeamAFNetworkingService'
  s.version          = '0.2.16'
  s.summary          = 'SunbeamAFNetworkingService is a simple structure base on AFNetworking 2.6.3'

  s.homepage         = 'https://github.com/sunbeamChen/SunbeamAFNetworkingService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunbeamChen' => 'chenxun1990@126.com' }
  s.source           = { :git => 'https://github.com/sunbeamChen/SunbeamAFNetworkingService.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'SunbeamAFNetworkingService/Classes/**/*'
  s.public_header_files = 'SunbeamAFNetworkingService/Classes/**/*.h'
  s.dependency 'AFNetworking', '~> 2.6.3'
end
