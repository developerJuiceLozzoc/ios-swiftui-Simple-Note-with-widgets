//
//  LongPress.swift
//  SimpleNotes
//
//  Created by Conner M on 1/21/21.
//

import SwiftUI


struct TapAndLongPressModifier: ViewModifier {
  @State private var isLongPressing = false
    @State private var amounts: CGFloat = 0
  let tapAction: (()->())
  let longPressAction: (()->())
  func body(content: Content) -> some View {
    content
      .scaleEffect(isLongPressing ? 0.95 : 1.0)
        .blur(radius: (1 - CGFloat(isLongPressing ? 0.5 : 1)) * 20)
        .onLongPressGesture(minimumDuration: 0.45, pressing: { (isPressing) in
        withAnimation {
          isLongPressing = isPressing
        }
      }, perform: {
        longPressAction()
      })
      .simultaneousGesture(
        TapGesture()
          .onEnded { _ in
            tapAction()
          }
      )
  }
}
