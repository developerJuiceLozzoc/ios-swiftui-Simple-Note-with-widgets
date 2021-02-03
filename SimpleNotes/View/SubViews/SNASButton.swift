//
//  NoteLongPressAction.swift
//  SimpleNotes
//
//  Created by Conner M on 1/25/21.
//

import SwiftUI
struct SNASButton: View {
    var image: String
    var text: String
    var body: some View {
        HStack{
            Image(systemName: image)
            Spacer()
            Text(text)
        }
    }
}


