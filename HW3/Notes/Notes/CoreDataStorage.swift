//
//  CoreDataStorage.swift
//  Notes
//
//  Created by Danylo Nazaruk on 06.12.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStorage: Persistence {
    
    enum Issue: Error {
        case noValue
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NotesData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(note: Note) throws {
        let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: persistentContainer.viewContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
                
        managedObject.setValue(note.noteId, forKey: "noteId")
        managedObject.setValue(note.name, forKey: "name")
        managedObject.setValue(note.text, forKey: "text")
        managedObject.setValue(note.tags.count != 0 ? note.tags.joined(separator: ",") : "", forKey: "tags")
        managedObject.setValue(note.isFavorite, forKey: "isFavorite")
        managedObject.setValue(note.creationDate, forKey: "creationDate")
        managedObject.setValue(note.deletionDate, forKey: "deletionDate")

        saveContext()
    }
    
    func fetchNotes() throws -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)

        var fetchedNotes = [Note]()
        
        for result in results {
            let noteId = result.value(forKeyPath: "noteId") as! Int
            let name = result.value(forKeyPath: "name") as! String
            let text = result.value(forKeyPath: "text") as! String
            let tags = result.value(forKeyPath: "tags") as! String
            let isFavorite = result.value(forKeyPath: "isFavorite") as! Bool
            let creationDate = result.value(forKeyPath: "creationDate") as! Date
            let deletionDate = result.value(forKeyPath: "deletionDate") as? Date
            
            let tagsSet: Set<String> = Set(tags.split(separator: ",").map { String($0) })

            fetchedNotes.append(Note(noteId: noteId, name: name, text: text, tags: tagsSet, isFavorite: isFavorite, creationDate: creationDate, deletionDate: deletionDate))
        }
        
        return fetchedNotes
    }
    
    func update(noteId: Int, key: String, newValue: Any?) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", argumentArray: [Int64(noteId)])
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let managedObject = results.first else { throw Issue.noValue }
        
        managedObject.setValue(newValue, forKey: key)
        
        saveContext()
    }
    
    func delete(noteId: Int) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", argumentArray: [Int64(noteId)])
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let managedObject = results.first else { throw Issue.noValue }
        
        persistentContainer.viewContext.delete(managedObject)
        
        saveContext()
    }
    
    func deleteNotes() throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for result in results {
            persistentContainer.viewContext.delete(result)
        }
        
        saveContext()
    }
    
    func saveCounter(counter: Int) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IdCounter")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int64(0)])
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        if let managedObject = results.first {
            managedObject.setValue(counter, forKey: "idCounter")
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "IdCounter", in: persistentContainer.viewContext)!
            let managedObject = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
            
            managedObject.setValue(0, forKey: "id")
            managedObject.setValue(counter, forKey: "idCounter")
        }
        
        saveContext()
    }
    
    func fetchCounter() throws -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IdCounter")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let managedObject = results.first else {
            print("Fetch counter error")
            throw Issue.noValue
        }
        
        let counter = managedObject.value(forKeyPath: "idCounter") as! Int
        
        return counter
    }
    
    func deleteCounter() throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IdCounter")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for result in results {
            persistentContainer.viewContext.delete(result)
        }
        
        saveContext()
    }
}
