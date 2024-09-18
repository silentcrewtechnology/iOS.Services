import Foundation

public class AppStorageService {
    // TODO: - PCABO3-11586 Keychain
    public var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: "RefreshToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "RefreshToken") }
    }
    public var pin: String? {
        get { UserDefaults.standard.string(forKey: "Pin") }
        set { UserDefaults.standard.setValue(newValue, forKey: "Pin") }
    }
    public var userFirstName: String? {
        get { UserDefaults.standard.string(forKey: "UserFirstName") }
        set { UserDefaults.standard.setValue(newValue, forKey: "UserFirstName") }
    }
    public var userPictureURL: String? {
        get { UserDefaults.standard.string(forKey: "UserPictureURL") }
        set { UserDefaults.standard.setValue(newValue, forKey: "UserPictureURL") }
    }
    
    // TODO: - Store in memory / UserDefaults
    public var pushToken: String? {
        get { UserDefaults.standard.string(forKey: "PushToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "PushToken") }
    }
    public var deviceToken: String? {
        get { UserDefaults.standard.string(forKey: "DeviceToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "DeviceToken") }
    }
    public var bearerToken: String? {
        get { UserDefaults.standard.string(forKey: "BearerToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "BearerToken") }
    }
    public var sessionToken: String? {
        get { UserDefaults.standard.string(forKey: "SessionToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "SessionToken") }
    }
    
    public init() { }
    
    public func logout() {
        sessionToken = nil
        refreshToken = nil
        bearerToken = nil
        pushToken = nil
        pin = nil
        userFirstName = nil
        userPictureURL = nil
    }
}
