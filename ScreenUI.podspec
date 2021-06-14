#
# Be sure to run `pod lib lint ScreenUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScreenUI'
  s.version          = '1.1.1'
  s.summary          = 'A multi-platform, multi-paradigm routing framework. `UIKit`, `AppKit`, `SwiftUI`'

  s.description      = <<-DESC
  A multi-platform, multi-paradigm routing framework for iOS/macOS and others, the replacement of Storyboard. Supports `UIKit`, `AppKit`, `SwiftUI`.
                       DESC

  s.homepage         = 'https://github.com/k-o-d-e-n/ScreenUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'k-o-d-e-n' => 'koden.u8800@gmail.com' }
  s.source           = { :git => 'https://github.com/k-o-d-e-n/ScreenUI.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/K_o_D_e_N'

  s.swift_version = '5.3'

  s.ios.deployment_target = '9.0'
  s.macos.deployment_target = '10.15'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '7.0'
  s.default_subspec = 'Release'
  s.subspec 'Release' do |r|
      r.source_files = 'Sources/ScreenUI/**/*'
      r.exclude_files = 'Sources/**/*.gyb'
  end
  s.subspec 'Beta' do |b|
      b.dependency 'ScreenUI/Release'
      b.pod_target_xcconfig = {
        'SWIFT_ACTIVE_COMPILATION_CONDITIONS[config=Debug]' => '$(inherited) SCREENUI_BETA'
      }
  end
end
