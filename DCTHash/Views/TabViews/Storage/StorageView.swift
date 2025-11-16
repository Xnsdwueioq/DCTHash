//
//  StorageView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct StorageView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @State var showingImporter: Bool = false
  @State var importSuccess: Bool?
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
          NavigationLink(destination: {
            SearchView()
              .navigationTitle("Поиск")
          }, label: {
            Image(systemName: "magnifyingglass")
          })
        })
        
        // save
        ToolbarItem(placement: .automatic, content: {
          JSONSaverView(showingExporter: $showingExporter, exportSuccess: $exportSuccess)
        })
        
        // load
        ToolbarItem(placement: .automatic, content: {
            Button(action: {
                self.showingImporter = true
                self.importSuccess = nil
            }, label: {
                Image(systemName: "square.and.arrow.down")
                    .symbolRenderingMode(.multicolor)
            })
        })
      })
    }
    .fullScreenCover(isPresented: $showingExporter) {
      DocumentExporter(
        data: (try? storage.getJSONData()) ?? Data(),
        filename: "product_storage_\(Date().timeIntervalSince1970).json",
        isPresented: $showingExporter
      ) { completed in
        self.exportSuccess = completed
      }
    }
    .fullScreenCover(isPresented: $showingImporter) {
        DocumentImporter(isPresented: $showingImporter) { result in
            switch result {
            case .success(let data):
                do {
                    try storage.loadProductTable(from: data)
                    self.importSuccess = true
                    print("Данные успешно импортированы.")
                } catch {
                    print("Ошибка декодирования импортированных данных: \(error.localizedDescription)")
                    self.importSuccess = false
                }
            case .failure(let error):
                print("Ошибка при выборе файла: \(error.localizedDescription)")
                self.importSuccess = false
            }
        }
    }
  }
}

#Preview {
  StorageView()
    .environment(AppStateManager())
    .environment(ProductStorage())
}
