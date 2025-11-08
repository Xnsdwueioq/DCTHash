//
//  SettingsView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
  case light = "Светлая"
  case dark = "Темная"
  case system = "Системная"
}

struct SettingsView: View {
  @Environment(AppStateManager.self) var appStateManager: AppStateManager
  @State var selectedAppTheme: AppTheme = .system
  
  var body: some View {
    NavigationStack {
      List {
        Section(content: {
          Picker(selection: $selectedAppTheme, content: {
            ForEach(AppTheme.allCases, id: \.self) { theme in
              Text(theme.rawValue)
              //TODO
            }
          }, label: { })
          .pickerStyle(.palette)
        }, header: {
          Text("Тема")
        })
        Section(content: {
          Button("Переименовать склад") {
            //TODO
          }
          Button("Очистить все данные") {
            //TODO
          }
        })
        Section(content: {
          NavigationLink(destination: {
            //TODO
          }, label: {
            Text("Справка")
          })
          NavigationLink(destination: {
            //TODO
          }, label: {
            Text("Отправить отзыв")
          })
        }, footer: {
          Text("ver \(appStateManager.appVersion) \(appStateManager.appDate)")
        })
      }
      .navigationTitle("Настройки")
    }
  }
}

#Preview {
  SettingsView()
    .environment(AppStateManager())
}
