//
//  CreateEditNote.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI
import RealmSwift
//import



struct CreateEditNote: View {
    @EnvironmentObject var store: NoteStore
    @State var notecontent: String = ""
    var note: Note? = nil
    @Binding var isEditing: Bool
    var simpleDate: String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "MMMM DD, YYYY  mm:hh at "
        return df.string(from: d)
    }
   
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(simpleDate)").font(.caption)
                Spacer()
            }
            RichTextEditor(text: $notecontent, initialText: note)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let editingThis = note {
                        store.updateNote(with: notecontent, ref: editingThis)
                    }
                    else{
                        store.addNoteToModel(with: notecontent)
                    }
                    
                    isEditing.toggle()
                }, label: {
                    Text("Done")
                })
            }
        }
    }
    
    
}

struct CreateEditNote_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            StatefulPreviewWrapper(false) { CreateEditNote(isEditing: $0) }
        }
    }
}
