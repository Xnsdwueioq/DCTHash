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
        if !storage.productTable.isEmpty {
          ForEach(Array(storage.productTable), id:\.key) { key, items in
            NavigationLink(key, destination: {
              List {
                if !(storage.productTable[key] ?? []).isEmpty {
                  // Карточки товаров
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
                  .onDelete(perform: { offset in
                    storage.productTable[key]?.remove(atOffsets: offset)
                  })
                } else {
                  Text("Нет данных")
                    .foregroundStyle(.gray)
                }
              }
              .navigationTitle(key)
            })
          }
        } else {
          Text("Нет данных")
            .foregroundStyle(.gray)
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
