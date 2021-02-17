//
//  FavoritesViewModel.swift
//  GamesGeek
//
//  Created by Recep Bayraktar on 16.02.2021.
//

import UIKit
import CoreData

class FavoritesViewModel {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GamesGeek")
        
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Error: \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return taskContext
    }
    
    func getAllFavorites(completion: @escaping(_ members: [FavoritesModel]) -> ()) {
        
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [FavoritesModel] = []
                for result in results {
                    let favorite = FavoritesModel(id: result.value(forKeyPath: "id") as? Int32, name: result.value(forKeyPath: "name") as? String, rating: result.value(forKeyPath: "rating") as? Float, backgroundImage: result.value(forKeyPath: "background_image") as? String, released: result.value(forKeyPath: "released") as? Date)
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Fetch error \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func get(_ id: Int, completion: @escaping(_ favorite: FavoritesModel) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first{
                    let favorite = FavoritesModel(id: result.value(forKeyPath: "id") as? Int32,
                                                name: result.value(forKeyPath: "name") as? String,
                                                rating: result.value(forKeyPath: "rating") as? Float,
                                                backgroundImage: result.value(forKeyPath: "background_image") as? String,
                                                released: result.value(forKeyPath: "released") as? Date)
                    completion(favorite)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func create(_ id: Int32, _ name: String, _ rating: Float, _ backgroundImage: String, _ released: Date, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                favorite.setValue(id, forKeyPath: "id")
                favorite.setValue(name, forKeyPath: "name")
                favorite.setValue(rating, forKeyPath: "rating")
                favorite.setValue(backgroundImage, forKeyPath: "background_image")
                favorite.setValue(released, forKeyPath: "released")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func update(_ id: Int32, _ name: String, _ rating: Float, _ backgroundImage: String, _ released: Date, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            if let result = try? taskContext.fetch(fetchRequest), let favorite = result.first as? Favorites{
                favorite.setValue(name, forKeyPath: "name")
                favorite.setValue(rating, forKeyPath: "rating")
                favorite.setValue(backgroundImage, forKeyPath: "background_image")
                favorite.setValue(released, forKeyPath: "released")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getMaxId(completion: @escaping(_ maxId: Int) -> ()) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            do {
                let lastMember = try taskContext.fetch(fetchRequest)
                if let member = lastMember.first, let position = member.value(forKeyPath: "id") as? Int{
                    completion(position)
                } else {
                    completion(0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAll(completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
    
    func delete(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
    
}
