//
//  Untitled.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 08.11.2025.
//

import SwiftUI

struct WelcomeView: View {
  @Environment(AppStateManager.self) var appStateManager: AppStateManager
  
  var body: some View {
    VStack(alignment: .leading) {
      Group {
        Text("Добро пожаловать")
          .font(.system(size: 30))
        Text("в DCTHash")
          .foregroundStyle(.accent)
          .font(.system(size: 40))
      }
      .fontWeight(.heavy)
      Spacer()
      VStack (alignment: .leading, spacing: 30) {
        HStack(alignment: .center, spacing: 20) {
          Image(systemName: "server.rack")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundStyle(.accent)
            .opacity(0.8)
          VStack(alignment: .leading) {
            Text("Склад").font(.headline)
            Text("Ведите учет товаров на складе").font(.subheadline)
          }
        }
        HStack(alignment: .center, spacing: 20) {
          Image(systemName: "barcode")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundStyle(.accent)
            .opacity(0.8)
          VStack (alignment: .leading) {
            Text("Штрихкоды").font(.headline)
            Text("Сканируйте и печатайте").font(.subheadline)
          }
        }
        HStack(alignment: .center, spacing: 20) {
          Image(systemName: "folder.badge.gearshape")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundStyle(.accent)
            .opacity(0.8)
          VStack(alignment: .leading) {
            Text("Терминал сбора данных").font(.headline)
            Text("Система в вашем смартфоне").font(.subheadline)
          }
        }
      }
      Spacer()
      Button(action: {
        appStateManager.closeWelcomeView()
      }, label: {
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .frame(height: 70)
          Text("Продолжить")
            .fontWeight(.bold)
            .foregroundStyle(.white)
        }
      })
    }.padding(.all, 50)
  }
}

#Preview {
  WelcomeView()
    .environment(AppStateManager())
}
