//
//  AppStateManager.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

@Observable
class AppStateManager {
  // App Info
  let appVersion = "1.1"
  let appDate = "2025.11"
  
  // UserDefaults Keys
  private let hasLaunchedBeforeKey = "hasLaunchedBeforeKey"
  
  // App State Variables
  var hasLaunchedBefore: Bool
  
  init() {
    hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
  }
  
  // To close Welcome View and change state variable
  func closeWelcomeView() {
    hasLaunchedBefore = true
    UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
  }
}
