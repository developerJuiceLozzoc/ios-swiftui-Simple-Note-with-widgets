//
//  Optimized4ListWidget.swift
//  SimpleNotes
//
//  Created by Conner M on 2/5/21.
//

import SwiftUI

struct Optimized4ListWidget: View {
    var titleText: String
    var bodyList1: [String]
    var bodyList2: [String]
    var bodyFont: UIFont
    var titleFont: UIFont
    
    var body: some View {
        VStack{
            Text(titleText)
            HStack{
                VStack(alignment: .leading) {
                    ForEach(0 ..< bodyList1.count) { i in
                        Text(bodyList1[i])
                            .multilineTextAlignment(.leading)
                            .font(Font(bodyFont))
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(0 ..< bodyList2.count) { i in
                        Text(bodyList2[i])
                            .multilineTextAlignment(.leading)
                            .font(Font(bodyFont))
                    }
                    Spacer()
                }
            }.padding()
            Spacer()
        }
        
        // end hstack
        
    }
}
