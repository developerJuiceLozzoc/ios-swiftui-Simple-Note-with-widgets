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
        SimpleEntry(date: Date(), configuration: NoteConfigurationIntent())
    }

    func getSnapshot(for configuration: NoteConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
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
}

struct SimpleNoteWidgetEntryView : View {
    var entry: Provider.Entry
    @State var color: CGColor = Color.white.cgColor!
    @State var bodyFamilyChosen: UIFont =  UIFont.preferredFont(forTextStyle: .body)
    @State var titleFamilyChosen: UIFont = UIFont.preferredFont(forTextStyle: .title2)

    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text(entry.configuration.shortNoteInfo?.displayString ?? "No note set")
                    .font(Font(titleFamilyChosen))
            }
            Text(entry.configuration.shortNoteInfo?.body ?? "No Body")
                .font(Font(bodyFamilyChosen))
                .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(color))
        .onAppear {
            guard let defaults = UserDefaults(suiteName: "group.com.lozzoc.SimpleNotes") else {return }
            if let components: [ CGFloat ] = defaults.array(forKey: USER_PREF_COLOR ) as? [CGFloat], components.count == 4 {
                color = ExtColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3]).cgColor
           }

            if let bodyFontName = defaults.string(forKey: USER_PREF_BODY) {
                let bfontDescriptor =  UIFontDescriptor().withFamily(bodyFontName)
                bodyFamilyChosen = UIFont(descriptor: bfontDescriptor, size: 15)
            }
            if let titleFontName = defaults.string(forKey: USER_PREF_TITLE) {
                let tfontDescriptor =  UIFontDescriptor().withFamily(titleFontName)
                titleFamilyChosen = UIFont(descriptor: tfontDescriptor, size: 15)
            }
        }
    }
}



@main
struct SimpleNoteWidget: Widget {
    let kind: String = "SimpleNoteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: NoteConfigurationIntent.self,
                            provider: Provider()) { entry in
            SimpleNoteWidgetEntryView(entry: entry)
                .widgetURL(URL(string: "com.lozzoc.SimpleNotes.SpecificNote://\(entry.configuration.shortNoteInfo?.identifier ?? "")" ))

        }
        .configurationDisplayName("")
        .description("Search for a particular note of yours")
        .supportedFamilies([.systemSmall,.systemLarge])
    }
}
