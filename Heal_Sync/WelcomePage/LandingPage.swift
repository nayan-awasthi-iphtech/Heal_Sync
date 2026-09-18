import SwiftUI

struct LandingPage: View {
    
    var body: some View {
        ZStack {
            
            // MARK: - Base Background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.02, blue: 0.06),
                    Color(red: 0.06, green: 0.20, blue: 0.19)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            // MARK: - Wave Background Lines
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                ZStack {
                    ForEach(0..<18, id: \.self) { i in
                        let offset = CGFloat(i) * 6.0
                        
                        Path { path in
                            path.move(to: CGPoint(x: width + 80, y: height * 0.35 + offset))
                            
                            path.addCurve(
                                to: CGPoint(x: width * 0.40 - (CGFloat(i) * 2), y: height * 0.58 + (offset * 0.5)),
                                control1: CGPoint(x: width * 0.70, y: height * 0.28 + offset),
                                control2: CGPoint(x: width * 0.50, y: height * 0.48 + offset)
                            )
                        }
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.30, green: 0.85, blue: 0.65).opacity(0.35 - Double(i) * 0.015),
                                    Color(red: 0.15, green: 0.45, blue: 0.35).opacity(0.05)
                                ],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                    }
                }
            }
            .ignoresSafeArea()
            
            // MARK: - Screen Content
            VStack (alignment: .leading, spacing: 35) {
                
                HStack(alignment: .center, spacing: 10) {
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .font(.title)
                                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                .frame(width: 38, height: 34)
                            
                            Image(systemName: "waveform.path.ecg")
                                .resizable()
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(width: 38, height: 18)
                        }
                        
                        Text("HealSync")
                            .fontWeight(.bold)
                            .font(.system(size: 30, design: .default))
                            .foregroundStyle(Color.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your Health, Our Priority")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 0.30, green: 0.85, blue: 0.65))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.08, green: 0.22, blue: 0.20).opacity(0.6))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 0.20, green: 0.45, blue: 0.38).opacity(0.5), lineWidth: 1)
                        )
                    
                    
                    VStack(alignment: .leading, spacing: -10) {
                        Text("Track Your")
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Text("Health,")
                                .foregroundColor(.white)
                            
                            Text("Live")
                                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        }
                        
                        Text("Better")
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                    }
                    .font(.system(size: 47, weight: .bold, design: .default))
                    
                    VStack(alignment: .leading, spacing: 30){
                        VStack(alignment: .leading,spacing: 4){
                            Text("Simple tools. Smarter insights.")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.white)
                            
                            Text("A healthier you.")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        
                        Button(action: {
                            // Action when button is tapped
                        }) {
                            HStack(spacing: 8) {
                                Text("Get Started")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                            )
                        }
                        
                        HStack(alignment: .center, spacing: 12) {
                            // Left side: Runner image pushed slightly left
                            Image("Runner")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 170, height: 180)
                                .offset(x: -8)
                            
                            // Right side: Text content + Green Heart Icon
                            VStack(alignment: .leading, spacing: 10) {
                                
                                // Green Heart Badge
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                    .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.5), radius: 6)
                                
                                // Title
                                Text("Track\nDaily Activity")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineSpacing(2)
                                
                                // Description
                                Text("Steps, calories, sleep and more — all in one place.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color.white.opacity(0.7))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.10, green: 0.28, blue: 0.25),
                                            Color(red: 0.04, green: 0.12, blue: 0.14)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    LandingPage()
}
