//
//  SectionTile.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Navigation row tile.
struct SectionTile: View {
    let icon: String
    let label: String
    var color: Color? = nil

    var body: some View {
        Label {
            Text(label)
                .font(.inter(16))
                .foregroundStyle(color ?? .primary)
        } icon: {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color ?? AppTheme.primaryBlue)
        }
    }
}
