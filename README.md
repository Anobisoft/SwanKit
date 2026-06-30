![Logo](SwanLogo.png)

[![SPM Compatible](https://img.shields.io/badge/Swift_Package_Manager-compatible-4BC51D.svg)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/SwanKit.svg)](http://cocoapods.org/pods/SwanKit)
[![Platform](https://img.shields.io/cocoapods/p/SwanKit.svg)](http://cocoapods.org/pods/SwanKit)
[![Language](https://img.shields.io/github/languages/top/Anobisoft/SwanKit.svg)](https://github.com/Anobisoft/SwanKit)
[![License](https://img.shields.io/cocoapods/l/SwanKit.svg)](http://cocoapods.org/pods/SwanKit)


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
