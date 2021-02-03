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
    
    var bodyfont: UIFont?
    var titlefont: UIFont?
    
    
    var textView: UITextView = UITextView(frame: .zero,textContainer: nil)
    
    var bounds: CGSize
    var delegate: NoteEditVM?

    init(bounds: CGSize, delegate: NoteEditVM?){
        self.bounds = bounds
        self.delegate = delegate

        if let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") {
           if let bfont: String = defaults.string(forKey: USER_PREF_BODY)  {
                self.textStorage.bfontDescriptor =  UIFontDescriptor().withFamily(bfont)
                if let bDescriptor = self.textStorage.bfontDescriptor {
                    bodyfont = UIFont(descriptor: bDescriptor, size: 25)
                    print("body in the init")
                }
           }
            if let tfont: String = defaults.string(forKey: USER_PREF_TITLE)  {
                self.textStorage.tfontDescriptor =  UIFontDescriptor().withFamily(tfont)
                if let ftd = self.textStorage.tfontDescriptor {
                    self.titlefont = UIFont(descriptor: ftd, size: 32)
                    print("title in the init")

                }
            }
        }
        
        self.textView = createTextView()


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
        var titleFont: UIFont
        var normFont: UIFont
        
        normFont = UIFont.preferredFont(forTextStyle: .body)
        titleFont = UIFont.preferredFont(forTextStyle: .title2)
        
        
        if let bodyfont = self.bodyfont {
            normFont = bodyfont
        }
        if let titlefont = self.titlefont{
            titleFont = titlefont
        }
        
        let normAttrs = [NSAttributedString.Key.font: normFont]
        let boldAttributes = [NSAttributedString.Key.font: titleFont]
        
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
//        textViewt.translatesAutoresizingMaskIntoConstraints = false
//        textViewt.leadingAnchor.constraint(equalTo: safe)

        return textViewt
    }

   

}
