Pod::Spec.new do |s|
  s.name = 'SunbeamAFNetworkingService'
  s.version = '0.1.0'
  s.summary = 'SunbeamAFNetworkingService is a simple structure for AFNetworking.'
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"sunbeamChen"=>"chenxun1990@126.com"}
  s.homepage = 'https://github.com/sunbeamChen/SunbeamAFNetworkingService'
  s.description = 'a simple structure for AFNetworking, you can use it to do http/https request with extend, and it's simple.'
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '7.0'
  s.ios.preserve_paths       = 'ios/SunbeamAFNetworkingService.framework'
  s.ios.public_header_files  = 'ios/SunbeamAFNetworkingService.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/SunbeamAFNetworkingService.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/SunbeamAFNetworkingService.framework'
end
