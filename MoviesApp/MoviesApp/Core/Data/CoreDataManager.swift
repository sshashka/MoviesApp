//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by Саша Василенко on 21.10.2022.
//

import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func save(for movie: Data)
    func getSearchedMovies() -> [SearchResults]?
}

class CoreDataManager: CoreDataManagerProtocol {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    
    func save(for movie: Data) {
        let context = persistentContainer.viewContext
        let data = SearchResults(context: context)
        data.dataFromApi = movie
        if context.hasChanges {
            do {
                try context.save()
                print("saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror)")
            }
        }
    }
    
    func getSearchedMovies() -> [SearchResults]? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchResults")
        fetch.returnsObjectsAsFaults = false
        if let data = try? viewContext.fetch(fetch) as? [SearchResults], !data.isEmpty {
            return data
        }
        let entity = SearchResults(context: viewContext)
        return [entity]
    }
}
