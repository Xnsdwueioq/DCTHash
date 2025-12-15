//
//  Storage.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

// основная структура - товар
struct Product: Identifiable, Hashable, Codable {
  var id: UUID = UUID()
  let name: String
  var amount: Int
  let category: String
  
  // для штрих-кода, соответствие код-категория
  private static let categoryMap: [String: String] = [
    "1": "Техника",
    "2": "Мебель",
    "3": "Медицина",
    "4": "Металлы",
    "5": "Химия",
    "6": "Бумажные изделия"
  ]
  
  // ключи для персистентности
  enum CodingKeys: String, CodingKey {
    case name
    case amount
    case category
  }
  
  // конструктор параметрический (принимает штрихкод)
  init?(barcode: String) {
    // разделяет строку на субстроки по $
    var barcode = barcode.trimmingCharacters(in: .whitespacesAndNewlines)
    let components = barcode.split(separator: "$")
    guard components.count == 2 else {
      return nil
    }
    
    let parsedName = String(components[0])
    let dataPart = components[1]
    
    // отбрасывает последний символ, определяет категорию по нему
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
  
  // конструктор параметрический
  init(name: String, amount: Int, category: String) {
    self.name = name
    self.amount = amount
    self.category = category
  }

  // конструктор для декодирования из Data
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.amount = try container.decode(Int.self, forKey: .amount)
    self.category = try container.decode(String.self, forKey: .category)
    self.id = UUID()
  }
  
  // функция для кодирования в Data
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.amount, forKey: .amount)
    try container.encode(self.category, forKey: .category)
  }
  
}

// класс для храния
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
  
  // удаляет товар
  func removeProduct(_ product: Product) {
      guard var items = productTable[product.category] else { return }
      
      if let index = items.firstIndex(where: { $0.id == product.id }) {
          items.remove(at: index)
          
          productTable[product.category] = items
          saveProductTable()
      }
  }
  
  // вычисляемое свойство с url ссылкой на файл
  private var dataFileURL: URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    print(urls)
    return urls[0].appendingPathComponent(productTableFilename)
  }
  
  // конструктор параметрический принимающий список штрихкодов
  init(barcodes: [String]) {
    addProducts(productsBarcodes: barcodes)
  }
  
  // конструктор по умолчанию
  init() {
    storageName = UserDefaults.standard.string(forKey: storageNameKey) ?? "Склад"
    loadProductTable()
  }
  
  // загружает таблицу из файла
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
  
  // перегрузка
  func loadProductTable(from data: Data) throws {
      do {
          let loadedTable = try JSONDecoder().decode([String : [Product]].self, from: data)

          self.productTable = loadedTable
          
          let initialKeys = ["Техника", "Мебель", "Медицина", "Металлы", "Химия", "Бумажные изделия"]
          for key in initialKeys where productTable[key] == nil {
              productTable[key] = []
          }
          
          saveProductTable()
      } catch {
          throw error
      }
  }
  
  // сохранение таблицы в файл
  private func saveProductTable() {
    do {
      let encodedData = try JSONEncoder().encode(productTable)
      try encodedData.write(to: dataFileURL)
    } catch {
      print("Ошибка сохранения данных: \(error.localizedDescription)")
    }
  }

  // функция смены имени склада
  func changeStorageName(_ newName: String) {
    storageName = newName
    UserDefaults.standard.set(newName, forKey: storageNameKey)
  }
  
  // функция для Stepper, реактивно меняет размер
  func stepperSet(category: String, productName: String, newAmount: Int) {
    if var products = productTable[category] {
      if let index = products.firstIndex(where: {$0.name == productName}) {
        products[index].amount = newAmount
        productTable[category] = products
        saveProductTable()
      }
    }
  }
  
  // добавление товаров, принимает список штрихкодов
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
  
  // удаляет товары, принимает список штрихкодов
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
  
  // удаляет все товары на складе
  func deleteAllProducts() {
    for key in productTable.keys {
      productTable[key] = []
    }
    saveProductTable()
  }
  
  // возвращает сырой поток байтов
  func getJSONData() throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return try encoder.encode(self.productTable)
  }
}

// тип файла в нотации UTType
let jsonUTType = UTType(filenameExtension: "json", conformingTo: .data)!

// структура для экспорта в JSON
struct DocumentExporter: UIViewControllerRepresentable {
  // данные, которые мы хотим сохранить (в формате Data)
  let data: Data
  let filename: String
  
  @Binding var isPresented: Bool
  var completion: (Bool) -> Void // callback для обработки результата
  
  func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    
    // запускаем экспорт, как только View появляется
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
    // сохраняем данные во временный файл
    guard let tempURL = writeToTemporaryFile() else {
      completion(false)
      return
    }
    
    // создаем контроллер для экспорта
    // используем UIActivityViewController, который предлагает "Сохранить в Файлы"
    let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    
    // устанавливаем делегат для обработки закрытия
    activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
      // удаляем временный файл
      try? FileManager.default.removeItem(at: tempURL)
      
      // сообщаем родительскому представлению, что диалог закрыт
      self.isPresented = false
      self.completion(completed)
    }
    
    // представляем контроллер
    parent.present(activityVC, animated: true, completion: nil)
  }
  
  // функция записи в файл
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

// структура для импорта JSON
struct DocumentImporter: UIViewControllerRepresentable {
    static let readableContentTypes: [UTType] = [jsonUTType]

    @Binding var isPresented: Bool
    var completion: (Result<Data, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: DocumentImporter.readableContentTypes, asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentImporter

        init(parent: DocumentImporter) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.isPresented = false

            guard let url = urls.first else {
                return
            }

            let success = url.startAccessingSecurityScopedResource()
            do {
                let data = try Data(contentsOf: url)
                parent.completion(.success(data))
            } catch {
                parent.completion(.failure(error))
            }

            if success {
                url.stopAccessingSecurityScopedResource()
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}
