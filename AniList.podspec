#
# Be sure to run `pod lib lint AniList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AniList"
  s.version          = "0.1.0"
  s.summary          = "A SDK For AniList written in Swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SDK contain Client Oauthrization for just get data from AniList
                       DESC

  s.homepage         = "https://github.com/CodeEagle/AniList"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "CodeEagle" => "stasura@hotmail.com" }
  s.source           = { :git => "https://github.com/CodeEagle/AniList.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_SelfStudio'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AniList/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AniList' => ['AniList/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SSCacheControl'
  s.dependency 'Gloss'
end
