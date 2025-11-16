//
//  ScannerView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct ScannerView: View {
  @Environment(ProductStorage.self) var storage: ProductStorage
  @State private var scanMode: ScanMode = .add
  @State var barcodes: [String] = []
  @Binding var selectedTab: TabViews
  private var isScannerActive: Bool {
    selectedTab == .scanner
  }
  private var buttonColor: Color {
    if barcodes.isEmpty {
      Color.gray
    } else {
      scanMode == .add ? .green : .red
    }
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        VStack(spacing: 20) {
          BarcodeScannerView(scannedBarcodes: $barcodes, isScanningActive: .constant(isScannerActive))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 350, height: 180)
          Picker(selection: $scanMode, content: {
            ForEach(ScanMode.allCases, id: \.self) { mode in
              Text(mode.rawValue)
            }
          }, label: { })
          .pickerStyle(.palette)
          .padding(.horizontal, 30)
          ScrollView {
            VStack(alignment: .leading, spacing: 5) {
              ForEach(barcodes.reversed(), id:\.self) { barcode in
                HStack(alignment:.center, spacing:10, content: {
                  Image(systemName: "barcode")
                  Text(barcode)
                }).padding(.horizontal, 50)
              }
            }
          }
          .scrollIndicators(.never)
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
        Button(action: {
          switch scanMode {
          case .add:
            storage.addProducts(productsBarcodes: barcodes)
          case .delete:
            storage.deleteProducts(productsBarcodes: barcodes)
          }
          barcodes.removeAll()
        }, label: {
          ZStack {
            Image(systemName: "barcode.viewfinder")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .scaleEffect(0.6)
              .foregroundStyle(buttonColor)
              .animation(.easeInOut, value: scanMode)
          }
          .frame(width: 120, height: 80)
        })
        .disabled(barcodes.isEmpty)
        .padding(.bottom, 40)
        .buttonStyle(.glass)

      }
      .navigationTitle("Сканирование")
    }
  }
}

#Preview {
  ContentView(selectedView: .scanner)
    .environment(AppStateManager())
    .environment(ProductStorage())
}
