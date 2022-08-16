#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint verloop_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'verloop_flutter_sdk'
  s.version          = '0.0.4'
  s.summary          = 'Flutter SDK'
  s.description      = <<-DESC
This is a wrapper over native SDK for flutter app
                       DESC
  s.homepage         = 'http://verloop.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Verloop' => 'raghav@verloop.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency "VerloopSDKiOS", "0.2.5"
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
