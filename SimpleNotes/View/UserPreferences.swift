//
//  SwiftUIView.swift
//  SimpleNotes
//
//  Created by Conner M on 2/2/21.
//

import SwiftUI

struct UserPreferences: View {
    @State var familyChosen: Int = -1
    @State var fontName: String = ""
    @State var color: CGColor = ExtColor.gray.cgColor
    var fontlist: [String] {
        //compute array, each family must have bold varient
        return UIFont.familyNames.sorted()
            .filter{ family in
                    UIFont.fontNames(forFamilyName: family)
                    .filter {varients in return varients.contains("Bold") }.count > 0
        }.map { $0 }
    }

    
    var body: some View {
        Form{
            Section(header: Text("My Preferences")){
                
                HStack{
                    Text("Note Font Family")
                    Picker(selection: $familyChosen, label: EmptyView()) {
                        ForEach(0 ..<  self.fontlist.count){
                            Text(self.fontlist[$0])
                                .font(Font.custom(self.fontlist[$0], fixedSize: 20))
                                .tag($0)
                        }
               
                    }
                }
                
                ColorPicker("Note Background Color", selection: $color)
            }
        //MARK: - LifeCycle funcitons
        }.onDisappear {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            
            if let clearcolor = color.copy(alpha: 0.2), let components = clearcolor.components , components.count == 4{
                defaults.setValue(components, forKey: "NOTES_BG_COLOR")
                
            }
            guard familyChosen > -1 else {return}
            defaults.setValue(fontlist[familyChosen], forKey: "NOTES_FONT_FAMILY")
        }.onAppear(perform: {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            
            
           if let components: [ CGFloat ] = defaults.array(forKey: "NOTES_BG_COLOR") as? [CGFloat], components.count == 4 {
            color = ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
           }
            if let font: String = defaults.string(forKey: "NOTES_FONT_FAMILY") {
            
                fontName = font
                if(familyChosen == -1){
                    familyChosen = fontlist.firstIndex(of: fontName)!
                }
            }

            
        })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferences()
    }
}
