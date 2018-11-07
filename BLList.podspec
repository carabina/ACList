#
# Be sure to run `pod lib lint BLList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLList'
  s.version          = '0.1.4'
  s.summary          = '快速配置下拉刷新、空白页，适用于 UITableView、UICollectionView、UIScrollView.'
  s.homepage         = 'https://github.com/ablettx/BLList'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ablettx' => 'ablettchen@gmail.com' }
  s.source           = { :git => 'https://github.com/ablettx/BLList.git', :tag => s.version.to_s }
  s.social_media_url = 'https://weibo.com/ablettchen'
  s.platform         = :ios, '8.0'
  

  s.ios.deployment_target = '8.0'
  s.source_files = 'BLList/Classes/**/*'
  s.requires_arc = true
  
  
  # s.resource_bundles = {
  #   'BLList' => ['BLList/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'MJRefresh', '~> 3.1.15.7'
  
end
