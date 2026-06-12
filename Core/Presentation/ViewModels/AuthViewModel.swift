import SwiftUI

/// BLoC equivalent for authentication.
/// Events become async methods, state becomes @Observable properties.
@Observable
@MainActor
final class AuthViewModel {

    // MARK: – State
    enum Status { case initial, loading, authenticated, unauthenticated, error }

    private(set) var status: Status = .initial
    private(set) var user: User?
    private(set) var errorMessage: String?

    var isAuthenticated: Bool { status == .authenticated && user != nil }
    var isLoading: Bool       { status == .loading }

    // MARK: – Use Cases (injected via protocols — never concrete types)
    private let signIn:         SignInUseCase
    private let register:       RegisterUseCase
    private let signOut:        SignOutUseCase
    private let getCurrentUser: GetCurrentUserUseCase

    init(
        signIn:         SignInUseCase,
        register:       RegisterUseCase,
        signOut:        SignOutUseCase,
        getCurrentUser: GetCurrentUserUseCase
    ) {
        self.signIn         = signIn
        self.register       = register
        self.signOut        = signOut
        self.getCurrentUser = getCurrentUser
    }

    // MARK: – Events

    /// Call at app launch to resolve auth state.
    func checkStatus() async {
        status = .loading
        do {
            let current = try await getCurrentUser()
            if let current {
                user   = current
                status = .authenticated
            } else {
                status = .unauthenticated
            }
        } catch {
            status = .unauthenticated
        }
    }

    /// Sign in with email and password.
    func performSignIn(email: String, password: String) async {
        status = .loading
        errorMessage = nil
        do {
            let result = try await signIn(email: email, password: password)
            user   = result
            status = .authenticated
            AppLogger.info("AuthViewModel: signed in \(result.email)", category: .auth)
        } catch let appError as AppError {
            errorMessage = appError.errorDescription
            status = .error
        } catch {
            errorMessage = AppStrings.errorGeneric
            status = .error
        }
    }

    /// Register a new account.
    func performRegister(fullName: String, email: String, password: String) async {
        status = .loading
        errorMessage = nil
        do {
            let result = try await register(fullName: fullName, email: email, password: password)
            user   = result
            status = .authenticated
        } catch let appError as AppError {
            errorMessage = appError.errorDescription
            status = .error
        } catch {
            errorMessage = AppStrings.errorGeneric
            status = .error
        }
    }

    /// Sign out and clear user state.
    func performSignOut() async {
        status = .loading
        try? await signOut()
        user   = nil
        status = .unauthenticated
        AppLogger.info("AuthViewModel: signed out", category: .auth)
    }
}
