//
//  File 2.swift
//  
//
//  Created by karmjit singh on 3/7/2023.
//

import Foundation

public struct AdvertisedStart: Codable {
  public let seconds: Int
}

extension AdvertisedStart: Comparable {
  public static func < (lhs: AdvertisedStart, rhs: AdvertisedStart) -> Bool {
    lhs.toDate() < rhs.toDate()
  }
}

extension AdvertisedStart {
  
  public var isOneMinutePassedStartTime: Bool {
    let date = Date(timeIntervalSince1970: TimeInterval(self.seconds))
    return  date.addingTimeInterval(60) < .now
  }
  
  public var since: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: toDate(), relativeTo: .now)
  }
  
  public func toDate() -> Date {
    // Convert timestamp to utc date
    let date = Date(timeIntervalSince1970: TimeInterval(self.seconds))
    return date
  }
}
