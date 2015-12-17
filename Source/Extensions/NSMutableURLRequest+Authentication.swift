import UIKit
import KeychainAccess

extension NSMutableURLRequest {
    func authenticate() {
        guard let authCookieName = Settings.sharedInstance.authCookieName else {
            return
        }

        let keychain = Settings.sharedInstance.keychain
        let authToken: String? = keychain["app_auth_cookie"] ?? authTokenFromCookie()
        
        if let token = authToken {
            let authCookie = "\(authCookieName)=\(token);"
            self.setValue(authCookie, forHTTPHeaderField: "Cookie")
        }
    }
    
    func authTokenFromCookie() -> String? {
        guard let authCookieName = Settings.sharedInstance.authCookieName else {
            return nil
        }

        let cookieStore = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let url = self.URL {
            let cookies = cookieStore.cookiesForURL(url)
            if let authCookies = cookies?.filter({$0.name == authCookieName}),
                authCookie = authCookies.first {
                    return authCookie.value
            }
        }
        return nil
    }
}