//
//  TextEditor.swift
//  SimpleNotes
//
//  Created by Conner M on 1/20/21.
//



import SwiftUI
import UIKit
import RichEditorView

struct RichTextEditor: UIViewRepresentable {
    @Binding var text: String
    var initialText: Note?

    typealias UIViewType = RichEditorView

    func makeUIView(context: Context) -> RichEditorView {
        let rev = RichEditorView()
        rev.placeholder = "Start your note with a title!"
        rev.delegate = context.coordinator
        if let note = initialText {
            rev.html = "<h3>\(note.title)</h3>\(note.body)"
        }
        return rev
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
  
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    class Coordinator: NSObject, UINavigationControllerDelegate, RichEditorDelegate ,UITextFieldDelegate {
        let parent: RichTextEditor
        var titleHasBeenMade: Bool = false

        init(_ parent: RichTextEditor){
            self.parent = parent
            
        }
   

        
        func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
            self.parent.text = editor.text
            if !self.titleHasBeenMade && !content.isEmpty {
                let items = editor.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
                guard items.count > 1 else {return}
                editor.html = "<h3>\(items[0].description)</h3>\(items[1].description)"
                self.titleHasBeenMade = true
            }
        }
        
    }
    
}
