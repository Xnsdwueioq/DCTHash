//
//  AppStateManager.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

// класс управляет основными состояниями приложения
// содержит основную информацию
@Observable
class AppStateManager {
  private let intColorThemes: [Int: AppTheme] = [
    1: .light,
    2: .dark,
    3: .system
  ]

  let appVersion = "2.2.3"
  let appDate = "2025.11"
  
  private let hasLaunchedBeforeKey = "hasLaunchedBeforeKey"
  private let colorThemeKey = "colorThemeKey"
  
  var hasLaunchedBefore: Bool
  var colorTheme: AppTheme
  
  // инициализатор, подгружающий данные о первом запуске и теме из хранилища
  init() {
    hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
    let intColorTheme = UserDefaults.standard.integer(forKey: colorThemeKey)
    colorTheme = intColorThemes[intColorTheme] ?? .system
  }
  
  // закрытие приветственного окна, сохранение данных
  func closeWelcomeView() {
    hasLaunchedBefore = true
    UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
  }
  
  // смена темы оформления
  func changeTheme(newTheme: AppTheme) {
    colorTheme = newTheme
    UserDefaults.standard.set(newTheme.intColorScheme, forKey: colorThemeKey)
  }
}
