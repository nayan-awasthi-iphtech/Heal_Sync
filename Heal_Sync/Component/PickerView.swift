//
//  PickerView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct PickerView: View {
    
    @Binding var selection: String
    let options: [String]
    
    init(selection: Binding<String>, options: [String]){
        self._selection = selection
        self.options = options

        let appearance = UISegmentedControl.appearance()
        appearance.backgroundColor = UIColor(red: 0.07, green: 0.14, blue: 0.16, alpha: 1.0)
        appearance.selectedSegmentTintColor = UIColor(red: 0.20, green: 0.69, blue: 0.67, alpha: 1.0)
        
        appearance.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .normal)
        
        appearance.setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .selected)
    }
    
    var body: some View {
        Picker("Selection", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .scaleEffect(y: 1.5)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}


