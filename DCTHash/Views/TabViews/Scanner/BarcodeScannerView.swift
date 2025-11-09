import SwiftUI
import VisionKit

// Обертка для DataScannerViewController
struct BarcodeScannerView: UIViewControllerRepresentable {
    // ... (Остальные привязки)
    @Binding var scannedBarcodes: [String] // Предполагая, что вы используете массив из предыдущего ответа
    
    // НОВАЯ ПРИВЯЗКА: Управляет состоянием активности сканера
    @Binding var isScanningActive: Bool
    
    let recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType> = [.barcode()]
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scannerViewController = DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighlightingEnabled: true
        )
        
        scannerViewController.delegate = context.coordinator
        
        // В makeUIViewController НЕ ЗАПУСКАЕМ сканирование
        // Его запустит updateUIViewController
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: Управляем состоянием сканирования
        if isScanningActive {
            // Пытаемся запустить сканирование, если оно активно
            try? uiViewController.startScanning()
        } else {
            // Останавливаем сканирование, когда вкладка не активна
            uiViewController.stopScanning()
        }
    }
    
    // Создание Координатора
    func makeCoordinator() -> Coordinator {
        Coordinator(scannedBarcodes: $scannedBarcodes)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var scannedBarcodes: [String]
        
        init(scannedBarcodes: Binding<[String]>) {
            _scannedBarcodes = scannedBarcodes
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                if let payload = barcode.payloadStringValue {
                    scannedBarcodes.append(payload)
                }
            default:
                break
            }
        }
    }
}
