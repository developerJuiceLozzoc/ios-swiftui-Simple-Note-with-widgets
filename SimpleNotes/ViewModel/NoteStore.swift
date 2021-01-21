//
//  NoteStore.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import Foundation
import RealmSwift

class NoteStore: ObservableObject {
    var notes: Results<Note>!
    var realm: Realm!
    
    init(){
        do{
            self.realm = try Realm()
            notes = realm.objects(Note.self)
        }
        catch{
            fatalError("Error initiallizing realm: \(error.localizedDescription)")
        }
    }
}


extension NoteStore {
    
    func addNoteToModel(with text: String){
        self.objectWillChange.send()
        
        let items = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        let newNote = Note()
        newNote.title = items[0].description
        newNote.dateEdited = Date().timeIntervalSince1970
        
        if items.count > 1 { newNote.body = items[1].description }
        else { newNote.body = "" }
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(newNote)
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func updateNote(with content: String, ref note: Note){
        self.objectWillChange.send()
        let items = content.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        
        do{
            let realm = try Realm()
            try realm.write {
                note.title = items[0].description
                note.dateEdited = Date().timeIntervalSince1970

                if items.count > 1 {
                    note.body = items[1].description
                }
                else {
                    note.body = ""
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
