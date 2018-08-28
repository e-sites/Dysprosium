Pod::Spec.new do |s|
  s.name         = "Dysprosium"
  s.version      = "5.0.2"
  s.author       = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "http://www.e-sites.nl"
  s.summary      = "Deallocation helper for runtime objects"
  s.source       = { :git => "https://github.com/e-sites/Dysprosium.git", :tag => "#{s.version}" }
  s.source_files = "Sources/*.{swift}"
  s.xcconfig     = { 'OTHER_SWIFT_FLAGS' => '"-D$(CONFIGURATION:identifier:upper)"' }

  s.platform     = :ios, '8.0'
  s.requires_arc  = true
end
