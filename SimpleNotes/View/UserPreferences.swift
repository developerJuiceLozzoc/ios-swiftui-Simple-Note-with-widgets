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
    
    @State var bodyFontSize: Int = 24
    @State var sample_text: String = "EZ Notes 😺"
    
    @State var sample_w_text: String = "Widgetz! 🤟"
    @State var widgetFontSize: Int = 20

    
    var fontlist: [String] {
        //compute array, each family must have bold varient
        var arr:[String] =  UIFont.familyNames.sorted()
            .filter{ family in
                    UIFont.fontNames(forFamilyName: family)
                    .filter {varients in
                        return varients.contains("Bold")
                    }.count > 0
        }.map { $0 }
        arr.insert("Default", at: 0)
        return arr
        
    }
    
   

    
    var body: some View {
        Form{
            Section(header: Text("Color")){
                
                ColorPicker("Note Background Color", selection: $color)
                
            }
            //MARK: Font Family
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
            //MARK: Font Size
            Section(header: Text("Note Font Size")){
                Stepper("Font Size", onIncrement: {bodyFontSize += 4}, onDecrement: {bodyFontSize -= 4})
                
                HStack{
                    Text("\(bodyFontSize)")
                    Spacer()

                    TextField("Sample Text", text: $sample_text)
                        .frame(maxWidth: 125)
                        .font(
                            calculateFont(
                                family: bodyFamilyChosen == -1 ? "Default" : fontlist[bodyFamilyChosen],
                                size: bodyFontSize)
                        )
                    
                }
            }
            Section(header: Text("Widget Font Size")){
                Stepper("Font Size", onIncrement: {widgetFontSize += 4}, onDecrement: {widgetFontSize -= 4})
                
                HStack{
                    Text("\(widgetFontSize)")
                    Spacer()

                    TextField("Sample Text", text: $sample_w_text)
                        .frame(maxWidth: 125)
                        .font(
                            calculateFont(
                                family: bodyFamilyChosen == -1 ? "Default" : fontlist[bodyFamilyChosen],
                                size: widgetFontSize)
                        )
                    
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
            
            defaults.setValue(bodyFontSize, forKey: USER_PREF_NOTE_SIZE)
            defaults.setValue(widgetFontSize, forKey: USER_PREF_WIDG_SIZE)
            
            
        }.onAppear(perform: {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            
            
           if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR) as? [CGFloat], components.count == 4 {
            color = ExtColor(displayP3Red: components[0],
                             green: components[1], blue: components[2], alpha: components[3]).cgColor
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
            
            if let bodySize = defaults.value(forKey: USER_PREF_NOTE_SIZE) as? Int {
                bodyFontSize = bodySize
            }
            if let widgSize = defaults.value(forKey: USER_PREF_WIDG_SIZE) as? Int {
                widgetFontSize = widgSize
            }

            
        })
    }
    
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferences()
    }
}
