//
//  ContentView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct ContentView: View {
  @State var selectedView: TabViews = .scanner
  
  var body: some View {
    TabView(selection: $selectedView, content: {
      Tab("Сканер", systemImage: "barcode", value: .scanner, content: {
        Text("\(selectedView.rawValue)")
      })
      Tab("Склад", systemImage: "internaldrive", value: .storage, content: {
        Text("\(selectedView.rawValue)")
      })
      Tab("Настройки", systemImage: "gear", value: .scanner, content: {
        Text("\(selectedView.rawValue)")
      })
    })
  }
}

#Preview {
  ContentView()
}
