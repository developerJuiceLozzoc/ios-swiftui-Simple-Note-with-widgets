//
//  DummyItem.swift
//  SimpleNotes
//
//  Created by Conner M on 1/27/21.
//

import SwiftUI

struct DummyItem: View {
    @Binding var currentItem: Note?
    @Binding var showEditVie: Bool
    @Binding var showNoteModifierSheet: Bool

    var body: some View {
        HStack{
          Text("\("dummy item")")
          Spacer()
          Text("")

      }
      .modifier(TapAndLongPressModifier(tapAction: {
          currentItem = nil
          showEditVie.toggle()
      }, longPressAction: {
          currentItem = nil
          showNoteModifierSheet.toggle()
      }))
    }
}
//
//struct DummyItem_Previews: PreviewProvider {
//    static var previews: some View {
//        DummyItem(currentItem: <#Binding<Note?>#>, showEditVie: <#Binding<Bool>#>, showNoteModifierSheet: <#Binding<Bool>#>)
//    }
//}
