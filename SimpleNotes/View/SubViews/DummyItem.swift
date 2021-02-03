//
//  DummyItem.swift
//  SimpleNotes
//
//  Created by Conner M on 1/27/21.
//

import SwiftUI

struct DummyItem: View {
    @State var currentItem: Note? = nil
    @State var showEditVie: Bool = false
    @State  var showNoteModifierSheet: Bool = false

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
struct DummyItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
             DummyItem()
        }
        
    }
}
