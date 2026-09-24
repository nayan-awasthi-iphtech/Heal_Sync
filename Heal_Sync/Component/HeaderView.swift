//
//  HeaderView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct HeaderView: View {
    
    var title: String = ""
    var subTitle: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
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

