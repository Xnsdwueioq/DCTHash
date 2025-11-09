//
//  AppStateManager.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

@Observable
class AppStateManager {
  private let intColorThemes: [Int: AppTheme] = [
    1: .light,
    2: .dark,
    3: .system
  ]
  // App Info
  let appVersion = "1.7"
  let appDate = "2025.11"
  
  // UserDefaults Keys
  private let hasLaunchedBeforeKey = "hasLaunchedBeforeKey"
  private let colorThemeKey = "colorThemeKey"
  
  // App State Variables
  var hasLaunchedBefore: Bool
  var colorTheme: AppTheme
  
  init() {
    hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
    let intColorTheme = UserDefaults.standard.integer(forKey: colorThemeKey)
    colorTheme = intColorThemes[intColorTheme] ?? .system
  }
  
  // To close Welcome View and change state variable
  func closeWelcomeView() {
    hasLaunchedBefore = true
    UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
  }
  func changeTheme(newTheme: AppTheme) {
    colorTheme = newTheme
    UserDefaults.standard.set(newTheme.intColorScheme, forKey: colorThemeKey)
  }
}
