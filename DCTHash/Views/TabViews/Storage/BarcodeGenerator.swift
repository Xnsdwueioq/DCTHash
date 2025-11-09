//
//  ContentView.swift
//  BarcodeGenerator
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI
import CoreImage
import UIKit

struct BarcodeGeneratorView: View {
  private let categoryMapReversed: [String: String] = [
    "Техника": "1",
    "Мебель": "2",
    "Медицина": "3",
    "Металлы": "4",
    "Химия": "5",
    "Бумажные изделия": "6"
  ]
  let product: Product
  var barcodeString: String {
    "\(product.name)$\(product.amount)\(categoryMapReversed[product.category]!)"
  }
  @State private var generatedBarcodeImage: UIImage? = nil
  @State private var showingShareSheet: Bool = false
  
  var body: some View {
    VStack(spacing: 20) {
      // Отображение штрихкода, если он сгенерирован
      if let image = generatedBarcodeImage {
        Image(uiImage: image)
          .resizable()
          .interpolation(.none) // Чтобы избежать сглаживания пикселей
          .scaledToFit()
          .frame(width: 300, height: 150)
          .padding()
          .background(Color.white)
          .contextMenu { // Добавляем контекстное меню
            ShareLink(item: Image(uiImage: image), preview: SharePreview("Штрихкод", image: Image(uiImage: image))) {
              Label("Отправить", systemImage: "square.and.arrow.up")
            }
          }
      }
    }
    .onAppear(perform: {
      generatedBarcodeImage = generateBarcode(from: barcodeString)
    })
    .navigationTitle("Печать")
  }
  
  // Функция генерации штрихкода
  func generateBarcode(from string: String) -> UIImage? {
    guard let data = string.data(using: .ascii) else { return nil }
    guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
    
    filter.setValue(data, forKey: "inputMessage")
    
    guard let ciImage = filter.outputImage else { return nil }
    
    let scaleX: CGFloat = 8.0
    let scaleY: CGFloat = 8.0
    let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    
    let context = CIContext()
    guard let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) else { return nil }
    
    return UIImage(cgImage: cgImage)
  }
}

#Preview {
  NavigationView {
    BarcodeGeneratorView(product: Product(name: "123$22", amount: 10, category: "Furniture"))
  }
}
