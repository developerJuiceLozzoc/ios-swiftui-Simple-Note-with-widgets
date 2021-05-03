//
//  IntentHandler.swift
//  DynamicNotesList
//
//  Created by Conner M on 1/27/21.
//

import Intents


class IntentHandler: INExtension, NoteConfigurationIntentHandling {
    

    // for the intent listed in the widget folder SimpleNoteWidget
    // using coredata here to load the information async, could also be userdefaults or a network request.
    func provideShortNoteInfoOptionsCollection(for intent: NoteConfigurationIntent, with completion: @escaping (INObjectCollection<NoteForWidget>?, Error?) -> Void) {
        let tempStore = NoteStore()
        tempStore.loadAllNotesForChoose { results in
            
            let notes: [NoteForWidget] = results.map { (el) in

                let note = NoteForWidget(identifier: el.id, display: el.title ?? "Empty Title")
                note.body = el.body ?? "Empty Body"
                note.date = NSNumber(value: el.dateEdited)
                return note
            }
            let collection = INObjectCollection(items: notes)
            completion(collection,nil)
        }
        
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
