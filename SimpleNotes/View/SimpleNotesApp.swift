//
//  SimpleNotesApp.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import SwiftUI


@main
struct SimpleNotesApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NoteFoldersListView()
                .environmentObject(NoteStore())
        }
    }
    
}
