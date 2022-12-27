#
# Be sure to run `pod lib lint SafeThreadWeakCollection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SafeThreadWeakCollection'
  s.version          = '1.0.0'
  s.summary          = 'Safe thread Weak reference Array (thread safe version of https://github.com/gsabatie/WeakCollection)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Safe thread Weak reference Array (thread safe version of https://github.com/gsabatie/WeakCollection)
                       DESC

  s.homepage         = 'https://github.com/ladeiko/SafeThreadWeakCollection'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Siarhei Ladzeika' => 'sergey.ladeiko@gmail.com' }
  s.source           = { :git => 'https://github.com/ladeiko/SafeThreadWeakCollection.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/**/*'
  s.swift_version = '4.2'
  
  # s.resource_bundles = {
  #   'SafeThreadWeakCollection' => ['SafeThreadWeakCollection/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end