//
//  SwiftUIView.swift
//  SimpleNotes
//
//  Created by Conner M on 2/2/21.
//

import SwiftUI

struct UserPreferences: View {
    @State var titleFamilyChosen: Int = -1
    @State var bodyFamilyChosen: Int = -1

    @State var fontName: String = ""
    @State var color: CGColor = ExtColor.gray.cgColor
    var fontlist: [String] {
        //compute array, each family must have bold varient
        var arr:[String] =  UIFont.familyNames.sorted()
            .filter{ family in
                    UIFont.fontNames(forFamilyName: family)
                    .filter {varients in return varients.contains("Bold") }.count > 0
        }.map { $0 }
        arr.insert("Default", at: 0)
        return arr
        
    }

    
    var body: some View {
        Form{
            Section(header: Text("Color")){
                
                ColorPicker("Note Background Color", selection: $color)
                
            }
            Section(header: Text("Font Family")){
                HStack{
                    Text("Title Text Font-Style")
                    Picker(selection: $titleFamilyChosen, label: EmptyView()) {
                        ForEach(0 ..<  self.fontlist.count){
                            Text(self.fontlist[$0])
                                .font(Font.custom(self.fontlist[$0], fixedSize: 20))
                                .tag($0)
                        }
               
                    }
                }
                HStack{
                    Text("Body Font-Style")
                    Picker(selection: $bodyFamilyChosen, label: EmptyView()) {
                        ForEach(0 ..<  self.fontlist.count){
                            Text(self.fontlist[$0])
                                .font(Font.custom(self.fontlist[$0], fixedSize: 20))
                                .tag($0)
                        }
               
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text("")
            }
        //MARK: - LifeCycle funcitons
        }.onDisappear {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            
            if let clearcolor = color.copy(alpha: 0.2), let components = clearcolor.components , components.count == 4{
                defaults.setValue(components, forKey: USER_PREF_COLOR)
                
            }
            if bodyFamilyChosen == 0  { // default
                defaults.removeObject(forKey: USER_PREF_BODY)
            }
            else if bodyFamilyChosen > -1 {
                defaults.setValue(fontlist[bodyFamilyChosen], forKey: USER_PREF_BODY)
            }
            if titleFamilyChosen == 0 {
                defaults.removeObject(forKey: USER_PREF_TITLE)
            }
            else if titleFamilyChosen > -1 {
                defaults.setValue(fontlist[titleFamilyChosen], forKey: USER_PREF_TITLE)
            }
            
        }.onAppear(perform: {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            
            
           if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR) as? [CGFloat], components.count == 4 {
            color = ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
           }

            if let bodyFontName = defaults.string(forKey: USER_PREF_BODY) {
                if(bodyFamilyChosen == -1){
                    bodyFamilyChosen = fontlist.firstIndex(of: bodyFontName)!
                }
            }
            if let titleFontName = defaults.string(forKey: USER_PREF_TITLE) {
                if(titleFamilyChosen == -1){
                    titleFamilyChosen = fontlist.firstIndex(of: titleFontName)!
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
