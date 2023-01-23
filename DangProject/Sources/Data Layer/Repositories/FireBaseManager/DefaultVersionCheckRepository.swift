//
//  DefaultVersionCheckRepository.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/23.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics
import Firebase

// MARK: Red - 앱 진입 할 때마다 띄움
// MARK: Yellow - 앱 최초 진입 한번만 띄움
// MARK: Green - 최신 버전이 아니여도 띄우지 않음

struct VersionData {
    static let empty: Self = .init(version: "", state: "")
    var version: String
    var state: String
}

class DefaultVersionCheckRepository: VersionCheckRepository {
    private let database = Firestore.firestore()
    
    public func isUpdateAvailable(completion: @escaping (VersionData, Error?) -> Void) {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String else {
            print(VersionError.invalidBundleInfo)
            return
        }
        
        getAppVersion { (versionData, bool) in
            if bool {
                if currentVersion == versionData.version {
                    var data: VersionData = versionData
                    data.state = "green"
                    completion(data, nil)
                } else {
                    UserDefaults.standard.set(versionData.version, forKey: UserInfoKey.latestVersion)
                    self.checkLatestVersion(versionData: versionData)
                    completion(versionData, nil)
                }
            } else {
                completion(versionData, VersionError.invalidResponse)
            }
        }
    }
    
    private func checkLatestVersion(versionData: VersionData) {
        let previousYellowVersion = UserDefaults.standard.string(forKey: UserInfoKey.previousYellowVersion)
        
        if versionData.state == "yellow" {
            if previousYellowVersion == nil {
                UserDefaults.standard.set(true, forKey: UserInfoKey.isYellowState)
                UserDefaults.standard.set(versionData.version, forKey: UserInfoKey.previousYellowVersion)
            }
            
            if versionData.version != previousYellowVersion {
                checkLatestYellowVersion(version: versionData.version)
            }
        }
    }
    
    private func checkLatestYellowVersion(version: String) {
        
        let latestYellowVersion = UserDefaults.standard.string(forKey: UserInfoKey.latestYellowVersion)
        
        if latestYellowVersion == nil {
            UserDefaults.standard.set(true, forKey: UserInfoKey.isYellowState)
            UserDefaults.standard.set(version, forKey: UserInfoKey.latestYellowVersion)
        }
        
        if version != latestYellowVersion {
            UserDefaults.standard.set(true, forKey: UserInfoKey.isYellowState)
            UserDefaults.standard.set(version, forKey: UserInfoKey.latestYellowVersion)
        }
        
    }

    private func getAppVersionData(completion: @escaping ((VersionData, Bool) -> Void)) {
        database.collection("version")
            .document("appVersion")
            .getDocument() { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(VersionData.empty, false)
                    return
                }
                if let result = snapshot?.data() {
                    var data: VersionData = .init(version: "", state: "")
                    for (key, value) in result {
                        guard let value = value as? String else { return }
                        switch key {
                        case "version": data.version = value
                        case "state": data.state = value
                        default: break
                        }
                    }
                    completion(data, true)
                }
            }
    }
    
    enum VersionError: Error {
      case invalidResponse, invalidBundleInfo
    }
    
    private func getAppVersion(completion: @escaping(VersionData, Bool)->Void) {
        getAppVersionData { version, bool in
            if bool {
                completion(version, true)
            } else {
                print(VersionError.invalidResponse)
                completion(VersionData.empty, false)
            }
        }
    }
}
