//
//  AppStateManager.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

@Observable
class AppStateManager {
  let appVersion = "1.1"
  let appDate = "2025.11"
  private let hasLaunchedBeforeKey = "hasLaunchedBeforeKey"
  
  var hasLaunchedBefore: Bool
  
  init() {
    hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
  }
  
  func closeWelcomeView() {
    hasLaunchedBefore = true
    UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
  }
}
