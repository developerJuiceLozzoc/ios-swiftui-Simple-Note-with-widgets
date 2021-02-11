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
    var delegate: NoteStore?
    
    var grabText: (()->String)?
    
    
    init(with initialNote: Note?){
        self.note = initialNote
    }
    
    func saveOrCreate() -> Note?{
        guard let delegate = delegate else {return note}
//        let text: String? = grabText?()
//        guard let notecontent = text, notecontent.count > 0 else {return}
        
        guard notecontent.count > 0 else {return note}
        if let editingThis = note {
            delegate.updateNote(with: notecontent, ref: editingThis)
            return note
        }
        else{
            return delegate.addNoteToModel(with: notecontent)
        }
        
    }
}
 
