////
////  AuthScreens.swift
////  Heal_Sync
////
////  Created by iPHTech 30 on 21/09/26.

import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                        ZStack {
                            // Outer Glow Ring
                            Circle()
                                .fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.15))
                                .frame(width: 140, height: 140)
                                .blur(radius: 10)
                            
                            // Dark Background Circle with Gradient Border
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.22, blue: 0.20),
                                            Color(red: 0.04, green: 0.10, blue: 0.12)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 130, height: 130)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.30, green: 0.92, blue: 0.65),
                                                    Color.white.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                            
                            // App Symbol (Heart & Sync Indicator)
                            Image(systemName: "waveform.path.ecg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                        
                        Text(authViewModel.authMode == .login ? "Welcome Back" : "Start Your Journey")
                            .foregroundStyle(.white)
                            .font(.system(size: 28, weight: .bold))
                        
                        Text(authViewModel.authMode == .login ? "Sync your health data & stats" : "Create an account to track your activity")
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        
                       // Picker
                        Picker("Select View", selection: $authViewModel.authMode) {
                            ForEach(AuthMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 10)
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            
                            // Full Name Field (Sign Up Only)
                            if authViewModel.authMode == .signup {
                                CustomTextField(
                                    iconName: "person.fill",
                                    placeholder: "Full Name",
                                    text: $authViewModel.fullName
                                )
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Email Field
                            CustomTextField(
                                iconName: "envelope.fill",
                                placeholder: "Email Address",
                                text: $authViewModel.email
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            
                            // Password Field
                            CustomPasswordField(
                                placeholder: "Password",
                                password: $authViewModel.password,
                                isVisible: $authViewModel.isPasswordVisible
                            )
                            
                            // Forgot Password Link for Login
                            if authViewModel.authMode == .login {
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
                        
                        // Button
                        Button(action: {
                            authViewModel.handlePrimaryAction()
                        }) {
                            Text(authViewModel.authMode == .login ? "Log In" : "Create Account")
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
                .alert("Authentication Error", isPresented: $authViewModel.showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(authViewModel.alertMessage)
                }
            }
        }
    }
}

// Input Field component
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
        .environmentObject(AuthViewModel())
}
