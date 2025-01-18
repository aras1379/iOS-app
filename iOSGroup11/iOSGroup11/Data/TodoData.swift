//
//  TodoData.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-04.
//

import Foundation
import SwiftData
import SwiftUI
import WidgetKit
import AppIntents

@Model
final class TodoTask: Identifiable{
    @Attribute(.unique) let id = UUID().uuidString
    var title: String
    var isDone: Bool = false
    var isPrio: Bool
    var date: Date?
    weak var category: Category2? 
    
    init(title: String, isDone: Bool = false, isPrio: Bool, date: Date? = nil, category: Category2? = nil) {
        self.title = title
        self.isDone = isDone
        self.isPrio = isPrio
        self.date = date
        self.category = category
    }
    
    var timeFrame: TimeFrame {
        if let date = date {
            let now = Date()
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: now) //midnight current day
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)! // midnight upcoming day
            
            if date > endOfDay {
                return .Upcoming
                //https://developer.apple.com/documentation/foundation/calendar/2293243-isdateintoday
            } else if calendar.isDateInToday(date) {
                return .Today
            } else {
                return .Whenever
            }
        } else {
            return .Whenever
        }
    }
}
    
enum TimeFrame: String, CaseIterable, Identifiable {
    case Today, Upcoming, Whenever
    var id: Self { self }
}
