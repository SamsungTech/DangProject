import ProjectDescription
import Security

let projectName: String = "DangProject"

let target = Target(name: projectName,
                    platform: .iOS,
                    product: .app,
                    bundleId: "com.\(projectName)",
                    deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone]),
                    infoPlist:  "\(projectName)/Supporting/Info.plist",
                    sources: "\(projectName)/Sources/**",
                    resources: "\(projectName)/Resources/**",
                    dependencies: [
                        .external(name: "RxSwift"),
                        .external(name: "RxCocoa"),
                        .external(name: "RxRelay"),
                        .external(name: "FirebaseAuth"),
                        .external(name: "FirebaseFirestore")
                    ]
)
let project = Project(
    name: projectName,
    organizationName: nil,
    settings: nil,
    targets: [target],
    schemes: []
)
