//
//  StorageView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct StorageView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  
  @State var storageName: String = "Склад"
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(storage.productTable), id:\.key) { key, items in
          NavigationLink(key, destination: {
            List {
              ForEach(items) { item in
                Text(item.name)
              }
            }
            .navigationTitle(key)
          })
        }
      }
      .navigationTitle(storageName)
    }
  }
}

#Preview {
  StorageView()
    .environment(AppStateManager())
    .environment(ProductStorage())
}
