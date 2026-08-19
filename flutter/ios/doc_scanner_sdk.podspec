#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'doc_scanner_sdk'
  s.version          = '1.0.0'
  s.summary          = 'Document scanner SDK for Flutter'
  s.description      = <<-DESC
A Flutter plugin for document scanning with fixed crop area overlay.
                       DESC
  s.homepage         = 'https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tareq Ghassan' => 'tareq.ghassan@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
