//
//  FastPreviewWidget.swift
//  SimpleNotes
//
//  Created by Conner M on 2/10/21.
//

import SwiftUI
import WidgetKit

struct FastPreviewWidget: View {
    var titleText: String
    var bodyText: String
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text(titleText)
                    .font(.title2)
                Spacer()
            }
            HStack{
                Text(bodyText)
                    .font(.body)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor(displayP3Red: CGFloat(240.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1)))
    }
}

struct FastPreviewWidget_Previews: PreviewProvider {
    static var previews: some View {
        FastPreviewWidget(titleText: "TasteFul Anime", bodyText: """
                        - Food Wars!
                        - Plunderer
                        - Dorohedoro
                        - My Hero Acedemia
                        - One Punch Man
                        - Cory in the House
                        - Castlevania
                    """).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
