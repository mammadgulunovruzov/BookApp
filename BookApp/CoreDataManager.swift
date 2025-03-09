//
//  CoreDataManager.swift
//  BookApp
//
//  Created by Mammadgulu Novruzov on 08.03.25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func addBookmark(book: Book) {
        let entity = NSEntityDescription.entity(forEntityName: "Bookmarks", in: context)!
        let bookmark = NSManagedObject(entity: entity, insertInto: context)
        
        
        let generatedID = UUID() as NSUUID
        bookmark.setValue(generatedID, forKey: "id")
        bookmark.setValue(book.title, forKey: "title")
        bookmark.setValue(book.author, forKey: "author")
        bookmark.setValue(book.description, forKey: "bookDescription")
        bookmark.setValue(book.imageName, forKey: "imageName")
        
        // Persist
        saveContext()
    }
    
    func removeBookmark(book: Book) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bookmarks")
        fetchRequest.predicate = NSPredicate(format: "title == %@", book.title)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                if let managedObject = object as? NSManagedObject {
                    context.delete(managedObject)
                }
            }
            saveContext()
        } catch {
            print("Failed to remove bookmark: \(error)")
        }
    }
    
    func isBookBookmarked(book: Book) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bookmarks")
        fetchRequest.predicate = NSPredicate(format: "title == %@", book.title)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if bookmarked: \(error)")
            return false
        }
    }
    
    func fetchBookmarkedBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Bookmarks")
        
        do {
            let results = try context.fetch(fetchRequest)
            var books = [Book]()
            for obj in results {
                let title = obj.value(forKey: "title") as? String ?? ""
                let author = obj.value(forKey: "author") as? String ?? ""
                let desc = obj.value(forKey: "bookDescription") as? String ?? ""
                let imageName = obj.value(forKey: "imageName") as? String ?? ""
                
                let book = Book(title: title,
                                author: author,
                                description: desc,
                                imageName: imageName,
                                isBookmarked: true)
                books.append(book)
            }
            return books
        } catch {
            print("Failed to fetch bookmarked books: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
