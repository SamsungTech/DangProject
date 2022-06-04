import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "9.1.0")),
        .remote(url: "https://github.com/google/gtm-session-fetcher.git", requirement: .exact("1.7.2"))
    ],
    platforms: [.iOS]
)
