//
//  Storage.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI

struct Product: Identifiable, Codable {
  var name: String
  let barcode: String
  var quantity: Int
  
//  var id: String = { barcode }
  var id: UUID = UUID()
  
  init(name: String, barcode: String, quantity: Int = 0) {
    self.name = name
    self.barcode = barcode
    self.quantity = quantity
  }
}
class Storage {
}
