Pod::Spec.new do |s|
  s.name             = 'DocScannerSDK'
  s.version          = '1.0.0'
  s.summary          = 'Document scanner SDK with fixed crop area overlay for iOS'
  s.description      = <<-DESC
A comprehensive iOS SDK for document scanning with a fixed crop area overlay.
Perfect for capturing ID cards, passports, and documents for OCR processing.
                       DESC

  s.homepage         = 'https://github.com/Tareq-Ghassan/DocScannerSDK-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tareq Ghassan' => 'tareq.ghassan@example.com' }
  s.source           = { :git => 'https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '16.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/DocScannerSDK/**/*'
  
  s.frameworks = 'UIKit', 'AVFoundation', 'Vision'
end
