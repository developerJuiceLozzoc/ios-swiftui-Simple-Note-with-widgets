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
    var nativeTextEditor: RichEditorRepresentable!
    @Binding var isEditing: Bool
    
    var u_pref_color: CGColor {
        if let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") {
        
            if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR) as? [CGFloat], components.count == 4 {
                 return ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
            } else {
                return ExtColor.white.cgColor

            }

        }else {
            return ExtColor.white.cgColor
        }
    }
    
    
    var simpleDate: String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "MMMM DD, YYYY  hh:mm at "
        return df.string(from: d)
    }
    
    init(initialNote: Note?, isEditing: Binding<Bool>) {
        thenoteVM = NoteEditVM(with: initialNote)
        nativeTextEditor = RichEditorRepresentable(bounds: UIScreen.main.bounds.size, delegate: thenoteVM)
        nativeTextEditor.textView.layer.cornerRadius = 5
        self._isEditing = isEditing
    }
   
    var body: some View {
    
        nativeTextEditor
            .edgesIgnoringSafeArea(.all)

        .onAppear(perform: {
//            UIToolbar.appearance().barTintColor = ExtColor(cgColor: u_pref_color)
//            UINavigationBar.appearance().backgroundColor =
//            ExtColor(cgColor: u_pref_color)
            thenoteVM.delegate = store
            nativeTextEditor.textView.backgroundColor = ExtColor(cgColor: u_pref_color)

        })
        .onDisappear(perform: {
            if nativeTextEditor.textStorage.backingStore.string.count > 0 {
                thenoteVM.notecontent = nativeTextEditor.textStorage.backingStore.string
                thenoteVM.saveOrCreate()
            }
        })
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("\(simpleDate)").font(.caption)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    nativeTextEditor.textView.resignFirstResponder()
                    if nativeTextEditor.textStorage.backingStore.string.count > 0 {
                        thenoteVM.notecontent = nativeTextEditor.textStorage.backingStore.string
                        thenoteVM.saveOrCreate()
                    }
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
