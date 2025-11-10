//
//  JSONSaverView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 10.11.2025.
//

import SwiftUI

struct JSONSaverView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @Binding var showingExporter: Bool
  @Binding var exportSuccess: Bool?
  
  var body: some View {
    Button(action: {
      do {
        // Пробуем получить данные перед показом диалога
        let data = try storage.getJSONData()
        
        // Устанавливаем параметры для экспорта
        self.showingExporter = true
        self.exportSuccess = nil
        
      } catch {
        print("Ошибка кодирования данных: \(error.localizedDescription)")
      }
    }, label: {
      Image(systemName: "square.and.arrow.down")
        .symbolRenderingMode(.multicolor)
    })
  }
}
