//
//  LaunchScreenStateManager.swift
//  DCTHash
//
//  Created by Eyhciurmrn Zmpodackrl on 10.11.2025.
//

import SwiftUI

@Observable
final class LaunchScreenStateManager {
  private(set) var isActive: Bool = true
  
  func dismiss() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
      withAnimation(.easeInOut(duration: 1)) {
        self.isActive = false
      }
    })
  }
}

struct AnimatedLaunchView: View {
  @Environment(LaunchScreenStateManager.self) var manager: LaunchScreenStateManager
  @State var textColor: Color = .accent

  var body: some View {
    ZStack {
      Color.accent.edgesIgnoringSafeArea(.all)
      Text("DCTHash")
        .foregroundStyle(textColor)
        .font(.largeTitle)
        .fontWeight(.heavy)
        .onAppear {
          withAnimation(.easeInOut(duration: 1.5)) {
            textColor = Color.white
          }
          manager.dismiss()
        }
    }
  }
}


#Preview {
  AnimatedLaunchView()
    .environment(LaunchScreenStateManager())
}
