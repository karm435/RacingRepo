//
//  File.swift
//  
//
//  Created by karmjit singh on 3/7/2023.
//

import Foundation

public enum RaceCategory: String, Identifiable, Hashable, CaseIterable {
  public var id: Self { self }
  case greyhoundRacing = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
  case harnessRacing = "161d9be2-e909-4326-8c2c-35ed71fb460b"
  case horseRacing = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
  
//  public var categoryId: UUID {
//      return UUID(uuidString: self.rawValue)!
//  }
  
  public var iconName: String {
    switch self {
    case .greyhoundRacing:
      return "greyhound"
    case .harnessRacing:
      return "harness"
    case .horseRacing:
      return "horse-racing"
    }
  }
  
  public var name: String {
    switch self {
    case .greyhoundRacing:
      return "Greyhound"
    case .harnessRacing:
      return "Harness"
    case .horseRacing:
      return "Horse"
    }
  }
}
