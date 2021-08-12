Pod::Spec.new do |spec|
  spec.name = "Nivelir"
  spec.version = "1.1.0"
  spec.summary = "A Swift DSL for navigation in iOS and tvOS apps with a simplified, chainable, and compile time safe syntax."

  spec.homepage = "https://github.com/hhru/Nivelir"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Almaz Ibragimov" => "almazrafi@gmail.com" }
  spec.source = { :git => "https://github.com/hhru/Nivelir.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.1'
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'

  spec.ios.frameworks = 'Foundation'
  spec.ios.deployment_target = "10.0"

  spec.tvos.frameworks = 'Foundation'
  spec.tvos.deployment_target = "10.0"
end
