
import Foundation

public enum DecodingError: Error {
  case failure(forKey: String)
}

public struct RaceSummaries {
  public struct RaceSummary {
    let raceId: UUID
    let raceName: String
    
    init(raceId: String, raceName: String) throws {
      if let raceId = UUID(uuidString: raceId) {
        self.raceId = raceId
      } else {
        throw DecodingError.failure(forKey: "RaceSummary.raceId")
      }
      self.raceName = raceName
    }
  }
  
  let nextRaces: [RaceSummary]
  
  public init(nextRaces: [RaceSummary]) {
    self.nextRaces = nextRaces
  }
}

extension RaceSummaries: Decodable {
  struct RaceSummaryKey: CodingKey {
    var intValue: Int?
    init?(intValue: Int) { return nil }
    
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    static let raceId = RaceSummaryKey(stringValue: "race_id")!
    static let raceName = RaceSummaryKey(stringValue: "race_name")!
  }
  
  public init(from decoder: Decoder) throws {
    var races = [RaceSummary]()
    
    let container = try decoder.container(keyedBy: RaceSummaryKey.self)
    
    for key in container.allKeys {
      let raceSummaryContainer = try container.nestedContainer(keyedBy: RaceSummaryKey.self, forKey: key)
      
      let raceId = try raceSummaryContainer.decode(String.self, forKey: .raceId)
      let raceName = try raceSummaryContainer.decode(String.self, forKey: .raceName)
      
      let raceSummay = try  RaceSummary(raceId: raceId, raceName: raceName)
      races.append(raceSummay)
    }
    
    self.init(nextRaces: races)
  }
}
