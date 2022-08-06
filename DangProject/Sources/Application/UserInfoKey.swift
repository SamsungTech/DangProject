import Foundation

struct UserInfoKey {
    static let firebaseUID = "FirebaseUID"
    static let isFirstTime = "Onboarding"
    
    static let getUserDefaultsUID: String = {
        UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID)
    }() ?? ""
    static let userNotificationsPermission = "UserNotificationsPermission"
    static let initialAlarmDataIsNeeded = "InitialAlarmDataIsNeeded"
}
