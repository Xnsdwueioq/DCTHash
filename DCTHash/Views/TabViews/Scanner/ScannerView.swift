//
//  ScannerView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct ScannerView: View {
  @State private var scanMode: ScanMode = .add
  @State var scannedBarcode: String = "Ожидание сканирования"
  @State var barcodes: [String] = []
  
  var body: some View {
    NavigationStack {
      VStack {
        VStack(spacing: 20) {
          BarcodeScannerView(scannedBarcode: $scannedBarcode)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 350, height: 180)
          Picker(selection: $scanMode, content: {
            ForEach(ScanMode.allCases, id: \.self) { mode in
              Text(mode.rawValue)
            }
          }, label: { })
          .pickerStyle(.palette)
          .padding(.horizontal, 30)
          Label(scannedBarcode, systemImage: "barcode")
        }
        .padding(.vertical, 40)
        
        //TODO? (добавить разбивку штрихкода)
        Spacer()
        Button(action: {
          //TODO (сохранить товар)
        }, label: {
          ZStack {
            Image(systemName: "barcode.viewfinder")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .scaleEffect(0.6)
              .foregroundStyle(scanMode == ScanMode.add ? .green : .red)
              .animation(.easeInOut, value: scanMode)
          }
          .frame(width: 120, height: 80)
        })
        .buttonStyle(.glass)
        .padding(.vertical, 40)
      }
      .navigationTitle("Сканирование")
    }
  }
}

#Preview {
  ScannerView()
}
