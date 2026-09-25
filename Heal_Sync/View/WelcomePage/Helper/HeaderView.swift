//
//  HeaderView.swift
//  Heal_Sync
//

import SwiftUI

/// Shared app header with two modes (same theme):
/// - Brand mode `HeaderView()` — logo + menu icon (Landing / Welcome pages).
/// - Screen mode `HeaderView(title:subTitle:)` — screen title + subtitle
///   (Activity / Insights / Profile).
struct HeaderView: View {

    var title: String = ""
    var subTitle: String = ""

    var body: some View {
        if title.isEmpty {
            brandHeader
        } else {
            screenHeader
        }
    }

    // MARK: - Brand header (Landing / Welcome)

    private var brandHeader: some View {
        HStack(alignment: .center, spacing: 10) {

            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: WelcomeScreenConstants.Images.heartFill)
                        .resizable()
                        .font(.title)
                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        .frame(width: 38, height: 34)

                    Image(systemName: WelcomeScreenConstants.Images.ecgWaveform)
                        .resizable()
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: 38, height: 18)
                }

                Text(WelcomeScreenConstants.appName)
                    .fontWeight(.bold)
                    .font(.system(size: 30, design: .default))
                    .foregroundStyle(Color.white)
            }

            Spacer()

            Image(systemName: WelcomeScreenConstants.Images.menuIcon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Screen header (Activity / Insights / Profile)

    private var screenHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 35, weight: .bold))
                .foregroundStyle(.white)

            Text(subTitle)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    VStack(spacing: 20) {
        HeaderView()
        HeaderView(title: "Profile", subTitle: "Manage Your Account")
    }
    .background(Color.black)
}
