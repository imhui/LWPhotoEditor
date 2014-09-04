Pod::Spec.new do |s|

  s.name         = "LWPhotoEditor"
  s.version      = "0.1"
  s.summary      = "iOS simple photo editor"
  s.homepage     = "https://github.com/imhui/LWPhotoEditor"
  s.license      = "MIT"
  s.author       = { "imhui" => "seasonlyh@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/imhui/LWPhotoEditor.git", :tag => "0.1" }
  s.source_files  = "LWPhotoEditor/PhotoEditor/*.{h,m}"

end
