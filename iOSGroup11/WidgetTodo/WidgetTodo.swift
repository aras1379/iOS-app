//
//  WidgetTodo.swift
//  WidgetTodo
//
//  Created by Sara Ljung on 2024-03-09.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct SimpleTodo{
    var id: UUID
    var title: String
}
//https://github.com/JuniperPhoton/Widget-Intermediate-Animation/blob/main/WidgetIntermediateAnimation/WidgetShared.swift
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ReminderIntent: AppIntent {
    static var title: LocalizedStringResource = "Reminder intent"
    
    @Parameter(title: "Reminder id")
    var modelId: String
    
    init(modelId: String) {
        self.modelId = modelId
    }
    
    init() {
        // empty
    }
    
    func perform() async throws -> some IntentResult {
        _ = #Predicate<TodoTask> { item in
            item.id == modelId
        }
        /*if let todo = try? await sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).first {
            item.completedDate = .now
        }*/
        return .result()
    }
}

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry 
   // @Query var todos: [TodoTask]
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todos: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task{ @MainActor in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            
            let context = sharedModelContainer.mainContext
            let todoTasks: [TodoTask] = (try? context.fetch(FetchDescriptor<TodoTask>())) ?? []
            let prioTodos = todoTasks.filter { $0.isPrio }
            
            _ = (try? context.fetch(FetchDescriptor<TodoTask>())) ?? []
           
   
            
           
            
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, todos: prioTodos.map {
                    SimpleTodo(id: UUID(uuidString: $0.id) ?? UUID(), title: $0.title)})
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
 
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: [SimpleTodo]
}

struct WidgetTodoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TodosWidgetView(todos: entry.todos)
            //ForEach(entry.todos, id: \.id) { todo in
              //  Text(todo.title)
            }
            
            //TodoWidgetView()
                //.modelContainer(for: [Category2.self, TodoTask.self, CoffeeCup.self])
                
        
    }
}

struct WidgetTodo: Widget {
    let kind: String = "WidgetTodo"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetTodoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetTodoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
/*
#Preview(as: .systemSmall) {
    WidgetTodo()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
*/

