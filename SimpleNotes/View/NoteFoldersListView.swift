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
let dummy = [
    testNote1,
    testNote2
]


struct NoteFoldersListView: View {
    @EnvironmentObject var store: NoteStore
    @State var showNew: Bool = false
    
var body: some View {
    NavigationView{
//        ScrollView(showsIndicators: false){
        List{
            ForEach(dummy) { item in
                NavigationLink(
                    destination:
                        CreateEditNote( note: item, isEditing: $showNew),
                    label: {
                        Text("\(item.title)")
                    })
            }
        }
        .background(
               NavigationLink(
                destination:
                    CreateEditNote(isEditing: $showNew),
                isActive: $showNew) {
                 EmptyView()
               }
        )
        .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack{
                        Text("Notes")
                            .font(.title)
                        Text("Great for making lists")
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {}){
                        HStack{
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
                
                
                ToolbarItem(placement: .bottomBar) {
                    Text("1 Notes")
                }
                ToolbarItem(placement: .bottomBar){
                
                    Button(action: {showNew.toggle()}, label: {
                            HStack{
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .aspectRatio(1.5, contentMode: .fill)
                                Text("")
                            }
                        })
                    
                }

            }
            // end toolbar
    }.onAppear(perform: {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

    })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteFoldersListView()
            .environmentObject(NoteStore())
    }
}
