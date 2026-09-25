//
//  ProfileScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ProfileScreenView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.02, blue: 0.1),
                    Color(red: 0.02, green: 0.15, blue: 0.17)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            VStack {
                HeaderView(title: "Profile", subTitle: "Manage Your Account")
                
                Spacer()
                
                // Connect the logout action directly to authViewModel with Debug Logs
                LogoutButton {
                    print("🔘 Log Out button tapped in UI")
                    print("🔒 Previous auth status: \(authViewModel.isAuthenticated)")
                    
                    authViewModel.logout()
                    
                    print("🔓 Updated auth status: \(authViewModel.isAuthenticated)")
                }
                .padding(.bottom, 100)
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { _, newValue in
            print("🔄 ProfileScreenView observed isAuthenticated change: \(newValue)")
        }
    }
}     
       
struct LogoutButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            print("👉 LogoutButton action closure executed")
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .bold))
                
                Text("Log Out")
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

#Preview {
    ProfileScreenView()
        .environmentObject(AuthViewModel())
}
