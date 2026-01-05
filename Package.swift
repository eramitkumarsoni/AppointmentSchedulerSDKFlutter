// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AppointmentSchedulerSDKFlutter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AppointmentSchedulerSDKFlutter",
            targets: ["AppointmentSchedulerSDKFlutter"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppointmentSchedulerSDKFlutter",
            dependencies: [
                "App",
                "Flutter",
                "DKImagePickerController",
                "DKPhotoGallery",
                "FirebaseCore",
                "FirebaseCoreInternal",
                "GoogleUtilities",
                "SDWebImage",
                "SwiftyGif",
                "audio_session",
                "connectivity_plus",
                "file_picker",
                "file_selector_ios",
                "firebase_core",
                "flutter_secure_storage",
                "get_thumbnail_video",
                "image_gallery_saver_plus",
                "image_picker_ios",
                "just_audio",
                "libwebp",
                "media_kit_video",
                "package_info_plus",
                "path_provider_foundation",
                "photo_manager",
                "share_plus",
                "sqflite_darwin",
                "url_launcher_ios",
                "video_player_avfoundation",
                "volume_controller",
                "wakelock_plus"
            ],
            path: "Sources/AppointmentSchedulerSDKFlutter"
        ),
        
        // Binary targets
        .binaryTarget(name: "App", path: "Binaries/App.xcframework"),
        .binaryTarget(name: "Flutter", path: "Binaries/Flutter.xcframework"),
        .binaryTarget(name: "DKImagePickerController", path: "Binaries/DKImagePickerController.xcframework"),
        .binaryTarget(name: "DKPhotoGallery", path: "Binaries/DKPhotoGallery.xcframework"),
        .binaryTarget(name: "FirebaseCore", path: "Binaries/FirebaseCore.xcframework"),
        .binaryTarget(name: "FirebaseCoreInternal", path: "Binaries/FirebaseCoreInternal.xcframework"),
        .binaryTarget(name: "GoogleUtilities", path: "Binaries/GoogleUtilities.xcframework"),
        .binaryTarget(name: "SDWebImage", path: "Binaries/SDWebImage.xcframework"),
        .binaryTarget(name: "SwiftyGif", path: "Binaries/SwiftyGif.xcframework"),
        .binaryTarget(name: "audio_session", path: "Binaries/audio_session.xcframework"),
        .binaryTarget(name: "connectivity_plus", path: "Binaries/connectivity_plus.xcframework"),
        .binaryTarget(name: "file_picker", path: "Binaries/file_picker.xcframework"),
        .binaryTarget(name: "file_selector_ios", path: "Binaries/file_selector_ios.xcframework"),
        .binaryTarget(name: "firebase_core", path: "Binaries/firebase_core.xcframework"),
        .binaryTarget(name: "flutter_secure_storage", path: "Binaries/flutter_secure_storage.xcframework"),
        .binaryTarget(name: "get_thumbnail_video", path: "Binaries/get_thumbnail_video.xcframework"),
        .binaryTarget(name: "image_gallery_saver_plus", path: "Binaries/image_gallery_saver_plus.xcframework"),
        .binaryTarget(name: "image_picker_ios", path: "Binaries/image_picker_ios.xcframework"),
        .binaryTarget(name: "just_audio", path: "Binaries/just_audio.xcframework"),
        .binaryTarget(name: "libwebp", path: "Binaries/libwebp.xcframework"),
        .binaryTarget(name: "media_kit_video", path: "Binaries/media_kit_video.xcframework"),
        .binaryTarget(name: "package_info_plus", path: "Binaries/package_info_plus.xcframework"),
        .binaryTarget(name: "path_provider_foundation", path: "Binaries/path_provider_foundation.xcframework"),
        .binaryTarget(name: "photo_manager", path: "Binaries/photo_manager.xcframework"),
        .binaryTarget(name: "share_plus", path: "Binaries/share_plus.xcframework"),
        .binaryTarget(name: "sqflite_darwin", path: "Binaries/sqflite_darwin.xcframework"),
        .binaryTarget(name: "url_launcher_ios", path: "Binaries/url_launcher_ios.xcframework"),
        .binaryTarget(name: "video_player_avfoundation", path: "Binaries/video_player_avfoundation.xcframework"),
        .binaryTarget(name: "volume_controller", path: "Binaries/volume_controller.xcframework"),
        .binaryTarget(name: "wakelock_plus", path: "Binaries/wakelock_plus.xcframework")
    ]
)
