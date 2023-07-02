//
//  RecingInfoApp.swift
//  RecingInfo
//
//  Created by karmjit singh on 27/6/2023.
//

import SwiftUI
import Network

@main
struct RecingInfoApp: App {
  @StateObject private var racingModel: RacingModel = .init(networkClient: NetworkClient())
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView()
          .environmentObject(racingModel)
      }
    }
  }
}
