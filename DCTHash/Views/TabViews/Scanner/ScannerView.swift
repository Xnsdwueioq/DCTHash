//
//  ScannerView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct ScannerView: View {
  @State private var scanMode: ScanMode = .add
  
  var body: some View {
    NavigationStack {
      VStack {
        VStack(spacing: 20) {
          //TODO (заменить на камеру для сканирования)
          RoundedRectangle(cornerRadius: 25)
            .frame(width: 350, height: 150)
          Picker(selection: $scanMode, content: {
            ForEach(ScanMode.allCases, id: \.self) { mode in
              Text(mode.rawValue)
            }
          }, label: { })
          .pickerStyle(.palette)
          .padding(.horizontal, 30)
        }
        .padding(.vertical, 40)
        //TODO? (добавить историю сканирования в рамках сенса)
        Spacer()
        Button(action: {
          //TODO (отсканировать штрихкод)
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
