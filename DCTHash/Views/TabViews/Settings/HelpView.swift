//
//  HelpView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 10.11.2025.
//

import SwiftUI

struct HelpView: View {
  var body: some View {
    ScrollView {
      VStack (spacing: 60) {
        VStack {
          Image("tabviews")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
          Text("Мгновенно перемещайтесь между экранами")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("1.\tСканируйте штрихкоды, удаляя или добавляя новые товары\n2.\tПросматривайте товары на вашем складе\n3.\tНастройки вашего приложения")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        VStack {
          Image("scannerview")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
          Text("Добавляйте или удаляйте товар со склада")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("4.\tНажмите на распознанный штрихкод чтобы сохранить штрихкод\n5.\tПереключайте режимы работы\n6.\tНажмите, чтобы сохранить, или удалить отсканированные товары")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        VStack {
          Image("navlink")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
          Text("Настройка товара")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("7.\tМеняйте количество прямо из карточки\n8.\tНажмите на карточку чтобы перейти к штрихкоду")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        VStack {
          Image("barcode")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
          Text("Штрихкод")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("9.\tЗажмите штрихкод чтобы вызвать контекстное меню\n10.\tНажмите \"Отправить\" для экспорта изображения")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        VStack {
          Image("searchexport")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
          Text("Поиск и экспорт")
            .font(.callout)
            .foregroundStyle(.gray)
          Text("11.\tНажмите чтобы выполнить поиск по всем товарам на складе\n12.\tНажмите чтобы выполнить экспорт данных в JSON файл")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
      }.padding(20)
        .navigationTitle("Справка")
    }.scrollIndicators(.never)
  }
}

#Preview {
  NavigationStack {
    HelpView()
  }
}
