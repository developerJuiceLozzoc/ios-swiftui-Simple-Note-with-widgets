//
//  ContentView.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI
import CoreData


struct ListNoteFolders: View {
    @EnvironmentObject var store: NoteStore
    @State var showEditVie: Bool = false
    @State var showNoteModifierSheet: Bool = false
    @State var currentItem: Note?
    @State var showUserPreferences: Bool = false
    @State var rntvcDoneClicked: Bool = false
    @State var bgColor: Color = .white
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [])
    var notes: FetchedResults<Note>

    
var body: some View {
    NavigationView{
        List{
//            DummyItem()
            ForEach(notes) { item in
                    HStack{
                        Text("\(item.title ?? "OOPS, NO TITLE")")
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
        .onAppear {
            bgColor = getBackgroundColor()
        }

//MARK: Navigation View stuff
        
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
                    WrappedNoteEditor(currentItem: $currentItem,
                                      showEditVie: $showEditVie,
                                      rntvcDoneClicked: $rntvcDoneClicked,
                                      bgColor: $bgColor,
                                      findNoteWithID: { id in
                                        return notes.first {
                                            return $0.id == id
                                        }
                                      }
                ),
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
            
            
                /* some devices do not have bottom toolbar*/

            }

    //MARK: - View LifeCycle
    }
    //MARK: OnOpenUrl
    .onOpenURL(perform: { url in
        guard url.scheme == "com.lozzoc.SimpleNotes.SpecificNote" else {return}
        
        if let host = url.host {
            let note = notes.first { (el) -> Bool in
                return el.id == host
            }
            currentItem = note
            showEditVie = true
        }
    })
    //MARK: onAppear
    //MARK: OnDisappear
    .onDisappear(perform: {
        currentItem = nil
    })
    
}

}

func getBackgroundColor() -> Color {
    guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return Color.white}
    var color: CGColor = Color.white.cgColor!
    if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR ) as? [CGFloat], components.count == 4 {
        color = ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
   }
   return Color(color)
    
}


struct ListNoteFolders_Previews: PreviewProvider {

    static var previews: some View {
     
       
            ListNoteFolders()
                  .environmentObject(NoteStore())

    }
}
