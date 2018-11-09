#
# Be sure to run `pod lib lint ACList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name             = 'ACList'
    s.version          = '0.1.6'
    s.summary          = '快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView'
    s.homepage         = 'https://github.com/ablettchen/ACList'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ablettx' => 'ablettchen@gmail.com' }
    s.source           = { :git => 'https://github.com/ablettchen/ACList.git', :tag => s.version.to_s }
    s.social_media_url = 'https://weibo.com/ablettx'
    s.platform         = :ios, '8.0'


    s.ios.deployment_target = '8.0'
    s.source_files = 'ACList/Classes/**/*'
    s.requires_arc = true
    s.dependency 'MJRefresh', '~> 3.1.15.7'

end
