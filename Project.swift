import ProjectDescription
import Security

let projectName: String = "DangProject"

let target = Target(name: projectName,
                    platform: .iOS,
                    product: .app,
                    bundleId: "com.\(projectName)",
                    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
                    infoPlist:  "\(projectName)/Supporting/Info.plist",
                    sources: "\(projectName)/Sources/**",
                    resources: "\(projectName)/Resources/**",
                    dependencies: [
                        .package(product: "RxSwift"),
                        .package(product: "RxCocoa"),
                        .package(product: "RxRelay"),
                        .package(product: "FirebaseAuth"),
                        .package(product: "FirebaseFirestore"),
                        .package(product: "FirebaseStorage"),
                        .package(product: "GTMSessionFetcherFull")
                    ],
                    coreDataModels: [
                        .init(.relativeToCurrentFile("\(projectName)/Sources/Application/CoreDataClasses/DangProject.xcdatamodeld/"))
                    ]
)
let project = Project(name: projectName,
                       organizationName: nil,
                       packages: [
                        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
                        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "9.1.0")),
                        .remote(url: "https://github.com/google/gtm-session-fetcher.git", requirement: .exact("1.7.2"))
                       ],
                       settings: nil,
                       targets: [target],
                       schemes: []
)
