//
//  ContentView.swift
//  RecingInfo
//
//  Created by karmjit singh on 27/6/2023.
//

import SwiftUI
import Models

struct ContentView: View {
  @EnvironmentObject var racingModel: RacingModel
    var body: some View {
      List {
        ForEach(racingModel.raceSummaries, id: \.id) { raceSummary in
          VStack {
            HStack {
              Text(raceSummary.raceName)
              Spacer()
              Text(raceSummary.advertisedStart.toDate().formatted())
            }
            
            HStack {
              Text(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)
              Spacer()
              Text(raceSummary.advertisedStart.since)
            }
            
            HStack {
              Text("Is one minue? \(raceSummary.advertisedStart.isOneMinutePassedStartTime ? "Yes" : "No")")
            }
          }
        }
      }
      .task {
        await racingModel.loadRaces()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension AdvertisedStart {
  
  public var isOneMinutePassedStartTime: Bool {
    let date = Date(timeIntervalSince1970: TimeInterval(self.seconds))
    return  date.addingTimeInterval(60) < .now
  }
  
  public var since: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: toDate(), relativeTo: .now)
  }
  
  public func toDate() -> Date {
    // Convert timestamp to utc date
    let date = Date(timeIntervalSince1970: TimeInterval(self.seconds))
    return date
  }
}
