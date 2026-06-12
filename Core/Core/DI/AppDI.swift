//
//  AppDI.swift
//  Skeleton
//
//  Created by admin on 21/11/25.
//

import Swinject

class AppDI {
    static let shared = AppDI()
    private let container: Container

    private init() {
        container = Container()

        // Register Network Service
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService.shared
        }.inObjectScope(.container)

        container.register(NavigationService.self) { _ in
            NavigationService()
        }.inObjectScope(.container)

        // Register repositories (example)
//        container.register(LoginRepositoryProtocol.self) { resolver in
//            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
//            return LoginRepositoryProtocol(networkService: networkService)
//        }

        // Register Presenter
        container.register(LoginPresenter.self) { _ in
//            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
//            let navigationService = resolver.resolve(NavigationService.self)!
            LoginPresenter(
                //                networkService: networkService,
//                navigationService: navigationService
            )
        }
        container.register(RegisterPresenter.self) { _ in RegisterPresenter() }
        container.register(ForgotPasswordPresenter.self) { _ in ForgotPasswordPresenter() }
        container.register(ResetPasswordPresenter.self) { _ in ResetPasswordPresenter() }
    }

    func resolver<T>(_ type: T.Type) -> T { container.resolve(type)! }
}

// usage
// statis
// @Injected private var networkService: NetworkServiceProtocol
// dynamic
// @State private var presenter = AppDI.shared.container.resolve(LoginPresenter.self)!
