//
//  CreateEditNote.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI
import RealmSwift



struct CreateEditNote: View {
    @EnvironmentObject var store: NoteStore
    @State var notecontent: String = ""
    
    
    var note: Note? = nil
    @Binding var isEditing: Bool
   
    //    @State var notebody: NSAttributedString
    var body: some View {
        VStack(spacing: 0){
//            TextEditor(text: $notebody)
            RichTextEditor(text: $notecontent, initialText: note)
            Spacer()
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
