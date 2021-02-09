//
//  WrappedNoteEditor.swift
//  SimpleNotes
//
//  Created by Conner M on 2/9/21.
//

import SwiftUI

struct WrappedNoteEditor: View {
    @EnvironmentObject var store: NoteStore
    @Binding var currentItem: Note?
    @Binding var showEditVie: Bool
    @Binding var rntvcDoneClicked: Bool
    @Binding var bgColor: Color
    var findNoteWithID: (String) -> Note?
    var body: some View {
        RichNativeTextViewController(initialNote: $currentItem, isEditing: $showEditVie, doneClicked: $rntvcDoneClicked )
            .edgesIgnoringSafeArea(.all)
        .onDisappear {
            rntvcDoneClicked.toggle()
        }
        .toolbar {
            ToolbarItem(placement: .principal){ () -> Text in
                let d = Date()
                let df = DateFormatter()
                df.dateFormat = "MMMM dd, YYYY  hh:mm at"
                return Text(df.string(from: d)).font(.caption)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    rntvcDoneClicked.toggle()
                }, label: {
                    Text("Done")
                })
            }
        }
        .onOpenURL(perform: { url in
            guard url.scheme == "com.lozzoc.SimpleNotes.SpecificNote" else {return}
            if let host = url.host {
                let note = findNoteWithID(host)
                currentItem = note
                showEditVie = true
            }
        })
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white,bgColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
        .environmentObject(store)
    }
}
