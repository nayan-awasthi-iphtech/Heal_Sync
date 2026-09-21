////
////  AuthScreens.swift
////  Heal_Sync
////
////  Created by iPHTech 30 on 21/09/26.

import SwiftUI

enum AuthMode: String, CaseIterable {
    case login = "Log In"
    case signup = "Sign Up"
}

struct AuthView: View {
    
    @State private var authmode: AuthMode = .login
    
    // Form Input States
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    init() {
        UISegmentedControl.appearance().backgroundColor = UIColor(red: 0.08, green: 0.22, blue: 0.20, alpha: 0.6)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 0.30, green: 0.92, blue: 0.65, alpha: 1.0)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.7), .font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.02, blue: 0.06),
                        Color(red: 0.06, green: 0.20, blue: 0.19)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        Image("ImageLogin")
                            .resizable()
                            .frame(width: 360, height: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .brightness(0.1)
                        
                        Text(authmode == .login ? "Welcome Back" : "Start Your Journey")
                            .foregroundStyle(.white)
                            .font(.system(size: 28, weight: .bold))
                        
                        Text(authmode == .login ? "Sync your health data & stats" : "Create an account to track your activity")
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .fontWeight(.semibold)
                            .font(.system(size: 15)) // Adjusted to fit nicely without clipping
                        
                        // Fixed Picker: Bound directly to $authmode
                        Picker("Select View", selection: $authmode) {
                            ForEach(AuthMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 10)
                        
                        // MARK: - Form Fields
                        VStack(spacing: 16) {
                            
                            // Full Name Field (Sign Up Only)
                            if authmode == .signup {
                                CustomTextField(
                                    iconName: "person.fill",
                                    placeholder: "Full Name",
                                    text: $fullName
                                )
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Email Field (Both)
                            CustomTextField(
                                iconName: "envelope.fill",
                                placeholder: "Email Address",
                                text: $email
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            
                            // Password Field (Both)
                            CustomPasswordField(
                                placeholder: "Password",
                                password: $password,
                                isVisible: $isPasswordVisible
                            )
                            
                            // Forgot Password Link (Login Only)
                            if authmode == .login {
                                HStack {
                                    Spacer()
                                    Button("Forgot Password?") {
                                        // Forgot password action
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        // MARK: - Action Button
                        Button(action: {
                            // Action for Login or Sign Up
                        }) {
                            Text(authmode == .login ? "Log In" : "Create Account")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                                )
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Custom Reusable Input Fields
struct CustomTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                .frame(width: 24)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.4)))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

struct CustomPasswordField: View {
    let placeholder: String
    @Binding var password: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                .frame(width: 24)
            
            if isVisible {
                TextField("", text: $password, prompt: Text(placeholder).foregroundColor(.white.opacity(0.4)))
                    .foregroundColor(.white)
            } else {
                SecureField("", text: $password, prompt: Text(placeholder).foregroundColor(.white.opacity(0.4)))
                    .foregroundColor(.white)
            }
            
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    AuthView()
}
