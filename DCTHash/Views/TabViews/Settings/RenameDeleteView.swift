//
//  StorageRenameView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct StorageRenameView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @State var isRenameVisible: Bool = false
  @State var isDeleteAllVisible: Bool = false
  @State var newName: String = ""
  
  var body: some View {
    Button("Переименовать склад") {
      isRenameVisible.toggle()
    }
    .alert("Новое название", isPresented: $isRenameVisible, actions: {
      TextField("Название", text: $newName)
      Button("ОК") {
        if !newName.isEmpty {
          storage.changeStorageName()
          newName = ""
        }
      }
      Button("Отмена", role: .cancel) {
        newName = ""
        isRenameVisible.toggle()
      }
    }, message: {
      Text("Введите новое название для склада")
    })
    
    Button("Очистить все данные") {
      isDeleteAllVisible.toggle()
    }
    .alert("Очистить все данные", isPresented: $isDeleteAllVisible, actions: {
      Button("Удалить", role: .destructive) {
        storage.deleteData()
        isDeleteAllVisible.toggle()
      }
      Button("Отмена", role: .cancel) {
        isDeleteAllVisible.toggle()
      }
    }, message: {
      Text("Вы уверены что хотите очистить все данные?")
    })
  }
}

#Preview {
  ContentView()
    .environment(AppStateManager())
    .environment(ProductStorage())
}
