//
//  ContentView.swift
//  RecingInfo
//
//  Created by karmjit singh on 27/6/2023.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var racingModel: RacingModel
    var body: some View {
        VStack {
          Text("\(racingModel.raceSummaries.count)")
        }
        .padding()
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
