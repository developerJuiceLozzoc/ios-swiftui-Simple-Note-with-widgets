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

    var body: some View {
        VStack{
            HStack{
                Text(entry.configuration.shortNoteInfo?.displayString ?? "No note set")
                    .padding()
                    .font(.title3)
                Spacer()
            }
            Text(entry.configuration.shortNoteInfo?.body ?? "No Body")
            Spacer()
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
