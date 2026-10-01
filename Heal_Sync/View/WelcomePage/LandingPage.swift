import SwiftUI

struct LandingPage: View {

    @EnvironmentObject var theme: ThemeManager
    @State private var currentPage: Int = 0
    @State private var navigateToWelcome: Bool = false

    var body: some View {

        NavigationStack{
            ZStack {

                // Base Background
                ThemedBackground()

                // Wave Background Lines
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

                // Screen Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack (alignment: .leading, spacing: 35) {

                        HeaderView()
                            .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 15) {
                            Text(LandingScreenConstants.priorityBadge)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Color(red: 0.30, green: 0.85, blue: 0.65))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(theme.colors.cardBackground)
                                        .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(theme.isDarkMode ? Color(red: 0.20, green: 0.45, blue: 0.38).opacity(0.5) : Color.black.opacity(0.08), lineWidth: 1)
                                )

                            VStack(alignment: .leading, spacing: -10) {
                                Text(LandingScreenConstants.trackYour)
                                    .foregroundColor(theme.colors.primaryText)
                                HStack(spacing: 8) {
                                    Text(LandingScreenConstants.health)
                                        .foregroundColor(theme.colors.primaryText)

                                    Text(LandingScreenConstants.live)
                                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                                }
                                Text(LandingScreenConstants.better)
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            }
                            .font(.system(size: 47, weight: .bold, design: .default))
                            .minimumScaleFactor(0.65)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)

                            VStack(alignment: .leading, spacing: 30){
                                VStack(alignment: .leading, spacing: 4){
                                    Text(LandingScreenConstants.simpleTools)
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundStyle(theme.colors.primaryText)

                                    Text(LandingScreenConstants.healthierYou)
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundStyle(theme.colors.primaryText)
                                }

                                Button(action:{
                                    navigateToWelcome = true
                                })
                                {
                                    HStack(spacing: 8) {
                                        Text(LandingScreenConstants.getStarted)
                                            .font(.system(size: 18, weight: .bold))

                                        Image(systemName: LandingScreenConstants.Images.arrowRight)
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
                                LandingBottomCardSlider()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $navigateToWelcome) {
                WelcomePage()
            }
        }
    }
}

#Preview {
    LandingPage()
        .environmentObject(ThemeManager())
}
