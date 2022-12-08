//
//  GameProvider.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 02/11/22.
//
import CoreData

class GameProvider {
    static let shared = GameProvider()
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Games")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved Error \(error!)")
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
    func isFavorite(gameId: Int) -> Bool {
        let taskContext = newTaskContext()
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
            if let result = try taskContext.fetch(fetchRequest).first {
                let id = result.value(forKeyPath: "id") as? Int
                return id != nil
            }
            return false
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    func getAllFavoriteGames(completionHandle: @escaping (_ games: [Game]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGameEntity")
            do {
                var games: [Game] = []
                let results = try taskContext.fetch(fetchRequest)
                results.forEach { result in
                    if let id = result.value(forKey: "id") as? Int32,
                       let name = result.value(forKey: "name") as? String {
                        let game = Game(
                            id: id,
                            name: name,
                            released: result.value(forKey: "released") as? String,
                            image: result.value(forKey: "image") as? Data,
                            rating: result.value(forKey: "rating") as? Double,
                            genres: result.value(forKey: "genres") as? String,
                            descriptionRaw: result.value(forKey: "desc") as? String,
                            ratingCount: result.value(forKey: "ratingCount") as? Int64,
                            parentPlatformNames: result.value(forKey: "platforms") as? Set<String>,
                            developers: [])
                        games.append(game)
                    }
                }
                completionHandle(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    func createFavoriteGame(game: Game, completionHandler: @escaping () -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGameEntity", in: taskContext) {
                let favoriteGameEntity = NSManagedObject(entity: entity, insertInto: taskContext)
                favoriteGameEntity.setValue(Int32(game.id), forKey: "id")
                favoriteGameEntity.setValue(game.name, forKey: "name")
                favoriteGameEntity.setValue(game.image?.jpegData(compressionQuality: 1), forKey: "image")
                favoriteGameEntity.setValue(game.released, forKey: "released")
                favoriteGameEntity.setValue(game.rating, forKey: "rating")
                favoriteGameEntity.setValue(game.genres, forKey: "genres")
                favoriteGameEntity.setValue(game.descriptionRaw, forKey: "desc")
                favoriteGameEntity.setValue(Int64(game.ratingCount ?? 0), forKey: "ratingCount")
                favoriteGameEntity.setValue(game.parentPlatformNames, forKey: "platforms")
                favoriteGameEntity.setValue([], forKey: "developers")
                do {
                    try taskContext.save()
                    completionHandler()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    func deleteFavoriteGame(id: Int, completionHandler: @escaping () -> Void) {
        let taskRequest = newTaskContext()
        taskRequest.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskRequest.execute(batchDeleteRequest) as? NSBatchDeleteResult, batchDeleteResult.result != nil {
                completionHandler()
            }
        }
    }
}
