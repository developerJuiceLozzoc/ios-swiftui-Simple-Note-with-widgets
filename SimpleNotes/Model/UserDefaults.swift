//
//  UserDefaults.swift
//  SimpleNotes
//
//  Created by Conner M on 2/3/21.
//

import Foundation
import SwiftUI

let USER_PREF_BODY = "font_style_body"
let USER_PREF_TITLE = "font_style_title"
let USER_PREF_COLOR = "prefferde_bg_color"
let USER_PREF_NOTE_SIZE = "preffered_note_body_size"
let USER_PREF_WIDG_SIZE = "preffered_widget_font_size"


func calculateFont(family: String, size: Int) -> Font{
    guard family != "Default" else {return .body}
    let bFontDescriptor =  UIFontDescriptor().withFamily(family)
    return Font(UIFont(descriptor: bFontDescriptor, size: CGFloat(size)))

}
