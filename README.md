![Logo](SwanLogo.png)

[![SPM Compatible](https://shields.io)](https://swift.org)
[![Version](https://shields.io)](http://cocoapods.org)
[![Platform](https://shields.io)](http://cocoapods.org)
[![Language](https://shields.io)](https://github.com)
[![License](https://shields.io)](https://github.com)

Collection of tools and extensions.

## Swift Package Manager Integration (Recommended)

To integrate **SwanKit** into your Xcode project using [Swift Package Manager](https://swift.org), add the package dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com.git", from: "1.0.0")
]
```

Or add it directly via Xcode:
1. Go to **File** ➔ **Add Packages...**
2. Enter the repository URL: `https://github.com.git`
3. Select dependency options and add it to your target.

## CocoaPods Integration

To integrate **SwanKit** into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:

```ruby
use_frameworks! #optional

target 'iOSTargetName' do
  platform :ios, '15.6'
  pod 'SwanKit'
end
```

Then, run the following command:
```bash
\$ pod install
```

## Requirements

| Minimum iOS Target | Minimum macOS Target | Minimum tvOS Target | Swift Version |
|:------------------:|:--------------------:|:-------------------:|:-------------:|
| iOS 15.6           | macOS 10.15 (Catalina)| tvOS 15.6           | Swift 6.2+    |
