//
//  StorageView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct StorageView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  var storageName: String {
    storage.storageName
  }
  
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(storage.productTable), id:\.key) { key, items in
          NavigationLink(key, destination: {
            List {
              ForEach(items) { item in
                NavigationLink(destination: {
                  BarcodeGeneratorView(product: item)
                }) {
                  Stepper(value: Binding(get: {
                    item.amount
                  }, set: { newAmount in
                    storage.stepperSet(category: key, productName: item.name, newAmount: newAmount)
                  }), in: 1...Int.max, label: {
                    Text(item.name)
                    Text(String(item.amount))
                  })
                }
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
    .environment(ProductStorage(barcodes: [
      "some1$101",
      "some2$102",
      "some3$103",
      "some4$104",
      "some5$105",
      "some6$106",
    ]))
}
