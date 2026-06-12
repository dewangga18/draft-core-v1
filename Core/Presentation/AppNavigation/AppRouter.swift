//
//  AppRouter.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI
import OwlNav

/// Manages auth-gated navigation routes.
public enum AppRoute: Hashable, Equatable {
    case home
    case profile
    case settings
    case login
    case register
}

/// Root view that listens to AuthViewModel and switches between auth / main flows.
public struct AppRootView: View {
    @State private var authVM = DIContainer.shared.authViewModel
    @State private var settingsVM = DIContainer.shared.settingsViewModel

    public init() {}

    public var body: some View {
        Group {
            switch authVM.status {
            case .initial, .loading:
                SplashView()

            case .authenticated:
                MainNavigationView()

            case .unauthenticated, .error:
                AuthFlowView()
            }
        }
        .preferredColorScheme(settingsVM.preferredColorScheme)
        .task { await authVM.checkStatus() }
    }
}

/// Main navigation host using OwlNav.
struct MainNavigationView: View {
    private var navigationService = NavigationService.shared

    var body: some View {
        OwlContainer(navigationService.mainOwl) { route in
            Group {
                switch route {
                case .home:
                    HomeView()
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                default:
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .withSwipeBack {
                // Handle system interactive pop gesture tracking if needed
            }
        }
    }
}

/// Auth navigation host using OwlNav.
struct AuthFlowView: View {
    private var navigationService = NavigationService.shared

    var body: some View {
        OwlContainer(navigationService.authOwl) { route in
            Group {
                switch route {
                case .login:
                    LoginView()
                case .register:
                    RegisterView()
                default:
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .withSwipeBack {
                // Handle system interactive pop gesture tracking if needed
            }
        }
    }
}
