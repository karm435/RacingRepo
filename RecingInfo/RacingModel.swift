
import Foundation
import Models
import Network
import Combine

class RacingModel: ObservableObject {
  @Published var nextToGoRaceSummaries: [RaceSummary] = []
  
  @Published var filteredRaces: [RaceSummary] = []
  
  @Published var searchText: String = ""
  
  let networkClient: NetworkClient
  var cancellables = Set<AnyCancellable>()
  
  var orderedTop5Races: [RaceSummary] {
    let top5 = nextToGoRaceSummaries
      .sorted(by: { $0.advertisedStart < $1.advertisedStart })
      .prefix(5)
    
    return Array(top5)
  }
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
    
    $searchText
      .removeDuplicates()
      .sink { [weak self] searchTerm in
        self?.filterRaces(searchText: searchTerm)
      }
      .store(in: &cancellables)
  }
  
  @MainActor
  public func loadRaces() async -> Void {
    do {
      let result: GetRacesResponse = try await networkClient.get("https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10")
      
      let allRaces = result.data.raceSummaries.nextRaces
      
      nextToGoRaceSummaries = filterOneMinPastRaces(races: allRaces)
      
    } catch {
      print(error)
    }
  }
  
  @MainActor
  public func autoRefresh() async -> Void {
    let _ = Timer.publish(every: 1, on: .main, in: .default)
      .autoconnect()
      .map { [weak self] _ in
        guard let self else { return [] }
        return self.filterOneMinPastRaces(races: self.nextToGoRaceSummaries)
      }
      .assign(to: \.nextToGoRaceSummaries, on: self)
      .store(in: &cancellables)
  }
  
  private func filterOneMinPastRaces(races: [RaceSummary]) -> [RaceSummary] {
    return races.filter { raceSummary in
      return !raceSummary.advertisedStart.isOneMinutePassedStartTime
    }
  }
  
  
  private func filterRaces(
    searchText: String
  ) {
    guard !searchText.isEmpty else { return }
    
    nextToGoRaceSummaries = nextToGoRaceSummaries.filter {
      $0.raceName.lowercased().contains(searchText.lowercased())
    }
  }
}
