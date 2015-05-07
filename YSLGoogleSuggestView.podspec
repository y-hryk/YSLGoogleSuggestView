@version = "0.0.1"
Pod::Spec.new do |s|
  s.name         = "YSLGoogleSuggestView"
  s.version      = @version
  s.summary      = "google auto completion"
  s.homepage     = "https://github.com/y-hryk/YSLGoogleSuggestView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "y-hryk" => "dev.hy630823@gmail.com" }
  s.source       = { :git => "https://github.com/y-hryk/YSLGoogleSuggestView.git", :tag => @version }
  s.source_files = 'YSLGoogleSuggestView/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
end