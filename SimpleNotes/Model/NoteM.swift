//
//  Note.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import Foundation
import RealmSwift


class Folder: Object {
    @objc dynamic var name: String = ""
    let notes = List<Note>()
}



class Note: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var body: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var dateEdited: Double = 0.0
    var parentFolder = LinkingObjects(fromType: Folder.self, property: "notes")
}

