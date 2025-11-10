//
//  DCTHashApp.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

@main
struct DCTHashApp: App {
  @State var launchedScreenState = LaunchScreenStateManager()
  @State var appStateManager = AppStateManager()
  @State var storage = ProductStorage()

  var body: some Scene {
    WindowGroup {
      ZStack {
        if appStateManager.hasLaunchedBefore {
          ContentView()
            .environment(appStateManager)
            .environment(storage)
            .preferredColorScheme(appStateManager.colorTheme.colorScheme)
        } else {
          WelcomeView()
            .environment(appStateManager)
        }
        
        if launchedScreenState.isActive {
          AnimatedLaunchView()
            .transition(.opacity)
            .environment(launchedScreenState)
        }
      }
    }
  }
}


#Preview {
  ContentView()
    .environment(AppStateManager())
    .environment(ProductStorage())
    .preferredColorScheme(.light)
}
