//
//  PlainWidget.swift
//  SimpleNotes
//
//  Created by Conner M on 2/5/21.
//

import SwiftUI
import WidgetKit



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
            }.padding()
            Spacer()
        }
    }
}


struct PlainWidget_Previews: PreviewProvider {
    static var previews: some View {
        PlainWidget(
            titleText: "TasteFul Anime",
            bodyText: """
                            - Food Wars!
                            - Plunderer
                            - Dorohedoro
                            - My Hero Acedemia
                            - One Punch Man
                            - Cory in the House
                            - Castlevania
                        """,
            bodyFont: UIFont.preferredFont(forTextStyle: .body),
            titleFont: UIFont.preferredFont(forTextStyle: .title1)
        ).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
