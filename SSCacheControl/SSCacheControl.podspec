#
# Be sure to run `pod lib lint SSCacheControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SSCacheControl"
  s.version          = "0.1.4"
  s.summary          = "Client-Side Cache-Control Extension base on Alamofire and SwiftyJSON."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  Client-Side Cache-Control Extension base on Alamofire and SwiftyJSON. :]
                       DESC

  s.homepage         = "https://github.com/CodeEagle/SSCacheControl"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "CodeEagle" => "stasura@hotmail.com" }
  s.source           = { :git => "https://github.com/CodeEagle/SSCacheControl.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  # s.resource_bundles = {
  #   'SSCacheControl' => ['Pod/Assets/*.png']
  # }
  s.default_subspec = 'Default'
  s.dependency 'Alamofire'
  s.subspec 'Default' do |sp|
      sp.source_files = 'Source/SSCacheControl.swift','Source/SSCacheControl+Default.swift'
  end
  s.subspec 'SwiftyJSON' do |sp|
    sp.source_files = 'Source/SSCacheControl.swift', 'Source/SSCacheControl+SwiftyJSON.swift'
    sp.dependency 'SwiftyJSON'
  end

end
