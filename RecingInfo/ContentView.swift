//
//  ContentView.swift
//  RecingInfo
//
//  Created by karmjit singh on 27/6/2023.
//

import SwiftUI
import Models
import Network

struct ContentView: View {
  @EnvironmentObject var racingModel: RacingModel
  @ScaledMetric var imageSize = 24.0
  @ScaledMetric var filterImageSize = 36.0
  
  var body: some View {
    VStack {
      HStack {
        ForEach(RaceCategory.allCases) { cat in
            Button {
              racingModel.updateSearch(cat: cat)
            } label: {
              VStack(spacing: 0) {
                Image(cat.iconName)
                  .resizable()
                  .frame(width: filterImageSize, height: filterImageSize)
                  .accessibilityLabel(Text(cat.name))
                
                if racingModel.searchTokens.isSelected(category: cat) {
                  RoundedRectangle(cornerRadius: 6)
                    .fill(.red)
                    .frame(maxHeight: 5)
                    .padding(.horizontal)
                }
              }
            }
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Filter races for \(cat.name)")
        }
      }
      .fixedSize(horizontal: false, vertical: true)
      List {
        ForEach(racingModel.orderedTop5Races, id: \.id) { raceSummary in
          VStack {
            HStack {
              if let imageName = raceSummary.raceCategory?.iconName {
                Image(imageName)
                  .resizable()
                  .frame(width: imageSize, height: imageSize)
              }
              VStack(alignment: .leading) {
                Text(raceSummary.raceName)
                  .lineLimit(1)
                Text(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)
                  .font(.footnote)
                  .foregroundColor(.secondary)
              }
            }
            .accessibilityLabel(Text("\(raceSummary.raceName)"))
          }
        }
      }
    }
    .navigationTitle(Text("Next To Go Racing"))
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
    NavigationStack {
      ContentView()
        .environmentObject(RacingModel(networkClient: NetworkClient()))
    }
  }
}



