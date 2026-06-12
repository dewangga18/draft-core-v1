//
//  LoginView.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Login screen.
struct LoginView: View {

    @State private var email    = ""
    @State private var password = ""

    @State private var emailError:    String? = nil
    @State private var passwordError: String? = nil
    @State private var showPassword = false

    private var authVM             = DIContainer.shared.authViewModel
    private var navigationService  = DIContainer.shared.navigationService

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppTheme.primaryBlue)
                        .frame(width: 72, height: 72)
                        .overlay {
                            Image(systemName: "square.3.layers.3d")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    Text(AppStrings.welcomeBack)
                        .font(.inter(26, weight: .bold))
                    Text(AppStrings.appName)
                        .font(.inter(15))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 48)

                // Fields
                VStack(spacing: 16) {
                    AppTextField(
                        text: $email,
                        label: AppStrings.email,
                        systemImage: "envelope",
                        keyboardType: .emailAddress,
                        errorMessage: emailError
                    )
                    AppTextField(
                        text: $password,
                        label: AppStrings.password,
                        systemImage: "lock",
                        isSecure: !showPassword,
                        trailingIcon: showPassword ? "eye.slash" : "eye",
                        onTrailingTap: { showPassword.toggle() },
                        errorMessage: passwordError
                    )
                }

                // Error banner
                if let error = authVM.errorMessage {
                    Text(error)
                        .font(.inter(14))
                        .foregroundStyle(AppTheme.errorRed)
                        .multilineTextAlignment(.center)
                }

                // Actions
                VStack(spacing: 12) {
                    AppButton(title: AppStrings.signIn, isLoading: authVM.isLoading) {
                        guard validate() else { return }
                        Task { await authVM.performSignIn(email: email, password: password) }
                    }

                    Button {
                        navigationService.navigateAuth(to: .register)
                    } label: {
                        HStack(spacing: 4) {
                            Text(AppStrings.noAccount)
                                .foregroundStyle(.secondary)
                            Text(AppStrings.signUp)
                                .foregroundStyle(AppTheme.primaryBlue)
                        }
                        .font(.inter(15))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }

    private func validate() -> Bool {
        emailError    = Validators.email(email)
        passwordError = Validators.password(password)
        return emailError == nil && passwordError == nil
    }
}
