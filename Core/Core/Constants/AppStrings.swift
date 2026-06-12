/// All localizable strings in one place.
enum AppStrings {

    // MARK: – App
    static let appName    = "Core Template"
    static let appVersion = "1.0.0"

    // MARK: – Auth
    static let login           = "Sign In"
    static let register        = "Create Account"
    static let logout          = "Sign Out"
    static let email           = "Email"
    static let password        = "Password"
    static let confirmPassword = "Confirm Password"
    static let fullName        = "Full Name"
    static let forgotPassword  = "Forgot Password?"
    static let noAccount       = "Don't have an account? "
    static let hasAccount      = "Already have an account? "
    static let signUp          = "Sign Up"
    static let signIn          = "Sign In"
    static let welcomeBack     = "Welcome Back"
    static let createAccount   = "Create Account"

    // MARK: – Validation
    static let fieldRequired        = "This field is required"
    static let invalidEmail         = "Enter a valid email address"
    static let passwordTooShort     = "Password must be at least 8 characters"
    static let passwordsDoNotMatch  = "Passwords do not match"

    // MARK: – Navigation
    static let home     = "Home"
    static let profile  = "Profile"
    static let settings = "Settings"

    // MARK: – Settings
    static let appearance    = "Appearance"
    static let themeLight    = "Light"
    static let themeDark     = "Dark"
    static let themeSystem   = "System"
    static let notifications = "Notifications"
    static let security      = "Security"
    static let about         = "About"
    static let version       = "Version"

    // MARK: – Errors
    static let errorGeneric      = "Something went wrong. Please try again."
    static let errorNetwork      = "No internet connection."
    static let errorUnauthorized = "Session expired. Please sign in again."
    static let errorNotFound     = "Resource not found."
    static let errorServerError  = "Server error. Please try later."

    // MARK: – Storage keys (Keychain + UserDefaults)
    enum Keys {
        static let accessToken        = "access_token"
        static let refreshToken       = "refresh_token"
        static let userId             = "user_id"
        static let themeMode          = "theme_mode"
        static let onboardingDone     = "onboarding_done"
        static let userProfile        = "user_profile"
        static let pushNotifications  = "push_notifications"
    }
}
