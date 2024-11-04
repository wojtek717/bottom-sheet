Pod::Spec.new do |spec|

  spec.name         = "bottom-sheet"
  spec.version      = "0.5.0"
  spec.summary      = "A small and lightweight library that adds a bottom sheet that can be used with TabView to make it stay on top. And more!"

  spec.description  = <<-DESC
                       Bottom Sheet is a small and lightweight library that adds a bottom sheet for use with TabView, allowing it to stay on top.
                       It is ideal for creating sheets similar to those in Apple Maps, Shortcuts, and Apple Music. The library is currently in beta.
                       DESC

  spec.homepage     = "https://github.com/wojtek717/bottom-sheet.git"
  spec.author       = { 'Wojciech Konury' => 'https://github.com/wojtek717' }
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.source       = { :git => 'https://github.com/wojtek717/bottom-sheet.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '18.0'
  spec.swift_version         = '6.0'
  
  spec.source_files  = 'Sources/**/*.swift'

  spec.requires_arc = true

end
