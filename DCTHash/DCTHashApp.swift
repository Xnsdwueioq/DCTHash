//
//  DCTHashApp.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

@main
struct DCTHashApp: App {
  @State var appStateManager = AppStateManager()

  var body: some Scene {
    WindowGroup {
      if appStateManager.hasLaunchedBefore {
        ContentView()
      } else {
        WelcomeView(appStateManager: appStateManager)
      }
    }
  }
}


#Preview {
  ContentView()
}
