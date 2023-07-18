
import Foundation

public struct GetRacesResponse: Decodable {
  public let status: Int
  public var data: RaceSummeriesResponse
}

public struct RaceSummeriesResponse: Decodable {
  public var raceSummaries: RaceSummaries
}

public struct RaceSummaries {
  public var nextRaces: [RaceSummary]
  
  public init(nextRaces: [RaceSummary]) {
    self.nextRaces = nextRaces
  }
}

public struct RaceSummary: Decodable {
  public let raceId: UUID
  public let raceName: String
  public let raceNumber: Int
  public let categoryId: UUID
  public var advertisedStart: AdvertisedStart
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

extension RaceSummary: Identifiable {
  public var id: UUID {
    raceId
  }
}

extension RaceSummary {
  public var raceCategory: RaceCategory? {
    return RaceCategory(rawValue: categoryId.uuidString.lowercased())
  }
}


