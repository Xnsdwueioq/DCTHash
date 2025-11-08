//
//  SettingsView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

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
              //TODO (менять тему приложения)
            }
          }, label: { })
          .pickerStyle(.palette)
        }, header: {
          Text("Тема")
        })
        Section(content: {
          Button("Переименовать склад") {
            //TODO (действие переименовать склад)
          }
          Button("Очистить все данные") {
            //TODO (очистить все данные)
          }
        })
        Section(content: {
          NavigationLink(destination: {
            //TODO (новое окно справки)
          }, label: {
            Text("Справка")
          })
          NavigationLink(destination: {
            //TODO (новое окно для отправки отзыва)
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
