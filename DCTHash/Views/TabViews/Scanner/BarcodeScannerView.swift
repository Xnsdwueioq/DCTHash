//
//  BarcodeScannerView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 09.11.2025.
//

import SwiftUI
import VisionKit

// Обертка для DataScannerViewController
struct BarcodeScannerView: UIViewControllerRepresentable {
  // Состояние для хранения результата сканирования
  @Binding var scannedBarcode: String
  
  // Типы данных для сканирования
  let recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType> = [.barcode()]
  
  func makeUIViewController(context: Context) -> DataScannerViewController {
    // Создание контроллера сканера
    let scannerViewController = DataScannerViewController(
      recognizedDataTypes: recognizedDataTypes,
      qualityLevel: .fast,
      recognizesMultipleItems: false,
      isHighlightingEnabled: true
    )
    
    // Установка координатора как делегата для обработки событий сканирования
    scannerViewController.delegate = context.coordinator
    
    // Запуск сканирования
    try? scannerViewController.startScanning()
    
    return scannerViewController
  }
  
  func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
    // Обновление контроллера при изменении состояния SwiftUI
  }
  
  // Создание Координатора
  func makeCoordinator() -> Coordinator {
    Coordinator(scannedBarcode: $scannedBarcode)
  }
  
  class Coordinator: NSObject, DataScannerViewControllerDelegate {
    @Binding var scannedBarcode: String
    
    init(scannedBarcode: Binding<String>) {
      _scannedBarcode = scannedBarcode
    }
    
    // Обработка найденных объектов
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
      switch item {
      case .barcode(let barcode):
        // Если найден штрих-код, обновляем связанную переменную
        if let payload = barcode.payloadStringValue {
          scannedBarcode = payload
          // Остановка сканирования после успешного считывания (опционально)
          // dataScanner.stopScanning()
        }
      default:
        // Игнорируем другие типы найденных объектов
        break
      }
    }
  }
}
