
import Foundation
import Models
import Network
import Combine

class RacingModel: ObservableObject {
  @Published private(set) var searchTokens: [RaceCategory] = []
  @Published private(set) var nextToGoRaceSummaries: [RaceSummary] = []
  
  private(set) var allRaces: [RaceSummary] = []
  private let networkClient: NetworkClientProtocol
  private(set)var cancellables = Set<AnyCancellable>()
  
  var orderedTop5Races: [RaceSummary] {
    let top5 = nextToGoRaceSummaries
      .sorted(by: { $0.advertisedStart <= $1.advertisedStart })
      .prefix(5)
    
    return Array(top5)
  }
  
  init(networkClient: NetworkClientProtocol) {
    self.networkClient = networkClient
    
    $searchTokens
      .sink { [unowned self] tokens in
        self.filterRaces(tokens: tokens)
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
    let timerEverySeconds = 1.0
    let _ = Timer.publish(every: timerEverySeconds, on: .main, in: .default)
      .autoconnect()
      .sink(receiveValue: { [weak self] _ in
        guard let self else { return  }
        self.filterRaces(tokens: self.searchTokens)
      })
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
  
  
  private func filterRaces(tokens: [RaceCategory]) {
    guard !tokens.isEmpty else {
      self.nextToGoRaceSummaries = filterOneMinPastRaces(races: self.allRaces)
      return
    }
    let oneMinPastRaces = filterOneMinPastRaces(races: self.allRaces)
    nextToGoRaceSummaries = oneMinPastRaces.filter { raceSummary in
      let idsToFilter = tokens.map{ $0.rawValue.lowercased() }
      return idsToFilter.contains(raceSummary.categoryId.uuidString.lowercased())
    }
    
  }
}

extension Array<RaceCategory> {
  func isSelected(category: RaceCategory) -> Bool {
    self.contains(where: { $0 == category })
  }
}
