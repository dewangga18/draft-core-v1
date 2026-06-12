import Foundation

/// Dependency injection container.
/// Each layer depends only on protocols. Swap any implementation here.
@MainActor
final class DIContainer {

    static let shared = DIContainer()

    // MARK: – External
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 15
        config.timeoutIntervalForResource = 15
        return URLSession(configuration: config)
    }()

    private let baseURL: URL = {
        let urlString = ProcessInfo.processInfo.environment["API_BASE_URL"]
            ?? "https://api.example.com/v1"
        return URL(string: urlString)!
    }()

    // MARK: – Data Sources (singletons behind protocols)
    lazy var secureStorage: SecureStorageRepository = KeychainDataSource()
    lazy var storage: StorageRepository             = UserDefaultsDataSource()

    lazy var authRemote: AuthRemoteDataSource =
        AuthRemoteDataSourceImpl(session: urlSession, baseURL: baseURL)

    // MARK: – Repositories
    lazy var authRepository: AuthRepository =
        AuthRepositoryImpl(remote: authRemote, secureStorage: secureStorage)

    // MARK: – Use Cases
    lazy var signInUseCase         = SignInUseCase(repository: authRepository)
    lazy var registerUseCase       = RegisterUseCase(repository: authRepository)
    lazy var signOutUseCase        = SignOutUseCase(repository: authRepository)
    lazy var getCurrentUserUseCase = GetCurrentUserUseCase(repository: authRepository)

    // MARK: – ViewModels
    lazy var authViewModel = AuthViewModel(
        signIn:         signInUseCase,
        register:       registerUseCase,
        signOut:        signOutUseCase,
        getCurrentUser: getCurrentUserUseCase
    )

    lazy var settingsViewModel = SettingsViewModel(storage: storage)

    // MARK: – Navigation
    lazy var navState = AppNavigationState.shared

    private init() {}
}
