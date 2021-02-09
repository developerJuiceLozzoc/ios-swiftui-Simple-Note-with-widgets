//
//  SwiftUIView.swift
//  SimpleNotes
//
//  Created by Conner M on 2/5/21.
//

import SwiftUI
import WidgetKit


let shortTitle = "Title A"
let longTitle = "the quick brown fox jumped over the lazy dog"

let narrowtext = """
one
two
three

"""

let widetext = """
According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible. Yellow, black. Yellow, black. Yellow, black. Yellow, black. Ooh, black and yellow! Let's shake it up a little. Barry! Breakfast is ready! Ooming! Hang on a second. Hello? - Barry? - Adam? - Oan you believe this is happening? - I can't. I'll pick you up. Looking sharp. Use the stairs. Your father paid good money for those. Sorry. I'm excited. Here's the graduate. We're very proud of you, son. A perfect report card, all B's. Very proud. Ma! I got a thing going here. - You got lint on your fuzz. - Ow! That's me! - Wave to us! We'll be in row 118,000. - Bye! Barry, I told you, stop flying in the house! - Hey, Adam. - Hey, Barry. - Is that fuzz gel? - A little. Special day, graduation. Never thought I'd make it. Three days grade school, three days high school.

"""

let listtext = """
 


"""



struct WidgetView: View {
    var titleText: String
    var bodyText: String
    var isOptimizedForList: Bool
    var bodyFamilyChosen: UIFont {
        guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes")
        else { return UIFont.preferredFont(forTextStyle: .body) }
        
        if let bodyFontName = defaults.string(forKey: USER_PREF_BODY),
           let bodySize = defaults.value(forKey: USER_PREF_WIDG_SIZE) as? Int {
            
                let bfontDescriptor =  UIFontDescriptor().withFamily(bodyFontName)
                return UIFont(descriptor: bfontDescriptor, size: CGFloat(bodySize))
        }
        else {
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
    @State var titleFamilyChosen: UIFont = UIFont.preferredFont(forTextStyle: .title2)

    var body: some View {
        Group{
            if(isOptimizedForList){
                Optimized4ListWidget(
                    titleText: titleText,
                    bodyList1: splitArrayByX(height: 11, isOtherHalf: false, with: bodyText),
                    bodyList2: splitArrayByX(height: 11, isOtherHalf: true, with: bodyText),
                    bodyFont: bodyFamilyChosen,
                    titleFont: titleFamilyChosen)
            }
            if(!isOptimizedForList){
                PlainWidget(titleText: titleText, bodyText: bodyText, bodyFont: bodyFamilyChosen, titleFont: titleFamilyChosen)
            }
        }
        .onAppear {
            
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }

            
            if let titleFontName = defaults.string(forKey: USER_PREF_TITLE) {
                let tfontDescriptor =  UIFontDescriptor().withFamily(titleFontName)
                titleFamilyChosen = UIFont(descriptor: tfontDescriptor, size: 15)
            }
        }
    }
}



struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
//            WidgetView(titleText: shortTitle, bodyText: narrowtext)
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            WidgetView(titleText: shortTitle  , bodyText: widetext)
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            WidgetView(titleText: shortTitle, bodyText: narrowtext)
//                .previewContext(Wi dgetPreviewContext(family: .systemLarge))
            WidgetView(titleText: longTitle, bodyText: listtext, isOptimizedForList: true)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
//            WidgetView(titleText: longTitle, bodyText: listtext, isOptimizedForList: false)
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//
        }
    }
}
