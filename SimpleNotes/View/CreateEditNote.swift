//
//  CreateEditNote.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI

var initalsring = """

 this is a very long string
intenedd to take up multiple lines and also have
manually
inserted line breaks to wrap around the phone screen.
"""

struct CreateEditNote: View {
    @EnvironmentObject var store: NoteStore
    var thenoteVM: NoteEditVM!
    
    var nativeTE: RichEditorRepresentable!
    @Binding var isEditing: Bool
    
    
    var simpleDate: String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "MMMM DD, YYYY  hh:mm at "
        return df.string(from: d)
    }
    
    init(initialNote: Note?, isEditing: Binding<Bool>) {
        thenoteVM = NoteEditVM(with: initialNote)
        nativeTE = RichEditorRepresentable(bounds: UIScreen.main.bounds.size, delegate: thenoteVM)
        self._isEditing = isEditing
    }
   
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(simpleDate)").font(.caption)
                Spacer()
            }.padding()
            nativeTE

            Spacer()
            
        }
        .onAppear(perform: {
            thenoteVM.delegate = store
        })
        .onDisappear(perform: {
            if nativeTE.textStorage.backingStore.string.count > 0 {
                thenoteVM.notecontent = nativeTE.textStorage.backingStore.string
                thenoteVM.saveOrCreate()
            }
        })
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print(thenoteVM.notecontent)

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
            StatefulPreviewWrapper(false) { CreateEditNote(initialNote: nil, isEditing: $0)
                .environmentObject(NoteStore())

            }
        }
    }
}
