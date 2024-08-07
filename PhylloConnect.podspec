
Pod::Spec.new do |spec|


  spec.name         = 'PhylloConnect'
  spec.version      = '0.3.6'
  spec.summary      = 'Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your iOS app.'
  spec.description  = 'Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your iOS app. Connect SDK manages work platform authentication (credential validation, multi-factor authentication, error handling, etc).'

  spec.homepage     = 'https://github.com/getphyllo/phyllo-connect-ios'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       =  {'Phyllo' => 'phyl@getphyllo.com'}
  spec.source       = { :git => 'https://github.com/getphyllo/phyllo-connect-ios.git', :tag => spec.version.to_s }

  
  spec.vendored_frameworks = "PhylloConnect.xcframework"
  spec.platform = :ios
  spec.swift_version = '4.2'
  spec.ios.deployment_target  = '12.0'

end
