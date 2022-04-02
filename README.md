# PhylloConnect for iOS
[![Version](https://img.shields.io/cocoapods/v/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)
[![License](https://img.shields.io/cocoapods/l/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)
[![Platform](https://img.shields.io/cocoapods/p/PhylloConnect.svg?style=flat)](http://cocoadocs.org/docsets/PhylloConnect)

Detailed instructions on how to integrate with PhylloConnect for iOS can be found in our main documentation at https://docs.getphyllo.com/docs/api-reference/ZG9jOjEwMzE3ODQ5-i-os-sdk-integration.

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
The current SDK version is 0.1.24.

4 . Run the following command from a terminal to update your pods :
```ruby
 pod update
```
or
 
```ruby
 pod repo update
```

**For Manual(XcFramework):**

Get the latest version of the PhylloConnect.xcframework and embed it into your application, for example by dragging and dropping the XCFramework bundle onto the Embed Frameworks build phase of your application target in Xcode.

### Creating a user and token

- [Check this document on creating a user](https://docs.getphyllo.com/docs/api-reference/b3A6MTQwNjEzNzY-create-a-user)
- [Check this document on creating a user token](https://docs.getphyllo.com/docs/api-reference/b3A6MTQwNjEzNzc-create-an-sdk-token)


###Create a Phyllo Connect SDK Configuration

```ruby
 import PhylloConnect

...


  let phylloConfig = PhylloConfig (
                                            environment: < `sandbox` or `production` > ,
                                            clientDisplayName: <your app that you want the creators to see>,
                                            token: < token>
                                            userId: < the unique user_id parameter returned by Phyllo API >,
                                            delegate:self ,
					    workPlatformId: workPlatformId
                                        )
   // clientDisplayName  the name of your app that you want the creators to see while granting access
   // token it will be generated from your end
   // userId   the unique user_id parameter returned by Phyllo API when you create a user (see https://docs.getphyllo.com/docs/api-reference/reference/openapi.v1.yml/paths/~1v1~1users/post)
  phylloConfig.environment = environment  // the mode in which you want to use the SDK,  `sandbox` or `production`
  phylloConfig.workPlatformId = workPlatformId  // (optional) the unique work_platform_id of a specific work platform, if you want the creator to skip the platform selection screen and just be able to connect just with a single work platform

  PhylloConnect.shared.initialize(config: phylloConfig)
...

```
### Open Phyllo SDK flow
After initialization, the Phyllo Connect SDK flow can simply be invoked on any screen.
```ruby
import PhylloConnect
...
  PhylloConnect.shared.open()
...

```
### List of delegate functions
You can optionally listen for events in your app. These event triggers are listed below.
| EVENT | TRIGGER |  METHOD NAME |
| -----------| ------------| --------- |
| Account connected | Triggered when the user successfully connects a work platform account | onAccountConnected |
| Account disconnected | Triggered when the user successfully disconnects a work platform account | onAccountConnected |
| Token expired | Triggered when the token used to initialize the SDK is more than 7 days old | onTokenExpired |
| Exit | Triggered when the user exits the SDK | onExit |

### Here is how you can do this for your iOS app.
Step 1 Set the phylloConnectDelegate to an appropriate class that can take action when the event is triggered.
```ruby
...
PhylloConnect.shared.phylloConnectDelegate = self
...
```
Step 2 Subscribe to the delegate methods.
```ruby
extension YourDelegateClass : PhylloConnectDelegate {

    func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {  // gives the successfully connected account ID and work platform ID for the given user ID
        print("onAccountConnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
    }

    func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {  // gives the successfully disconnected account ID and work platform ID for the given user ID
        print("onAccountDisconnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
    }

    func onTokenExpired(user_id: String) {  // gives the user ID for which the token has expired
        print("onTokenExpired => user_id : \(user_id)")
    }

    func onExit(reason: String, user_id: String) {  // indicated that the user with given user ID has closed the SDK and gives an appropriate reason for it
        print("onExit => reason : \(reason),user_id : \(user_id)")
    }
}
```
## Author

Phyllo, phyl@getphyllo.com

## License

PhylloConnect is available under the MIT license. See the LICENSE file for more info.
