
import Foundation
import Models
import Network

class RacingModel: ObservableObject {
  @Published var raceSummaries: [RaceSummary] = []
  
  let networkClient: NetworkClient
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  @MainActor
  public func loadRaces() async -> Void {
    do {
      let result: GetRacesResponse = try await networkClient.get("https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10")
      
      raceSummaries = result.data.raceSummaries.nextRaces
    } catch {
      print(error)
    }
  }
}
