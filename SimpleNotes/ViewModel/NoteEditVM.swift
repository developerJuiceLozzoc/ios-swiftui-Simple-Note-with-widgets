//
//  NoteEditVM.swift
//  SimpleNotes
//
//  Created by Conner M on 1/21/21.
//

import SwiftUI


class NoteEditVM {
    var notecontent: String = ""
    var note: Note? = nil
    var titleHasBeenMade: Bool = false
    var delegate: NoteStore!
    
    
    init(with initialNote: Note?){
        self.note = initialNote
    }
    
    func saveOrCreate(){
        if let editingThis = note {
            delegate.updateNote(with: notecontent, ref: editingThis)
        }
        else{
            delegate.addNoteToModel(with: notecontent)
        }
    }
}
    
    
extension NoteEditVM {
    
}
