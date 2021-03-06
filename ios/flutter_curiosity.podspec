#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_curiosity'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/Wayaer/flutter-curiosity.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'My Company' => 'wayaer@foxmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.dependency 'SSZipArchive'
  s.dependency 'TZImagePickerController'
#  s.swift_version = '5.1'
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end

