//
//  Storage.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

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
  var storageName: String = "Склад"
  var productTable: [String : [Product]] = [
    "Техника":[],
    "Мебель":[],
    "Медицина":[],
    "Металлы":[],
    "Химия":[],
    "Бумажные изделия":[]
  ]
  
  init(barcodes: [String]) {
    addProducts(productsBarcodes: barcodes)
  }
  init() {
    storageName = UserDefaults.standard.string(forKey: storageNameKey) ?? "Склад"
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
  }
  func deleteAllProducts() {
    for key in productTable.keys {
      productTable[key] = []
    }
  }
}
