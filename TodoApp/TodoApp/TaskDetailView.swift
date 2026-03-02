//
//  TaskDetailView.swift
//  TodoApp
//
//  Created by RaviShankar Kushwaha on 02/03/26.
//

import SwiftUI
import CoreData

struct TaskDetailView: View {
    
    let task: Task
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite: Bool = false
    
    var fetchRequest: FetchRequest<Task>
    
    init(task: Task) {
        self.task = task
        fetchRequest = FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "SELF = %@", task), animation: nil)
    }
    
    private func updateTask() {
        do {
            let existingTask = try viewContext.existingObject(with: task.objectID) as! Task
            existingTask.isFavorite = isFavorite
            try viewContext.save()
            
        } catch {
            print(error)
        }
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if let existingTask = fetchRequest.wrappedValue.first {
                    Text(existingTask.title ?? "")
                    Image(systemName: task.isFavorite ? "heart.fill" : "heart")
                        .accessibilityIdentifier("favoriteImage")
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                        .font(.largeTitle)
                        .onTapGesture {
                            isFavorite = !task.isFavorite
                            updateTask()
                        }
                }
                
                Spacer()
            }
            .onAppear {
                
            }
            .padding()
            .navigationTitle(task.title ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .accessibilityIdentifier("closeButton")
                    }
                }
            }
        }
    }
}

#Preview {
    let viewContext = CoreDataManger.shared.persistentContainer.viewContext
    let task = Task(context: viewContext)
    task.title = "Mow the lawn"
    task.body = "I need to mow the lawn"
    task.priority = "High"
    task.isFavorite = false

    return TaskDetailView(task: task)
}
