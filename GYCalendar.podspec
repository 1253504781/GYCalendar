
Pod::Spec.new do |s|

  s.name         = "GYCalendar"
  s.version      = "1.0.0"
  s.summary      = "A little kit of calendar which you can custom-made."

  s.homepage     = "https://github.com/ShinyG"


  s.license      = "MIT"

  s.author             = { "ShinyG" => "“80937676@qq.com

git config --global user.email “80937676@qq.com" }

  s.source       = { :git => "https://github.com/ShinyG/GYCalendar.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '6.0'
  s.source_files = 'GYCalendar'
  s.requires_arc = true



end
