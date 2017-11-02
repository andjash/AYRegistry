Pod::Spec.new do |s|
  s.name             = 'AYRegistry'
  s.version          = '0.1.0'
  s.summary          = 'DI in 100 lines of code!'
  s.description      = 'Simple dependency injection container for your needs'

  s.homepage         = 'https://github.com/andjash/AYRegistry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'andjash' => 'andjash@gmail.ru' }
  s.source           = { :git => 'https://github.com/andjash/AYRegistry.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'AYRegistry/Classes/**/*'

end
