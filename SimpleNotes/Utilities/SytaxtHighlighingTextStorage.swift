//
//  SytaxtHighlighingTextStorage.swift
//  SimpleNotes
//
//  Created by Conner M on 2/2/21.
//

import UIKit

class SytaxtHighlighingTextStorage: NSTextStorage {

    var tFont: UIFont = UIFont.preferredFont(forTextStyle: .title2)
    var bFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    let backingStore = NSMutableAttributedString()
    var titleFormated: Bool = false
    override var string: String {
      return backingStore.string
    }

    override func attributes(
      at location: Int,
      effectiveRange range: NSRangePointer?
    ) -> [NSAttributedString.Key: Any] {
      return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        
    
      beginEditing()
      backingStore.replaceCharacters(in: range, with:str)
      edited(.editedCharacters, range: range,
             changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
      
    override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        
      beginEditing()
      backingStore.setAttributes(attrs, range: range)
      edited(.editedAttributes, range: range, changeInLength: 0)
      endEditing()
    }
    
    
    func applyStylesToRange(searchRange: NSRange) {
        
        let normAttrs = [NSAttributedString.Key.font: bFont]
        let boldAttributes = [NSAttributedString.Key.font: tFont]
        
        
        if(searchRange.lowerBound > 0 && titleFormated == false) {
            // this means newline
            titleFormated = true
            addAttributes(boldAttributes, range: NSMakeRange(0,searchRange.lowerBound))
            addAttributes(normAttrs, range: NSMakeRange(searchRange.location, 1))
            return
        }
        
    }
    
    
    func performReplacementsForRange(changedRange: NSRange) {
      var extendedRange =
        NSUnionRange(changedRange,
        NSString(string: backingStore.string)
          .lineRange(for: NSMakeRange(changedRange.location, 0)))
      extendedRange =
        NSUnionRange(changedRange,
        NSString(string: backingStore.string)
          .lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
      applyStylesToRange(searchRange: extendedRange)
    }
    
    override func processEditing() {
      performReplacementsForRange(changedRange: editedRange)
      super.processEditing()
    }
    
    
}
