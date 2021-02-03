//
//  NoteStore.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import Foundation
import CoreData
import CloudKit
import SwiftUI

struct dummyStore {
   
}

class NoteStore: ObservableObject {
    

}


extension NoteStore {
    func delete(this selectedNote: Note?){
        guard let note = selectedNote else {return}
        self.objectWillChange.send()
        let context = PersistenceController.shared.container.viewContext
        context.delete(note)
        
        saveContext()

    }
    func loadAllNotesForChoose(completion: @escaping ([Note])->Void){
        let context = PersistenceController.shared.container.viewContext

    
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        print("about to fetch")
        do{
            completion(try context.fetch(request))
        }
        catch{
            print(error.localizedDescription)
            completion([])
        }

        
    }
    func saveNoteWidgetRef(with id: Double, ref noteid: String){
        
    }
    func loadNoteForWidget(ref noteid: String){
        let context = PersistenceController.shared.container.viewContext
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryRefOld!.name!)
        let request: NSFetchRequest<Note> = Note.fetchRequest()

        let requestCK = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
    }

    
    func addNoteToModel(with text: String){
        guard text.count > 0 else {return}
        self.objectWillChange.send()
        let context = PersistenceController.shared.container.viewContext
        
        
        print("adding new note",text)
        
        let items = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        
        let newNote = Note(context: context)
        newNote.id = UUID().uuidString
        newNote.title = items[0].description
        newNote.dateEdited = Date().timeIntervalSince1970
        
        if items.count > 1 { newNote.body = items[1].description }
        else { newNote.body = "" }
        
        saveContext()

    }
    
    func updateNote(with content: String, ref note: Note){
        self.objectWillChange.send()
        
        let items = content.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)        
        note.title = items[0].description
        note.dateEdited = Date().timeIntervalSince1970

        if items.count > 1 {
            note.body = items[1].description
        }
        else {
            note.body = ""
        }
        saveContext()

    }
    
    func saveContext(){
        let context = PersistenceController.shared.container.viewContext

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
