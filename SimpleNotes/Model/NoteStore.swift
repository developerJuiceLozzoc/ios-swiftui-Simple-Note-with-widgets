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
    func fetchNoteDetail(id: String) -> Note? {
        let context = PersistenceController.shared.container.viewContext

    
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "id MATCHES %@", id)

        request.predicate = predicate
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                return results[0]
            }
            else {
                return nil
            }
        }
        catch{
            print(error.localizedDescription)
            return nil
        }

        
    }
    func saveNoteWidgetRef(with id: Double, ref noteid: String){
        
    }


    
    func addNoteToModel(with text: String) -> Note?{
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedString.count > 0 else {return nil}
        self.objectWillChange.send()
        let context = PersistenceController.shared.container.viewContext
        
            
        let items = trimmedString.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        
        let newNote = Note(context: context)
        newNote.id = UUID().uuidString
        newNote.title = items[0].description
        newNote.dateEdited = Date().timeIntervalSince1970
        
        if items.count > 1 { newNote.body = items[1].description }
        else { newNote.body = "" }
        
        saveContext()
        return newNote

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
