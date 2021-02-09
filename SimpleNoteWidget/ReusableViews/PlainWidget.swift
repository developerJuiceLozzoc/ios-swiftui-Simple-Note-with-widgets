//
//  PlainWidget.swift
//  SimpleNotes
//
//  Created by Conner M on 2/5/21.
//

import SwiftUI




struct PlainWidget: View {
    var titleText: String
    var bodyText: String
    var bodyFont: UIFont
    var titleFont: UIFont
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text(titleText)
                    .font(Font(titleFont))
                    .padding(.leading)
                Spacer()
            }
            HStack{
                Text(bodyText)
                    .font(Font(bodyFont))
                    .padding(.leading)
                Spacer()
            }
            Spacer()
        }
    }
}
