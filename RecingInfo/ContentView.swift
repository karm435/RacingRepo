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
        ForEach(racingModel.orderedTop5Races, id: \.id) { raceSummary in
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
      .searchable(text: $racingModel.searchText)
//      , tokens: $racingModel.tokens) { token in
//        switch token {
//          case .horseRacing: Text("Horse")
//          case .greyhoundRacing: Text("Greyhound")
//          case .harnessRacing: Text("Harness")
//        }
//      }
//      .searchSuggestions {
//        Label {
//          Text("Greyhound Racing")
//        } icon: {
//          Image("greyhound")
//            .resizable()
//            .frame(width: 24, height: 24)
//            .scaledToFit()
//        }.searchCompletion(RaceCategory.greyhoundRacing)
//
//        Label {
//          Text("Harness Racing")
//        } icon: {
//          Image("harness")
//            .resizable()
//            .frame(width: 24, height: 24)
//            .scaledToFit()
//        }.searchCompletion(RaceCategory.harnessRacing)
//
//        Label {
//          Text("Horse Racing")
//        } icon: {
//          Image("horse-racing")
//            .resizable()
//            .frame(width: 24, height: 24)
//            .scaledToFit()
//        }.searchCompletion(RaceCategory.horseRacing)
//      }
      .refreshable {
        await racingModel.loadRaces()
      }
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



