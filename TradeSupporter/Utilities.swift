//
//  Utilities.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation

class Utilities {
    static func sortIntervales(_ intervals: [String]) -> [String:[String]] {
        var minutes: [String] = []
        var hours: [String] = []
        var days: [String] = []
        var weeks: [String] = []
        
        var minutesInt: [Int] = []
        var hoursInt: [Int] = []
        var daysInt: [Int] = []
        var weeksInt: [Int] = []
        
        for interval in intervals {
            var tmp: String = ""
            if interval.contains("m") {
                tmp = interval.replacingOccurrences(of: "m", with: "")
                minutesInt.append(Int(tmp)!)
                //minutes.append(interval)
            } else if interval.contains("h") {
                tmp = interval.replacingOccurrences(of: "h", with: "")
                hoursInt.append(Int(tmp)!)
                //hours.append(interval)
            } else if interval.contains("d") {
                tmp = interval.replacingOccurrences(of: "d", with: "")
                daysInt.append(Int(tmp)!)
                //days.append(interval)
            } else if interval.contains("w") {
                tmp = interval.replacingOccurrences(of: "w", with: "")
                weeksInt.append(Int(tmp)!)
                //weeks.append(interval)
            }
        }
        
        minutesInt.sort { $0 < $1 }
        hoursInt.sort { $0 < $1 }
        daysInt.sort { $0 < $1 }
        weeksInt.sort{ $0 < $1 }
        for minute in minutesInt {
            minutes.append(String(minute) + "m")
        }
        
        for hour in hoursInt {
            hours.append(String(hour) + "h")
        }
        
        for day in daysInt {
            days.append(String(day) + "d")
        }
        
        for week in weeksInt {
            weeks.append(String(week) + "w")
        }
        
        
        return [
            "minutes": minutes,
            "hours": hours,
            "days": days,
            "weeks": weeks
        ]
    }
}
