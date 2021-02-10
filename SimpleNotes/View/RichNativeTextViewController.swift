//
//  TextViewController.swift
//  SimpleNotes
//
//  Created by Conner M on 2/8/21.
//
import UIKit
import SwiftUI

struct RichNativeTextViewController: UIViewControllerRepresentable {
    @EnvironmentObject var store: NoteStore
    @Binding var isEditing: Bool
    @Binding var initialNote: Note?
    @Binding var doneClicked: Bool
    
    var thenoteVM: NoteEditVM

    
    
    var u_pref_color: CGColor {
        if let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") {
        
            if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR) as? [CGFloat], components.count == 4 {
                return ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
            } else {
                return ExtColor.white.cgColor

            }

        }else {
            return ExtColor.white.cgColor
        }
    }


    init(initialNote: Binding<Note?>, isEditing: Binding<Bool>, doneClicked: Binding<Bool>) {
        thenoteVM = NoteEditVM(with: initialNote.wrappedValue)
        self._isEditing = isEditing
        self._initialNote = initialNote
        self._doneClicked = doneClicked
        thenoteVM.note = initialNote.wrappedValue
        
        
    }
    

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        
        context.coordinator.textview = context.coordinator.createTextView(with: thenoteVM.note)
        thenoteVM.delegate = store

        vc.view.addSubview(context.coordinator.textview)
        context.coordinator.textview.anchor(top: vc.view.safeAreaLayoutGuide.topAnchor,
                        left: vc.view.safeAreaLayoutGuide.leftAnchor,
                         bottom: vc.view.safeAreaLayoutGuide.bottomAnchor,
                         right: vc.view.safeAreaLayoutGuide.rightAnchor)


        context.coordinator.textview.backgroundColor = .red
        thenoteVM.grabText =  {
            print(context.coordinator.textStorage.string)
            return context.coordinator.textStorage.string
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if(doneClicked){
            thenoteVM.notecontent = context.coordinator.textStorage.string
            context.coordinator.textview.resignFirstResponder()
            initialNote = thenoteVM.saveOrCreate()
            doneClicked.toggle()

        }
        else{
            context.coordinator.resetTextStorage()
            
            for v in uiViewController.view.subviews {
                v.removeFromSuperview()
            }
            context.coordinator.textview = context.coordinator.createTextView(with: thenoteVM.note)            
            context.coordinator.textview.backgroundColor = .clear
            
            let gradient =  CAGradientLayer()
            gradient.frame = .zero
            gradient.colors = [UIColor.white.cgColor,  u_pref_color]
            let gview = UIView()
            gview.layer.insertSublayer(gradient,at: 0)
            gview.translatesAutoresizingMaskIntoConstraints = false
            
            thenoteVM.grabText =  {
                print(context.coordinator.textStorage.string)
                return context.coordinator.textStorage.string
            }
            
            
            uiViewController.view.addSubview(gview)
            uiViewController.view.addSubview(context.coordinator.textview)
            let margins = uiViewController.view.layoutMarginsGuide
            gview.anchor(top: margins.topAnchor,
                         left: margins.leftAnchor,
                         bottom: uiViewController.view.bottomAnchor,
                          right: margins.rightAnchor)
            
            
            context.coordinator.textview.anchor(top: uiViewController.view.safeAreaLayoutGuide.topAnchor,
                            left: uiViewController.view.safeAreaLayoutGuide.leftAnchor,
                             bottom: uiViewController.view.safeAreaLayoutGuide.bottomAnchor,
                             right: uiViewController.view.safeAreaLayoutGuide.rightAnchor)
        }
        
        return
    }
    
    typealias UIViewControllerType = UIViewController
    var controllers: [UIViewController] = []

    
    class Coordinator: NSObject{
       
        let parent: RichNativeTextViewController
        var textview: UITextView!
        var textStorage: SytaxtHighlighingTextStorage

        var bodyfont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        var bodyfontSize: CGFloat = 25.0
        var titlefont: UIFont = UIFont.preferredFont(forTextStyle: .title1)
        
        func resetTextStorage(){
            textStorage =  SytaxtHighlighingTextStorage()
            textStorage.bFont = bodyfont
            textStorage.tFont = titlefont
            
            if let _ = parent.initialNote {
                textStorage.titleFormated = true
            }

        }
        
        
        init(_ parent: RichNativeTextViewController) {
            
            textStorage =  SytaxtHighlighingTextStorage()
            self.parent = parent
            
            if let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") {
               
                if let defaultsTitleFontName: String = defaults.string(forKey: USER_PREF_TITLE)  {
                    
                    let tfontDescriptor =  UIFontDescriptor().withFamily(defaultsTitleFontName)
                    if let fromSymbol = tfontDescriptor.withSymbolicTraits(.traitBold){
                        titlefont = UIFont(descriptor: fromSymbol, size: 28)
                        textStorage.tFont = titlefont
                    }

                }
                
                if let defaultsBodyFontSize: Int = defaults.value(forKey: USER_PREF_NOTE_SIZE) as? Int{
                    bodyfontSize = CGFloat(defaultsBodyFontSize)
                }
                
                if let defaultsBodyFontName: String = defaults.string(forKey: USER_PREF_BODY)  {
                      let bfontDescriptor =  UIFontDescriptor().withFamily(defaultsBodyFontName)
                      bodyfont = UIFont(descriptor: bfontDescriptor, size: bodyfontSize)
                     textStorage.bFont = bodyfont
                }
                
            }
        }
        
        
        
        func buildAttributedString(titleT: String, bodyT: String) -> NSMutableAttributedString {
             
            let normAttrs = [NSAttributedString.Key.font: self.bodyfont]
            let boldAttributes = [NSAttributedString.Key.font: self.titlefont]
            let combination = NSMutableAttributedString()
            let attrString = NSAttributedString(string: "\(titleT)\n", attributes: boldAttributes)
            let attrString2 = NSAttributedString(string: "\(bodyT)", attributes: normAttrs)
            
            if titleT.count == 0 {
              let defaultAttr =  NSAttributedString(string: " ", attributes: normAttrs)
                combination.append(defaultAttr)

            }
            else{
                if titleT.count > 0 {
                    combination.append(attrString)
                }
                combination.append(attrString2)
                
            }
            
            
            
            return combination
        }
        
        
        func createTextView(with note: Note?) -> UITextView{
            

            let attstring = buildAttributedString(
                                titleT: note?.title ?? "",
                                bodyT: note?.body ?? ""
                            )
            textStorage.append(attstring)
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
            let textViewt: UITextView = UITextView(frame: newTextViewRect,textContainer: container)
            textViewt.translatesAutoresizingMaskIntoConstraints = false
            
            
            if let _ = note {
                textStorage.titleFormated = true
            }
            return textViewt
        }
        
    }
}


