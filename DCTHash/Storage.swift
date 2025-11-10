//
//  Storage.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct Product: Identifiable, Hashable, Codable {
  var id: UUID = UUID()
  let name: String
  var amount: Int
  let category: String
  
  private static let categoryMap: [String: String] = [
    "1": "Техника",
    "2": "Мебель",
    "3": "Медицина",
    "4": "Металлы",
    "5": "Химия",
    "6": "Бумажные изделия"
  ]
  
  init?(barcode: String) {
    let components = barcode.split(separator: "$")
    guard components.count == 2 else {
      return nil
    }
    
    let parsedName = String(components[0])
    let dataPart = components[1]
    
    guard let categoryCode = dataPart.last.map({String($0)}),
          let parsedCategory = Product.categoryMap[categoryCode] else {
      return nil
    }
    
    let amountSubstring = dataPart.dropLast()
    
    guard let parsedAmount = Int(String(amountSubstring)) else {
      return nil
    }
    
    self.name = parsedName
    self.amount = parsedAmount
    self.category = parsedCategory
  }
  
  init(name: String, amount: Int, category: String) {
    self.name = name
    self.amount = amount
    self.category = category
  }
}

@Observable
class ProductStorage {
  private let storageNameKey = "storageNameKey"
  private let productTableFilename = "products.json"
  
  var storageName: String = "Склад"
  var productTable: [String : [Product]] = [
    "Техника":[],
    "Мебель":[],
    "Медицина":[],
    "Металлы":[],
    "Химия":[],
    "Бумажные изделия":[]
  ]
  
  private var dataFileURL: URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent(productTableFilename)
  }
  
  init(barcodes: [String]) {
    addProducts(productsBarcodes: barcodes)
  }
  init() {
    storageName = UserDefaults.standard.string(forKey: storageNameKey) ?? "Склад"
    loadProductTable()
  }
  
  private func loadProductTable() {
    guard let data = try? Data(contentsOf: dataFileURL) else {
      return
    }
    do {
      productTable = try JSONDecoder().decode([String : [Product]].self, from: data)
      let requiredKeys = productTable.keys
      for key in requiredKeys where productTable[key] == nil {
        productTable[key] = []
      }
    } catch {
      print("Ошибка декодирования данных: \(error.localizedDescription)")
    }
  }
  private func saveProductTable() {
    do {
      let encodedData = try JSONEncoder().encode(productTable)
      try encodedData.write(to: dataFileURL)
    } catch {
      print("Ошибка сохранения данных: \(error.localizedDescription)")
    }
  }
  
  func changeStorageName(_ newName: String) {
    storageName = newName
    UserDefaults.standard.set(newName, forKey: storageNameKey)
  }
  func stepperSet(category: String, productName: String, newAmount: Int) {
    if var products = productTable[category] {
      if let index = products.firstIndex(where: {$0.name == productName}) {
        products[index].amount = newAmount
        productTable[category] = products
        saveProductTable()
      }
    }
  }
  
  func addProducts(productsBarcodes: [String]) {
    for barcode in productsBarcodes {
      guard let newProduct = Product(barcode: barcode) else {
        print("Ошибка парсинга штрихкода: \(barcode) - пропуск")
        continue
      }
      
      let productName = newProduct.name
      let productCategory = newProduct.category
      let productAmount = newProduct.amount
      
      var categoryProducts = productTable[productCategory, default: []]
      if let index = categoryProducts.firstIndex(where: {
        $0.name == productName
      }) {
        categoryProducts[index].amount += productAmount
      } else {
        categoryProducts.append(newProduct)
      }
      productTable[productCategory] = categoryProducts
    }
    saveProductTable()
  }
  func deleteProducts(productsBarcodes: [String]) {
    for barcode in productsBarcodes {
      guard let deleteProduct = Product(barcode: barcode) else {
        print("Ошибка парсинга штрихкода: \(barcode) - пропуск")
        continue
      }
      
      let productName = deleteProduct.name
      let productCategory = deleteProduct.category
      let productAmount = deleteProduct.amount
      
      var categoryProducts = productTable[productCategory, default: []]
      if let index = categoryProducts.firstIndex(where: {
        $0.name == productName
      }) {
        if categoryProducts[index].amount > productAmount {
          categoryProducts[index].amount -= productAmount
          productTable[productCategory] = categoryProducts
        } else {
          categoryProducts.remove(at: index)
          productTable[productCategory] = categoryProducts
        }
      }
    }
    saveProductTable()
  }
  func deleteAllProducts() {
    for key in productTable.keys {
      productTable[key] = []
    }
    saveProductTable()
  }
  
  func getJSONData() throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return try encoder.encode(self.productTable)
  }
}

let jsonUTType = UTType(filenameExtension: "json", conformingTo: .data)!

struct DocumentExporter: UIViewControllerRepresentable {
  // Данные, которые мы хотим сохранить (в формате Data)
  let data: Data
  let filename: String
  
  @Binding var isPresented: Bool
  var completion: (Bool) -> Void // Callback для обработки результата
  
  func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    
    // Запускаем экспорт, как только View появляется
    DispatchQueue.main.async {
      self.exportDocument(from: controller, context: context)
    }
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  private func exportDocument(from parent: UIViewController, context: Context) {
    // Сохраняем данные во временный файл
    guard let tempURL = writeToTemporaryFile() else {
      completion(false)
      return
    }
    
    // Создаем контроллер для экспорта
    // Используем UIActivityViewController, который предлагает "Сохранить в Файлы"
    let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    
    // Устанавливаем делегат для обработки закрытия
    activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
      // Удаляем временный файл
      try? FileManager.default.removeItem(at: tempURL)
      
      // Сообщаем родительскому представлению, что диалог закрыт
      self.isPresented = false
      self.completion(completed)
    }
    
    // Представляем контроллер
    parent.present(activityVC, animated: true, completion: nil)
  }
  
  private func writeToTemporaryFile() -> URL? {
    do {
      let tempDir = FileManager.default.temporaryDirectory
      let tempURL = tempDir.appendingPathComponent(filename)
      try data.write(to: tempURL)
      return tempURL
    } catch {
      print("Ошибка записи во временный файл: \(error.localizedDescription)")
      return nil
    }
  }
  
  class Coordinator: NSObject {
    var parent: DocumentExporter
    
    init(parent: DocumentExporter) {
      self.parent = parent
    }
  }
}
