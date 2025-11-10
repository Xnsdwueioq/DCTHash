//
//  SearchView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 10.11.2025.
//

import SwiftUI

struct SearchView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @State var textfieldName: String = ""
  @State var searchedName: String = ""
  @FocusState private var isFocused: Bool
  
  var body: some View {
    List {
      HStack(spacing: 10) {
        TextField("Введите имя товара", text: $textfieldName)
          .focused($isFocused)
          .onChange(of: textfieldName, {
            searchedName = textfieldName == "" ? "" : searchedName
          })
          .onSubmit {
            searchedName = textfieldName
            isFocused = false
          }
          .submitLabel(.search)
        Button(action: {
          searchedName = textfieldName
          isFocused = false
        }, label: {
          Image(systemName: "magnifyingglass")
        })
        .buttonStyle(.borderedProminent)
      }
      
      if searchedName != "" {
        ForEach(Array(storage.productTable), id:\.key) { key, items in
          let filteredItems = items.filter({
            $0.name.lowercased().contains(searchedName.lowercased())
          })
          if !filteredItems.isEmpty {
            Section(content: {
              ForEach(filteredItems) { item in
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
            }, header: {
              Text(key)
            })
          }
        }
      }
    }
  }
}


#Preview {
  NavigationStack {
    SearchView()
      .navigationTitle("Поиск")
  }
  .environment(ProductStorage(barcodes: ["some$11"]))
}
