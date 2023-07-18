//
//  RacingModelTests.swift
//  RecingInfoTests
//
//  Created by karmjit singh on 27/6/2023.
//

import XCTest
@testable import RecingInfo
import AppUtils
import Foundation
import Models

final class RacingModelTests: XCTestCase {
  private var raceModel: RacingModel!
  private var mockNetworkClient = MockNetworkClient()
  
  override func setUp() {
    raceModel = RacingModel(networkClient: mockNetworkClient)
  }
  
  func testShouldSubscribeToSearchTokens() {
    XCTAssertEqual(raceModel.cancellables.count, 1)
  }
  
  func testShouldFetchRacesFromServer() async {
    let response: GetRacesResponse = JsonLoader.load("SampleRaces.json", bundle: Bundle.main)
   
    mockNetworkClient.mockReponse = response
    
    await raceModel.loadRaces()
    
    XCTAssertTrue(!raceModel.allRaces.isEmpty)
  }
  
  fileprivate func oneHourFutureTime() -> Int {
    let timeInFuture = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
  
    return Int(timeInFuture.timeIntervalSince1970)
  }
  
  func testShouldProvideOnly5TopRaces() async {
    var response: GetRacesResponse = JsonLoader.load("SampleRaces.json", bundle: Bundle.main)
    
    let races: [RaceSummary] = response.data.raceSummaries.nextRaces
    let advertiseTimeInfuture =  oneHourFutureTime()
    var  updatedRaces: [RaceSummary] = []
    for var race in races {
      let advertisedStart = AdvertisedStart(seconds: advertiseTimeInfuture)
      race.advertisedStart = advertisedStart
      updatedRaces.append(race)
    }
    
    response.data.raceSummaries.nextRaces =  updatedRaces
    mockNetworkClient.mockReponse = response
    
    await raceModel.loadRaces()
    
    XCTAssertEqual(raceModel.orderedTop5Races.count, 5)
  }
  
  func testShouldFilterRacesPast1Min() async {
    var response: GetRacesResponse = JsonLoader.load("SampleRaces.json", bundle: Bundle.main)
    
    let races: [RaceSummary] = response.data.raceSummaries.nextRaces
    let advertiseTimeInfuture =  oneHourFutureTime()
    
    var  updatedRaces: [RaceSummary] = []
    // Let's just make 3 races in future
    for var race in races.prefix(3) {
      let advertisedStart = AdvertisedStart(seconds: advertiseTimeInfuture)
      race.advertisedStart = advertisedStart
      updatedRaces.append(race)
    }
    
    response.data.raceSummaries.nextRaces = updatedRaces
    mockNetworkClient.mockReponse = response
    
    await raceModel.loadRaces()
    
    XCTAssertEqual(raceModel.orderedTop5Races.count, 3)
  }
  
  func testShouldFilterRacesForCategory() async {
    var response: GetRacesResponse = JsonLoader.load("SampleRaces.json", bundle: Bundle.main)
    
    let races: [RaceSummary] = response.data.raceSummaries.nextRaces
    let advertiseTimeInfuture =  oneHourFutureTime()
    var  updatedRaces: [RaceSummary] = []
    for var race in races {
      let advertisedStart = AdvertisedStart(seconds: advertiseTimeInfuture)
      race.advertisedStart = advertisedStart
      updatedRaces.append(race)
    }
    
    response.data.raceSummaries.nextRaces = updatedRaces
    mockNetworkClient.mockReponse = response
    
    await raceModel.loadRaces()
    raceModel.updateSearch(cat: .greyhoundRacing)
    
    let raceCatForRaces = raceModel.orderedTop5Races.map { $0.raceCategory }.compactMap { $0 }
    XCTAssertEqual(raceCatForRaces.allSatisfy { $0 == .greyhoundRacing }, true)
  }
}
