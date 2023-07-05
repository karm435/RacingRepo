
import Foundation
import Models
import Network
import Combine

class RacingModel: ObservableObject {
  @Published var nextToGoRaceSummaries: [RaceSummary] = []
  @Published var searchTokens: [RaceCategory] = []
  @Published var isSearching = false
  
  var allRaces: [RaceSummary] = []
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
    
    $searchTokens
      .sink { [unowned self] _ in        self.filterRaces()
      }.store(in: &cancellables)
  }
  
  @MainActor
  public func loadRaces() async -> Void {
    do {
      let result: GetRacesResponse = try await networkClient.get("https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10")
      
      allRaces = result.data.raceSummaries.nextRaces
      
      nextToGoRaceSummaries = filterOneMinPastRaces(races: allRaces)
      
    } catch {
      print(error)
    }
  }
  
  @MainActor
  public func autoRefresh() async -> Void {
    let timerEverySeconds = 60.0
    let _ = Timer.publish(every: timerEverySeconds, on: .main, in: .default)
      .autoconnect()
      .map { [weak self] _ in
        guard let self else { return [] }
        return self.filterOneMinPastRaces(races: self.allRaces)
      }
      .assign(to: \.nextToGoRaceSummaries, on: self)
      .store(in: &cancellables)
  }
  
  public func updateSearch(cat: RaceCategory) {
    if searchTokens.isSelected(category: cat) {
      searchTokens.removeAll(where: { $0 == cat })
    } else {
      searchTokens.append(cat)
    }
  }
  
  private func filterOneMinPastRaces(races: [RaceSummary]) -> [RaceSummary] {
    print("races count:", self.nextToGoRaceSummaries.count)
    return races.filter { raceSummary in
      return !raceSummary.advertisedStart.isOneMinutePassedStartTime
    }
  }
  
  
  private func filterRaces() {
    isSearching = true
    guard !searchTokens.isEmpty else {
      self.nextToGoRaceSummaries = filterOneMinPastRaces(races: self.allRaces)
      return
    }
    
    nextToGoRaceSummaries = nextToGoRaceSummaries.filter { raceSummary in
      searchTokens.map({ $0.rawValue.lowercased() }).contains(raceSummary.categoryId.uuidString.lowercased())
    }
    isSearching = false
  }
}

extension Array<RaceCategory> {
  func isSelected(category: RaceCategory) -> Bool {
    self.contains(where: { $0 == category })
  }
}
