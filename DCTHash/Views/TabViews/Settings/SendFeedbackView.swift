//
//  SendFeedbackView.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 10.11.2025.
//

import SwiftUI

struct SendFeedbackView: View {
  let displayPhoneNumber = "+7 (950) 402 76-70"
  let callURL = URL(string: "tel://+79504027670")!
  
  var body: some View {
    List {
      Section(content: {
        Text("feedback@DCTHash.com")
      }, header: {
        Text("Отзыв")
      })
      Section(content: {
        Text("business@DCTHash.com")
        Link(displayPhoneNumber, destination: callURL)
      }, header: {
        Text("По вопросам рекламы")
      })
    }
    .navigationTitle("Отправить отзыв")
  }
}

#Preview {
  NavigationStack {
    SendFeedbackView()
  }
}
