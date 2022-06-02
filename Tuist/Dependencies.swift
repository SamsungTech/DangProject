import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .exact("8.14.0"))
    ],
    platforms: [.iOS]
)
