import Foundation

struct UserInfoKey {
    static let firebaseUID = "FirebaseUID"
    static let isFirstTime = "Onboarding"
    static let isLatestProfileData = "IsLatestProfileData"
    static let isLatestProfileImageData = "IsLatestProfileImageData"
    
    static let getUserDefaultsUID: String = {
        UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID)
    }() ?? ""
    
    static let getIsLatestProfileData: Bool = {
        UserDefaults.standard.bool(forKey: UserInfoKey.isLatestProfileData)
    }()
    
    static let getIsLatestProfileImageData: Bool = {
        UserDefaults.standard.bool(forKey: UserInfoKey.isLatestProfileImageData)
    }()
    
    static func setIsLatestProfileData(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: UserInfoKey.isLatestProfileData)
    }
    
    static func setIsLatestProfileImageData(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: UserInfoKey.isLatestProfileImageData)
    }
}
