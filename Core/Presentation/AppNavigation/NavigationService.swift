//
//  NavigationService.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI
import Observation
import OwlNav

@MainActor
@Observable
public final class NavigationService {
    public static let shared = NavigationService()
    
    // Independent navigation stacks for main app flow and auth flow
    public let mainOwl = InOwl<AppRoute>(initial: .home)
    public let authOwl = InOwl<AppRoute>(initial: .login)
    
    private init() {}
    
    // Helper helpers to keep views clean
    public func navigateMain(to route: AppRoute) {
        mainOwl.push(route)
    }
    
    public func popMain() {
        mainOwl.pop()
    }
    
    public func navigateAuth(to route: AppRoute) {
        authOwl.push(route)
    }
    
    public func popAuth() {
        authOwl.pop()
    }
}
