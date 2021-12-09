Pod::Spec.new do |s|
    s.name         = "PhylloConnect"
    s.version      = "1.0.0"
    s.summary      = "'The official PhylloConnect SDK for iOS.'"
    s.description  = <<-DESC
Phyllo Connect is a quick and secure way to connect work platforms via Phyllo in your iOS app. Connect SDK manages work platform authentication (credential validation, multi-factor authentication, error handling, etc).
		DESC
    s.homepage     = "https://github.com/getphyllo/ios-connect-sdk"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2018
                   Permission is granted to...
                  LICENSE
                }
    s.author             = { "Phyllo" => "phyl@getphyllo.com" }
    s.source       = { :git => "https://github.com/getphyllo/ios-connect-sdk.git", :tag => "#{s.version}" }
    s.public_header_files = "PhylloConnect.framework/Headers/*.h"
    s.source_files = "PhylloConnect.framework/Headers/*.h"
    s.vendored_frameworks = "PhylloConnect.framework"
    s.platform = :ios
    s.swift_version = "5.0"
    s.ios.deployment_target  = '12.0'
end


