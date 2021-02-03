//
//  SimpleNotesApp.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI


@main
struct SimpleNotesApp: App {
    let persistenceController = PersistenceController.shared
    @State var deepLinkNote: String? = nil
    var font: String
    
    init(){
        guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {
            font = "Arial"
            return
        }
        guard let globalfont: String = defaults.string(forKey: "NOTES_FONT_FAMILY") else {
            font = "Arial"
            return}
        self.font = globalfont
  
    }

    var body: some Scene {
        WindowGroup {
            ListNoteFolders(deepLink: $deepLinkNote)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.font, Font.custom(font, fixedSize: 20))
                .environmentObject(NoteStore())
                .onOpenURL(perform: { url in
                    guard url.scheme == "com.lozzoc.SimpleNotes.SpecificNote" else {return}
                    print(url.host!)
                    print(url)
                    print(url.path)

                    deepLinkNote = nil
                })
        }
    }
    
}
