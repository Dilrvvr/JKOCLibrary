#
# Be sure to run `pod lib lint JKOCLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKOCLibrary'
  s.version          = '0.0.1'
  s.summary          = 'OC工具库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
#TODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://github.com/Dilrvvr/JKOCLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'albert' => 'jkdev123cool@gmail.com' }
  s.source           = { :git => 'git@github.com:Dilrvvr/JKOCLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '9.0'
  
  s.source_files = 'JKOCLibrary/Classes/JKOCLibrary.h'
  
  s.resource = 'JKOCLibrary/Assets/JKOCLibraryResource.bundle'
  
  #s.resource_bundles = {
    #'JKOCLibrary' => 'JKOCLibrary/Assets/**/*'
  #}
  
  s.default_subspec = ['Core']#, 'Safe', 'Category']
  
  s.subspec 'Core' do |ss|
      ss.source_files = 'JKOCLibrary/Classes/Core/**/*'
      ss.framework  = "UIKit", "Foundation"
  end
  
  
  # s.resource_bundles = {
  #   'JKOCLibrary' => ['JKOCLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  #s.dependency 'SDWebImage', '5.12.5'  # '5.11.1'
  
end
