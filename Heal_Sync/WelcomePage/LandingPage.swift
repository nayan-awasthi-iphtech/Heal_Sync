import SwiftUI

struct LandingPage: View {
    
    @State private var currentPage: Int = 0
    
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
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 35) {
                    
                    HStack(alignment: .center, spacing: 10) {
                        
                        HStack(spacing: 12) {
                            ZStack {
                                Image(systemName: LandingPageConstants.Images.heartFill)
                                    .resizable()
                                    .font(.title)
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                    .frame(width: 38, height: 34)
                                
                                Image(systemName: LandingPageConstants.Images.ecgWaveform)
                                    .resizable()
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .frame(width: 38, height: 18)
                            }
                            
                            Text(LandingPageConstants.appName)
                                .fontWeight(.bold)
                                .font(.system(size: 30, design: .default))
                                .foregroundStyle(Color.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: LandingPageConstants.Images.menuIcon)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(LandingPageConstants.priorityBadge)
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
                            Text(LandingPageConstants.trackYour)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Text(LandingPageConstants.health)
                                    .foregroundColor(.white)
                                
                                Text(LandingPageConstants.live)
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            }
                            
                            Text(LandingPageConstants.better)
                                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        }
                        .font(.system(size: 47, weight: .bold, design: .default))
                        
                        VStack(alignment: .leading, spacing: 30){
                            VStack(alignment: .leading, spacing: 4){
                                Text(LandingPageConstants.simpleTools)
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Text(LandingPageConstants.healthierYou)
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            
                            Button(action: {
                                // Action when button is tapped
                            }) {
                                HStack(spacing: 8) {
                                    Text(LandingPageConstants.getStarted)
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Image(systemName: LandingPageConstants.Images.arrowRight)
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
                            
                            HStack(alignment: .center, spacing: 20) {
                                // Left side: Runner image
                                Image(LandingPageConstants.Images.runningImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 220)
                                    .clipped()
                                    .offset(x: -12, y: 20)
                                
                                // Right side: Text content + Green Heart Icon
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // Header line: Green Heart Badge + "Track"
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(systemName: LandingPageConstants.Images.heartFill)
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                            .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.5), radius: 6)
                                        
                                        Text(LandingPageConstants.cardTrack)
                                            .font(.system(size: 25, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // "Daily Activity" on next line
                                    Text(LandingPageConstants.cardDailyActivity)
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    // Description
                                    Text(LandingPageConstants.cardDescription)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.white.opacity(0.75))
                                        .lineSpacing(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.top, 2)
                                }
                                .padding(.trailing, 26)
                            }
                            .frame(width: 380, height: 240)
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
                            .frame(maxWidth: .infinity)
                            
                            // Current Page Indicating dots
                            HStack(spacing: 8) {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(
                                            index == currentPage ? Color(red: 0.30, green: 0.92, blue: 0.65) : Color.white.opacity(0.25)
                                        )
                                        .frame(width: 10, height: 10)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 25)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    LandingPage()
}
