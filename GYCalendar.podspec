Pod::Spec.new do |s|
  s.name         = 'GYCalendar'
  s.version      = '1.2.2'
  s.summary  = 'A little kit of calendar which you can custom-made'
  s.homepage     = 'https://github.com/ShinyG'
  s.license      = 'MIT'
  s.author       = {'ShinyG' => '80937676@qq.com'}
  s.source       = { :git => 'https://github.com/ShinyG/GYCalendar.git', :tag => "#{s.version}" }
  # s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.resource = 'GYCalendar/*.{xib}'
  s.source_files = 'GYCalendar/*.{h,m}'
end