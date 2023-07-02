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
              Text(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)
            }
            Text("Is min in race \(raceSummary.advertisedStart.isOneMinutePassedStartTime ? "Yes" : "No")")
          }
        }
      }
      .navigationTitle(Text("Next To Go Racing"))
      .task {
        await racingModel.loadRaces()
        await racingModel.autoRefresh()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



