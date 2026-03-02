//
//  ContentView.swift
//  TodoApp
//
//  Created by RaviShankar Kushwaha on 02/03/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var priority: String = "Medium"
    @State private var taskBody: String = ""
    
    @State private var message: String = ""
    @State private var selectedTask: Task?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Task.allTasksFetchRequest()) private var allTasks: FetchedResults<Task>
    

    private func saveTask() {
        if title.isEmpty {
            return
        }
        
        do {
            if let _ = Task.by(title: title) {
                message = "Task is already added"
            } else {
                let task = Task(context: viewContext)
                task.title = title
                task.priority = priority
                task.body = taskBody
                
                // save
                try viewContext.save()
            }
        } catch {
            print(error)
        }
        
        title = ""
        priority = "Medium"
        taskBody = ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter title", text: $title)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("titleTextField")
                
                TextField("Enter description", text: $taskBody)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("taskBodyTextField")
                
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }.pickerStyle(.segmented)
                
                Button("Save") {
                    saveTask()
                }
                .padding(10)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .accessibilityIdentifier("saveTaskButton")
                
                Text(message)
                    .accessibilityIdentifier("messageText")
                
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Text(task.title ?? "")
                            Spacer()
                            
                            if task.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color.red)
                            }
                            
                            Text(task.priority ?? "")
                                .frame(maxWidth: 100)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedTask = task
                        }
                        .sheet(item: $selectedTask) {
                        } content: { task in
                            TaskDetailView(task: task)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let task = allTasks[index]
                            viewContext.delete(task)
                            
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .accessibilityIdentifier("taskList")
                
                Spacer()
            }
            .padding()
            .navigationTitle("Tasks")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, CoreDataManger.shared.persistentContainer.viewContext)
}
