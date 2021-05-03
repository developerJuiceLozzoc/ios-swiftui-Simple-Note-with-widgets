//a
//  SimpleNoteWidget.swift
//  SimpleNoteWidget
//
//  Created by Conner M on 1/26/21.
//

import WidgetKit
import SwiftUI
import Intents



struct Provider: IntentTimelineProvider {
    
    typealias Entry = SimpleEntry
    
    typealias Intent = NoteConfigurationIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        let defaultTitle = "EZ Lists & Notes"
        let defaultBody = "Great for keeping track of your top lists!"
        let config = NoteConfigurationIntent()
        config.shortNoteInfo = NoteForWidget(identifier: UUID().uuidString, display: defaultTitle)
        config.shortNoteInfo?.body = defaultBody
        return SimpleEntry(date: Date(), configuration: config)
    }

    
    // when the carousel picker for widget pops up, we can switch based on the size to render a hardcoded experience.
    func getSnapshot(for configuration: NoteConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {

        switch context.family {
            case .systemSmall:
                configuration.shortNoteInfo = NoteForWidget(identifier: UUID().uuidString, display: "Call Jennie")
                configuration.shouldBeOptimizedForList = false
                configuration.shortNoteInfo?.body = "867-5309"
                break;
            case .systemLarge:
                fallthrough
            default:
                configuration.shortNoteInfo = NoteForWidget(identifier: UUID().uuidString, display:  "Tasteful Animes")
                configuration.shouldBeOptimizedForList = false
                configuration.shortNoteInfo?.body = """
                        - Food Wars!
                        - Plunderer
                        - Dorohedoro
                        - My Hero Acedemia
                        - One Punch Man
                        - Cory in the House
                        - Castlevania
                    """
                break
        }
        completion(SimpleEntry(date: Date(), configuration: configuration, isPreview: context.isPreview))
    }

    func getTimeline(for configuration: NoteConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    public let configuration: NoteConfigurationIntent
    var isPreview: Bool = false
}

struct SimpleNoteWidgetEntryView : View {
    var entry: Provider.Entry
    

    var bodyFamilyChosen: UIFont {
        guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return UIFont.preferredFont(forTextStyle: .body) }
        if let bodyFontName = defaults.string(forKey: USER_PREF_BODY), let bodySize = defaults.value(forKey: USER_PREF_WIDG_SIZE) as? Int {
            let bfontDescriptor =  UIFontDescriptor().withFamily(bodyFontName)
            return UIFont(descriptor: bfontDescriptor, size: CGFloat(bodySize))
        }
        else {
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    var titleFamilyChosen: UIFont {
        guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return UIFont.preferredFont(forTextStyle: .title2) }

        if let titleFontName = defaults.string(forKey: USER_PREF_TITLE) {
            let tfontDescriptor =  UIFontDescriptor().withFamily(titleFontName)
            return UIFont(descriptor: tfontDescriptor, size: 26)
        }
        else{
            return UIFont.preferredFont(forTextStyle: .title2)
        }
    }
    let defaultTitle = "EZ Lists & Notes"
    let defaultBody = "Great for keeping track of your top lists!"


    var body: some View {
        VStack{
            // do not load user defaults, this takes time and is not preferable for previewing widgets in the widget select
            if(entry.isPreview){
                FastPreviewWidget(
                    titleText: entry.configuration.shortNoteInfo!.displayString,
                    bodyText:  entry.configuration.shortNoteInfo!.body!)
            }
            //in the widget configure menu, there are toggles and fields and if this toggle is on, it created a 2 colom bulleted list
            if(entry.configuration.shouldBeOptimizedForList == 1 && !entry.isPreview){
                Optimized4ListWidget(
                    titleText: entry.configuration.shortNoteInfo?.displayString ?? "Oops this note has no title!",
                    bodyList1: splitArrayByX(height: 10, isOtherHalf: false, with: entry.configuration.shortNoteInfo?.body ?? ""),
                    bodyList2: splitArrayByX(height: 10, isOtherHalf: true, with: entry.configuration.shortNoteInfo?.body ?? ""),
                    bodyFont: bodyFamilyChosen,
                    titleFont: titleFamilyChosen)
            }
            // render the wiget regualrly
            if(entry.configuration.shouldBeOptimizedForList == 0 && !entry.isPreview){
                PlainWidget(titleText:  entry.configuration.shortNoteInfo?.displayString ?? "Oops this note has no title!",
                            bodyText:  entry.configuration.shortNoteInfo?.body ?? "",
                                        bodyFont: bodyFamilyChosen,
                                        titleFont: titleFamilyChosen)
            }

        }


    }
    
}

func splitArrayByX(height: Int,isOtherHalf: Bool, with text: String) -> [String]{
    var arr = [String]()
    let split = text.split(separator: "\n")
    var truncHeight = height
    if height >= split.count {
        truncHeight = split.count-1
    }
    
    if(isOtherHalf){
        let slice: ArraySlice<Substring> = split[truncHeight...split.count-1]
        arr = slice.map { "∙ \($0)" }
    }
    else{
        let slice: ArraySlice<Substring> = split[0...truncHeight-1]
        arr = slice.map { "∙ \($0)" }
    }
    return arr
}

struct SimpleNoteWidget: Widget {
    let kind: String = "SimpleNoteWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: NoteConfigurationIntent.self,
                            provider: Provider()) { entry in
            SimpleNoteWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "com.lozzoc.SimpleNotes.SpecificNote://\(entry.configuration.shortNoteInfo?.identifier ?? "")" ))
                .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
                .background(entry.isPreview ? Color.clear : getBackgroundColor())

        }
        .configurationDisplayName("Note Detail")
        .description("A note rendered right on your home screen!")
        .supportedFamilies([.systemSmall,.systemLarge])
    }
    
    
}
struct QuickAccessWidget: Widget {
    let kind: String = "SimpleNoteWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: NoteConfigurationIntent.self,
                            provider: Provider()) { entry in
            SimpleNoteWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "com.lozzoc.SimpleNotes.SpecificNote://\(entry.configuration.shortNoteInfo?.identifier ?? "")" ))
                .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
                .background(entry.isPreview ? Color.clear : getBackgroundColor())

        }
        .configurationDisplayName("Note Shortcut")
        .description("Get Quick access to one of your notes.")
        .supportedFamilies([.systemSmall])
    }
    
    
}

func getBackgroundColor() -> Color {
    guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return Color.white}
    var color: CGColor = Color.white.cgColor!
    if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR ) as? [CGFloat], components.count == 4 {
        color = ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
   }
   return Color(color)
    
}

// to enable more posible experiences in the widget picker carousel, we create a widget bundle, with multiple widgets inside of it,
// each widget can have multiple familyies, and contains a differenrt description and configuration
@main
struct NoteBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        QuickAccessWidget()
        SimpleNoteWidget()
    }
}
