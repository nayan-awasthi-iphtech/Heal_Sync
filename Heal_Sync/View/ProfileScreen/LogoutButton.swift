//
//  LogoutButton.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct LogoutButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .bold))

                Text(ProfileScreenConstants.logout)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal)
    }
}
