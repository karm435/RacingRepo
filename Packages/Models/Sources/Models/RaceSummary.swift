
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
  let raceId: UUID
  let raceName: String
  let raceNumber: Int
  let meetingId: UUID
  let meetingName: String
  let categoryId: UUID
  let advertisedStart: AdvertisedStart
  let raceForm: RaceForm
  let venueCountry: String
  let venueState: String
  let venueName: String
  let venueId: String
}

struct AdvertisedStart: Codable {
    let seconds: Int
}

struct RaceForm: Codable {
    let distance: Int
    let distanceType: DistanceType
    let trackCondition: TrackCondition
    let raceComment: String
    let additionalData: String
    let generated: Int
    let raceCommentAlternative: String
    let silkBaseUrl: String
}

struct DistanceType: Codable {
    let id: UUID
    let name: String
    let shortName: String
}

struct TrackCondition: Codable {
    let id: UUID
    let name: String
    let shortName: String
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
