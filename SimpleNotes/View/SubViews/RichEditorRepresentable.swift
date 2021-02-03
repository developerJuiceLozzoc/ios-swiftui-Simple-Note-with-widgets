//
//  RichEditorRepresentable.swift
//  SimpleNotes
//
//  Created by Conner M on 2/2/21.
//

import UIKit
import SwiftUI

struct RichEditorRepresentable: UIViewRepresentable {
    
    let textStorage = SytaxtHighlighingTextStorage()
    typealias UIViewType = UITextView
    var fontname: String
    var textView: UITextView = UITextView(frame: .zero,textContainer: nil)
    
    var bounds: CGSize
    var delegate: NoteEditVM?

    init(bounds: CGSize, delegate: NoteEditVM?){
        self.bounds = bounds
        self.delegate = delegate
        if let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") {
           if let globalfont: String = defaults.string(forKey: "NOTES_FONT_FAMILY")  {
            fontname = globalfont
            }
            else {
                fontname = "Arial"
            }
        }
        else{
            fontname = "Arial"
        }
        
        self.textView = createTextView()
        self.textStorage.fontDescriptor =  UIFontDescriptor().withFamily(fontname)
        
        if let _ = delegate?.note {
            textStorage.titleFormated = true
        }
        
    }
    
    func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        return
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: RichEditorRepresentable
        
        init(_ parent: RichEditorRepresentable){
            self.parent = parent
        }
        
        
       
    }
    
    
    func createTextView() -> UITextView{
        
        let fontDescriptor = UIFontDescriptor().withFamily(fontname)
        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)
        
        
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 20)
        let normFont = UIFont(descriptor: fontDescriptor, size: 15)
        let normAttrs = [NSAttributedString.Key.font: normFont]
        let boldAttributes = [NSAttributedString.Key.font: boldFont]
        
        let titleT = delegate?.note?.title ?? ""
        let bodyT = delegate?.note?.body ?? ""
        
        let combination = NSMutableAttributedString()

        let attrString = NSAttributedString(string: "\(titleT)\n", attributes: boldAttributes)
        let attrString2 = NSAttributedString(string: "\(bodyT)", attributes: normAttrs)
        if titleT.count > 0 {
            combination.append(attrString)
        }
        combination.append(attrString2)
        textStorage.append(combination)
            
        let newTextViewRect: CGRect = .zero
            
          // 2
          let layoutManager = NSLayoutManager()
            
          // 3
          let containerSize = CGSize(width: newTextViewRect.width,
                                     height: .greatestFiniteMagnitude)
          let container = NSTextContainer(size: containerSize)
          container.widthTracksTextView = true
          layoutManager.addTextContainer(container)
          textStorage.addLayoutManager(layoutManager)
            
          // 4
        var textViewt: UITextView = UITextView(frame: newTextViewRect,textContainer: container)
 

        return textViewt
    }

   

}
