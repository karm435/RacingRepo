
import Foundation
import Models
import Network
import Combine

class RacingModel: ObservableObject {
  @Published var raceSummaries: [RaceSummary] = []
  var allRaces: [RaceSummary] = []
  let networkClient: NetworkClient
  var cancellables = Set<AnyCancellable>()
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  @MainActor
  public func loadRaces() async -> Void {
    do {
      let result: GetRacesResponse = try await networkClient.get("https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10")
      
      let results = result.data.raceSummaries.nextRaces
      allRaces = results
      
      //filter races which are 1 min past start time
      raceSummaries = allRaces//.sorted(by: { $0.advertisedStart.toDate() > $1.advertisedStart.toDate() })
      
    } catch {
      print(error)
    }
  }
  
  @MainActor
  public func autoRefresh() async -> Void {
    let timer = Timer.publish(every: 1, on: .main, in: .default)
      .autoconnect()
      .map { [weak self] _ in
        guard let self else { return [] }
        return self.filterRaces()
      }
      .assign(to: \.raceSummaries, on: self)
      .store(in: &cancellables)
  }
  
  private func filterRaces() -> [RaceSummary] {
    return self.raceSummaries.filter { raceSummary in
      return !raceSummary.advertisedStart.isOneMinutePassedStartTime
    }
  }
  
}
