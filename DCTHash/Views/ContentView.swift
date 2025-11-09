//
//  ContentView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct ContentView: View {
  @State var selectedView: TabViews = .storage
  
  var body: some View {
    TabView(selection: $selectedView, content: {
      Tab("Сканер", systemImage: "barcode", value: .scanner, content: {
        ScannerView()
      })
      Tab("Склад", systemImage: "internaldrive", value: .storage, content: {
        StorageView()
      })
      Tab("Настройки", systemImage: "gear", value: .settings, content: {
        SettingsView()
      })
    })
  }
}

#Preview {
  ContentView()
    .environment(AppStateManager())
}
