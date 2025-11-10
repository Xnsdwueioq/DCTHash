//
//  StorageView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct StorageView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @State var showingExporter: Bool = false
  @State var exportSuccess: Bool?
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
      
      .toolbar(content: {
        // search
        ToolbarItem(placement: .automatic, content: {
          //TODO (реализация поиска)
          Button(action: {
          }, label: {
            Image(systemName: "magnifyingglass")
              .symbolRenderingMode(.multicolor)
          })
        })
        
        // save
        ToolbarItem(placement: .automatic, content: {
          JSONSaverView(showingExporter: $showingExporter, exportSuccess: $exportSuccess)
        })
      })
    }
    .fullScreenCover(isPresented: $showingExporter) {
      // DocumentExporter невидимый, он просто отображает системный диалог
      DocumentExporter(
        data: (try? storage.getJSONData()) ?? Data(), // Получаем данные здесь, или пустые в случае ошибки
        filename: "product_storage_\(Date().timeIntervalSince1970).json",
        isPresented: $showingExporter
      ) { completed in
        self.exportSuccess = completed
      }
    }
  }
}

#Preview {
  StorageView()
    .environment(AppStateManager())
    .environment(ProductStorage())
}
