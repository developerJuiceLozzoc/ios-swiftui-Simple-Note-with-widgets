//
//  ContentView.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI
import CoreData

var testNote1: Note {
    let n = Note()
    n.body = "Tacocats"
    n.title = "Title 1"
    return n
}
var testNote2: Note {
    let n = Note()
    n.body = "Tacocats"
    n.title = "Title 2"
    return n
}


struct ListNoteFolders: View {
    @EnvironmentObject var store: NoteStore
    @Binding var deepLink: String?
    @State var showEditVie: Bool = false
    @State var showNoteModifierSheet: Bool = false
    @State var currentItem: Note?
    @State var showUserPreferences: Bool = false
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [])
    var notes: FetchedResults<Note>

    
var body: some View {
    NavigationView{
        List{
//            DummyItem()
            ForEach(notes) { item in
                    HStack{
                        Text("\(item.title!)").font(.body)
                        Spacer()
                        Text("")
                        
                    }
                    .modifier(TapAndLongPressModifier(tapAction: {
                        currentItem = item
                        showEditVie.toggle()
                    }, longPressAction: {
                        currentItem = item
                        showNoteModifierSheet.toggle()
                    }))
        }

        }
        
//MARK: -  action sheet
        .actionSheet(isPresented: $showNoteModifierSheet, content: {
ActionSheet(title: Text(""), message: nil,
    buttons: [
        ActionSheet.Button.default(Text("📤 Share")),
        .destructive(Text("  🗑 Delete "),action: {
            store.delete(this: currentItem)
        }),
        .cancel()
    ])
        })
        .background(
               NavigationLink(
                destination:
                    CreateEditNote(initialNote: currentItem, isEditing: $showEditVie).environmentObject(store),
                isActive: $showEditVie) {
                 EmptyView()
               }
        )
        //MARK:  - Toolbar
        .toolbar {
            //MARK: title
                ToolbarItem(placement: .principal) {
                    VStack{
                        Text("Notes")
                            .font(.title)
                        Text("Great for making lists")
                            .font(.footnote)
                    }
                }
            //MARK: options - userdefaults
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(
                     destination:
                        UserPreferences(),
                     isActive: $showUserPreferences) {
                        Button(action: {}){
                            HStack{
                                Image(systemName: "gearshape.fill")
                            }
                        }
                    }
                    
                }
                
            //MARK: left bottom item
                ToolbarItem(placement: .bottomBar) {
                    Text("\(notes.count) Notes")
                }
            //MARK: right bottom item plus
                ToolbarItem(placement: .bottomBar){
                
                    Button(action: {
                        currentItem = nil
                        showEditVie.toggle()
                        
                    }, label: {
                            HStack{
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .aspectRatio(1.5, contentMode: .fill)
                                Text("")
                            }
                        })
                    
                }

            }
    //MARK: - View LifeCycle
    }.onAppear(perform: {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        if let noteid = deepLink {
            let note = notes.first { (el) -> Bool in
                return el.id == noteid
            }
            currentItem = note
            showEditVie = true
        }
        
    })
    .onDisappear(perform: {
        deepLink = nil
        currentItem = nil
    })
    
}

}


struct ListNoteFolders_Previews: PreviewProvider {

    static var previews: some View {
     
        StatefulPreviewWrapper("") {
            ListNoteFolders( deepLink:  $0)
                  .environmentObject(NoteStore())
        }
    }
}
