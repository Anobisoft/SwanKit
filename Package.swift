// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwanKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Umbrella library exporting all underlying submodules (targets)
        .library(
            name: "SwanKit",
            targets: [
                "SwanKitFoundation", 
                "SwanKitList", 
                "SwanKitKeychain", 
                "SwanKitAccessProvider", 
                "SwanKitUIFoundation", 
                "SwanKitImagePicker", 
                "SwanKitSpeechRecognizer", 
                "SwanKitAppearance"
            ]
        )
    ],
    dependencies: [
        // External dependencies can be added here in the future
    ],
    targets: [
        // 1. Foundation
        .target(
            name: "SwanKitFoundation",
            path: "SwanKit/Foundation"
        ),
        
        // 2. List
        .target(
            name: "SwanKitList",
            path: "SwanKit/List"
        ),
        
        // 3. Keychain
        .target(
            name: "SwanKitKeychain",
            path: "SwanKit/Keychain"
        ),
        
        // 4. AccessProvider
        .target(
            name: "SwanKitAccessProvider",
            path: "SwanKit/AccessProvider"
        ),
        
        // 5. UIFoundation — depends on the base Foundation target
        .target(
            name: "SwanKitUIFoundation",
            path: "SwanKit/UIFoundation",
            dependencies: ["SwanKitFoundation"]
        ),
        
        // 6. ImagePicker — relies on system UI and AccessProvider
        .target(
            name: "SwanKitImagePicker",
            path: "SwanKit/ImagePicker",
            dependencies: ["SwanKitAccessProvider", "SwanKitFoundation", "SwanKitUIFoundation"]
        ),
        
        // 7. SpeechRecognizer — speech recognition submodule
        .target(
            name: "SwanKitSpeechRecognizer",
            path: "SwanKit/SpeechRecognizer",
            dependencies: ["SwanKitAccessProvider"]
        ),
        
        // 8. Appearance — styling and custom UI layer
        .target(
            name: "SwanKitAppearance",
            path: "SwanKit/Appearance",
            dependencies: ["SwanKitFoundation"]
        )
    ]
)
