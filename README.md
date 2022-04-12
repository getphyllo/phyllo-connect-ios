# PhylloConnect for iOS
[![Version](https://img.shields.io/cocoapods/v/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)
[![License](https://img.shields.io/cocoapods/l/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)
[![Platform](https://img.shields.io/cocoapods/p/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)

Detailed instructions on how to integrate with PhylloConnect for iOS can be found in our main documentation at https://docs.getphyllo.com/docs/api-reference/b4a5896a9f1c0-i-os-sdk-integration.

## Requirements

To get started, you will require a client ID and secret to access the Phyllo environment. To get your API credentials, please reach out to us at contact@getphyllo.com.

## Installation

1 . If you haven’t already, install the latest version of CocoaPods. Refer the official CocoaPods documentation here if you want to know more about how to integrate CocoaPods with your project.
2 . Once you have a Podfile, add the following to it:
**For Cocoapods:**

- Create/Update your **Podfile** with the following contents

```ruby
platform :ios, '12.0'

target '<YourApp>' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for <YourApp>
  pod 'PhylloConnect'

end
```

3 . Run the following command from a terminal :
```ruby
 pod install
```
The current SDK version is 0.1.25.

4 . Run the following command from a terminal to update your pods :
```ruby
 pod update
```
or
 
```ruby
 pod repo update
```


## Author

Phyllo, phyl@getphyllo.com

## License

PhylloConnect is available under the MIT license. See the LICENSE file for more info.
