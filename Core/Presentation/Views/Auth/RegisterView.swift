//
//  RegisterView.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Register screen.
struct RegisterView: View {

    @State private var fullName  = ""
    @State private var email     = ""
    @State private var password  = ""
    @State private var confirm   = ""

    @State private var fullNameError: String? = nil
    @State private var emailError:    String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmError:  String? = nil
    @State private var showPassword = false

    private var authVM            = DIContainer.shared.authViewModel
    private var navigationService = DIContainer.shared.navigationService

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppTheme.primaryBlue)
                        .frame(width: 72, height: 72)
                        .overlay {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    Text(AppStrings.createAccount)
                        .font(.inter(26, weight: .bold))
                    Text(AppStrings.appName)
                        .font(.inter(15))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 48)

                // Fields
                VStack(spacing: 16) {
                    AppTextField(
                        text: $fullName,
                        label: AppStrings.fullName,
                        systemImage: "person",
                        errorMessage: fullNameError
                    )
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
                    AppTextField(
                        text: $confirm,
                        label: AppStrings.confirmPassword,
                        systemImage: "lock.badge.checkmark",
                        isSecure: true,
                        errorMessage: confirmError
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
                    AppButton(title: AppStrings.register, isLoading: authVM.isLoading) {
                        guard validate() else { return }
                        Task { await authVM.performRegister(fullName: fullName, email: email, password: password) }
                    }

                    Button {
                        navigationService.popAuth()
                    } label: {
                        HStack(spacing: 4) {
                            Text(AppStrings.hasAccount)
                                .foregroundStyle(.secondary)
                            Text(AppStrings.signIn)
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
        fullNameError = Validators.required(fullName)
        emailError    = Validators.email(email)
        passwordError = Validators.password(password)
        confirmError  = Validators.confirmPassword(confirm, original: password)
        return fullNameError == nil && emailError == nil && passwordError == nil && confirmError == nil
    }
}
