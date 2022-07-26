import Foundation

struct UserInfoKey {
    static let firebaseUID = "FirebaseUID"
    static let isFirstTime = "Onboarding"
    static let isLatestProfileData = "IsLatestProfileData"
    static let getUserDefaultsUID: String = {
        UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID)
    }() ?? ""
    static let getIsLatestProfileData: Bool = {
        UserDefaults.standard.bool(forKey: UserInfoKey.isLatestProfileData)
    }()
    
    static func setIsLatestProfileData(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: UserInfoKey.isLatestProfileData)
    }
}
