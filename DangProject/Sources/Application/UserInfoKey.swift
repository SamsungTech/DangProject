import Foundation

struct UserInfoKey {
    static let firebaseUID = "FirebaseUID"
    static let tutorialFinished = "TutorialFinished"
    static let userNotificationsPermission = "UserNotificationsPermission"
    static let initialAlarmDataIsNeeded = "InitialAlarmDataIsNeeded"
    static let demoUID = "DemoVersionUID"
    static let isYellowState = "isYellowState"
    static let previousYellowVersion = "previousYellowVersion"
    static let latestYellowVersion = "latestYellowVersion"
    static let latestVersion = "LatestVersion"
    
    static let getUserDefaultsUID: String = {
        UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID)
    }() ?? ""
    
    static func removeAllUserDefaultsDatas() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.firebaseUID)
        UserDefaults.standard.removeObject(forKey: UserInfoKey.tutorialFinished)
        UserDefaults.standard.removeObject(forKey: UserInfoKey.userNotificationsPermission)
        UserDefaults.standard.removeObject(forKey: UserInfoKey.initialAlarmDataIsNeeded)
    }
}
