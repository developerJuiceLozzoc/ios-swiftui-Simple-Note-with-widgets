//
//  SytaxtHighlighingTextStorage.swift
//  SimpleNotes
//
//  Created by Conner M on 2/2/21.
//

import UIKit

class SytaxtHighlighingTextStorage: NSTextStorage {
    var tfontDescriptor: UIFontDescriptor?
    var bfontDescriptor: UIFontDescriptor?
    
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
        
        var titleFont: UIFont
        var normFont: UIFont

        if let tDescriptor = self.tfontDescriptor {
            guard let fromSymbol = tDescriptor.withSymbolicTraits(.traitBold) else { return}
            titleFont = UIFont(descriptor: fromSymbol, size: 32)
        }
        else {
            titleFont = UIFont.preferredFont(forTextStyle: .title2)
        }
        
        if let bDescriptor = self.bfontDescriptor {
            normFont = UIFont(descriptor: bDescriptor, size: 25)
        }
        else {
            normFont = UIFont.preferredFont(forTextStyle: .body)
        }
        
        let normAttrs = [NSAttributedString.Key.font: normFont]
        let boldAttributes = [NSAttributedString.Key.font: titleFont]
     
        if(searchRange.lowerBound > 0 && titleFormated == false) {
            // this means newline
            titleFormated = true
            addAttributes(boldAttributes, range: NSMakeRange(0,searchRange.lowerBound))
            addAttributes(normAttrs, range: NSMakeRange(searchRange.location, 1))
            return
        }
        /*
      // 2
      let regexStr = "(/^(.*)$/m)"
      let regex = try! NSRegularExpression(pattern: regexStr)

      // 3
        
    
      regex.enumerateMatches(in: backingStore.string, range: searchRange) {
        match, flags, stop in
        
        if let matchRange = match?.range(at: 1) {
          addAttributes(boldAttributes, range: matchRange)
            
          print(matchRange)
          let maxRange = matchRange.location + matchRange.length
          if maxRange + 1 < length {
            addAttributes(normalAttributes, range: NSMakeRange(maxRange, 1))
          }
        }
      }
        */
        
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
