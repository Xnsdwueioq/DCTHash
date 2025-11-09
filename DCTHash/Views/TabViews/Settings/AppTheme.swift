//
//  AppTheme.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
  case light = "Светлая"
  case dark = "Темная"
  case system = "Системная"
  
  var colorScheme: ColorScheme? {
    switch self {
    case .light:
      return .light
    case .dark:
      return .dark
    case .system:
      return nil
    }
  }
  
  var intColorScheme: Int {
    switch self {
    case .light:
      return 1
    case .dark:
      return 2
    case .system:
      return 3
    }
  }
}

