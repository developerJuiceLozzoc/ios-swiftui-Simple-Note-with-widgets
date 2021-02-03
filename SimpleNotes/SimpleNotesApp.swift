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
    var font: String
    
    init(){
        guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {
            font = "Arial"
            return
        }
        guard let globalfont: String = defaults.string(forKey: USER_PREF_BODY) else {
            font = "Arial"
            return}
        self.font = globalfont
  
    }

    var body: some Scene {
        WindowGroup {
            ListNoteFolders()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.font, Font.custom(font, fixedSize: 20))
                .environmentObject(NoteStore())
                
        }
    }
    
}
