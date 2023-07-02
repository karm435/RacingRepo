
import Foundation

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
  public let raceId: UUID
  public let raceName: String
  public let raceNumber: Int
  public let meetingId: UUID
  public let meetingName: String
  public let categoryId: UUID
  public let advertisedStart: AdvertisedStart
  public let raceForm: RaceForm
  public let venueCountry: String
  public let venueState: String
  public let venueName: String
  public let venueId: String
}

public struct AdvertisedStart: Codable {
  public let seconds: Int
}

public struct RaceForm: Codable {
  public let distance: Int
  public let distanceType: DistanceType
  public let trackCondition: TrackCondition
 // public let raceComment: String
  public let additionalData: String
  public let generated: Int
  public let raceCommentAlternative: String
  public let silkBaseUrl: String
}

public struct DistanceType: Codable {
  public let id: UUID
  public let name: String
  public let shortName: String
}

public struct TrackCondition: Codable {
  public let id: UUID
  public let name: String
  public let shortName: String
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
