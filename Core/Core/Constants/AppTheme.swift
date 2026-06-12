//
//  AppTheme.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Centralised design tokens.
enum AppTheme {

    // MARK: – Brand
    static let primaryBlue      = Color(hex: "007AFF")
    static let primaryBlueDark  = Color(hex: "0A84FF")
    static let accentIndigo     = Color(hex: "5856D6")
    static let successGreen     = Color(hex: "34C759")
    static let errorRed         = Color(hex: "FF3B30")
    static let warningOrange    = Color(hex: "FF9500")

    // MARK: – Light
    static let lightBackground        = Color(hex: "F2F2F7")
    static let lightSurface           = Color(hex: "FFFFFF")
    static let lightSurfaceSecondary  = Color(hex: "E5E5EA")
    static let lightTextPrimary       = Color(hex: "000000")
    static let lightTextSecondary     = Color(hex: "8E8E93")
    static let lightSeparator         = Color(hex: "C6C6C8")

    // MARK: – Dark
    static let darkBackground        = Color(hex: "000000")
    static let darkSurface           = Color(hex: "1C1C1E")
    static let darkSurfaceSecondary  = Color(hex: "2C2C2E")
    static let darkTextPrimary       = Color(hex: "FFFFFF")
    static let darkTextSecondary     = Color(hex: "8E8E93")
    static let darkSeparator         = Color(hex: "38383A")
}

// MARK: – Color from hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >>  8) & 0xFF) / 255
        let b = Double( int        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: – Font helpers (Inter via custom font or system)
extension Font {
    static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Inter", size: size).weight(weight)
    }
}
