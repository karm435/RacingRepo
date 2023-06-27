
import Foundation
import Models
import Network

public enum NextRacesViewState {
  case loading
  case error
  case display(raceSummaries: RaceSummaries)
}

class RacingModel: ObservableObject {
  @Published var racingSummaries = RaceSummaries(nextRaces: [])
  
  let networkClient: NetworkClient
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  public func loadRaces() async {
    
  }
}
