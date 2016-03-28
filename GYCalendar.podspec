Pod::Spec.new do |s|
  s.name         = 'GYCalendar'
  s.version      = '2.0.0'
  s.summary  = 'A little kit of calendar which you can custom-made'
  s.homepage     = 'https://github.com/ShinyG'
  s.license      = 'MIT'
  s.author       = {'ShinyG' => '80937676@qq.com'}
  s.source       = { :git => 'https://github.com/ShinyG/GYCalendar.git', :tag => "#{s.version}" }
  # s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.source_files = 'GYCalendar/*.{h,m}'
  s.requires_arc = true
end