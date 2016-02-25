Pod::Spec.new do |s|
  s.name        = "Sync"
  s.version     = "1.0"
  s.summary     = "Run asynchronous blocks synchronously"
  s.homepage    = "https://github.com/eneko/Sync"
  s.license     = { :type => "MIT" }
  s.authors     = { "Eneko Alonso" => "eneko.alonso@gmail.com" }

  s.osx.deployment_target = "10.8"
  s.ios.deployment_target = "7.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/eneko/Sync.git", :tag => s.version }
  s.source_files = "Sources/*.swift"
  s.requires_arc = true
  s.module_name = 'Sync'
end
