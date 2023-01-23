//
//  PresentationVersionModel.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/23.
//

import Foundation

struct PresentationVersionModel {
    static let empty: Self = .init(version: "", state: "")
    var version: String
    var state: VersionState
    
    enum VersionState {
        case red
        case yellow
        case green
    }
    
    init(version: String, state: String) {
        self.version = version
        self.state = PresentationVersionModel.convert(state: state)
    }
    
    static func convert(state: String) -> VersionState {
        switch state {
        case "red":
            return .red
        case "yellow":
            return .yellow
        case "green":
            return .green
        default:
            return .green
        }
    }
}
