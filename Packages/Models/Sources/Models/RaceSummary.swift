
import Foundation

public enum DecodingError: Error {
  case failure(forKey: String)
}

//public struct RaceSummaries {
//  public struct RaceSummary {
//    let raceId: UUID
//    let raceName: String
//
//    init(raceId: String, raceName: String) throws {
//      if let raceId = UUID(uuidString: raceId) {
//        self.raceId = raceId
//      } else {
//        throw DecodingError.failure(forKey: "RaceSummary.raceId")
//      }
//      self.raceName = raceName
//    }
//  }
//
//  let nextRaces: [RaceSummary]
//
//  public init(nextRaces: [RaceSummary]) {
//    self.nextRaces = nextRaces
//  }
//}
//
//extension RaceSummaries: Decodable {
//
//  struct RaceSummariesKey: CodingKey {
//    var intValue: Int?
//    init?(intValue: Int) { return nil }
//
//    var stringValue: String
//    init?(stringValue: String) {
//      self.stringValue = stringValue
//    }
//
//    static let raceId = RaceSummariesKey(stringValue: "race_id")!
//    static let raceName = RaceSummariesKey(stringValue: "race_name")!
//  }
//
//  public init(from decoder: Decoder) throws {
//    var races = [RaceSummary]()
//
//
//    let container = try decoder.container(keyedBy: RaceSummariesKey.self)
//    print("container \(container.allKeys)")
//    for key in container.allKeys {
//      let raceSummaryContainer = try container.nestedContainer(keyedBy: RaceSummariesKey.self, forKey: key)
//
//      let raceId = try raceSummaryContainer.decode(String.self, forKey: .raceId)
//      let raceName = try raceSummaryContainer.decode(String.self, forKey: .raceName)
//
//      let raceSummay = try  RaceSummary(raceId: raceId, raceName: raceName)
//      races.append(raceSummay)
//    }
//
//    self.init(nextRaces: races)
//  }
//}


public struct GetRacesResponse: Decodable {
  public let status: Int
  public let data: RaceSummeriesResponse
}

public struct RaceSummeriesResponse: Decodable {
  public let raceSummaries: RaceSummaries
}

public struct RaceSummaries {
  public let nextRaces: [RaceSummary]
  
  public init(nextRaces: [RaceSummary]) {
    self.nextRaces = nextRaces
  }
}

public struct RaceSummary: Decodable {
  let raceId: UUID
  let raceName: String
}


extension RaceSummaries: Decodable {
  struct RaceSummariesKey: CodingKey {
      var stringValue: String
      init?(stringValue: String) {
          self.stringValue = stringValue
      }

      var intValue: Int? { return nil }
      init?(intValue: Int) { return nil }
  }
  
  public init(from decoder: Decoder) throws {
      var races = [RaceSummary]()
      let container = try decoder.container(keyedBy: RaceSummariesKey.self)
      for key in container.allKeys {
        let raceSummary = try container.decode(RaceSummary.self, forKey: key)
        races.append(raceSummary)
      }

      self.init(nextRaces: races)
  }
}
