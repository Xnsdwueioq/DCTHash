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
        // Тема
        Section(content: {
          Picker(selection: $selectedAppTheme, content: {
            ForEach(AppTheme.allCases, id: \.self) { theme in
              Text(theme.rawValue)
            }
          }, label: { })
          .pickerStyle(.palette)
          .onChange(of: selectedAppTheme, {
            appStateManager.changeTheme(newTheme: selectedAppTheme)
          })
        }, header: {
          Text("Тема")
        })
        .onAppear {
          selectedAppTheme = appStateManager.colorTheme
        }
        
        // Переименовать и очистить
        Section(content: {
          StorageRenameView()
        })
        
        // Справка и отзыв
        Section(content: {
          NavigationLink(destination: {
            HelpView()
          }, label: {
            Text("Справка")
          })
          NavigationLink(destination: {
            SendFeedbackView()
          }, label: {
            Text("Отправить отзыв")
          })
        }, footer: {
          Text("DCTHash ver \(appStateManager.appVersion) \(appStateManager.appDate)")
        })
      }
      .navigationTitle("Настройки")
    }
  }
}

#Preview {
  ContentView()
    .environment(AppStateManager())
    .environment(ProductStorage())
}
