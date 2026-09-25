//
//  PickerView.swift
//  Heal_Sync
//

import SwiftUI

/// Theme-matched segmented picker (Day / Week / Month) used by
/// Activity, Insights and Profile screens.
struct PickerView: View {

    @Binding var selection: String
    let options: [String]

    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    var body: some View {
        HStack(spacing: 6) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = option
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 15, weight: isSelected ? .bold : .semibold))
                        .foregroundColor(isSelected ? .black : .white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(isSelected ? mintGreen : Color.white.opacity(0.08))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            Capsule()
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    PickerView(selection: .constant("Day"), options: ["Day", "Week", "Month"])
        .background(Color.black)
}
