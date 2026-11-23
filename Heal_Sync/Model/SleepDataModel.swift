//
//  SleepDataModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

enum SleepFilterPeriod: String, CaseIterable, Identifiable {
    case tonight = "TONIGHT"
    case weekly = "THIS WEEK"
    case monthly = "THIS MONTH"

    var id: String {self.rawValue}
}

struct SleepDataModel {
    var filterPeriod: SleepFilterPeriod
    var score: Int
    var sleepDuration: String
    var insights: [String]
}
