//
//  Favorites.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/8/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


extension Favorites
{
    
    static let restIdAttr = "id"
    static let favIdAttr = "favid"
    
    
    static func syncFavorites(_ favorites: [Favorite])
    {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.performAndWait
            {
                let entityName = String(describing: Favorites.self)
                
                let entity =
                    NSEntityDescription.entity(forEntityName: entityName,
                                               in: managedContext)!
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try managedContext.execute(request)
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
                
                for (fav) in favorites
                {
                    let data = NSManagedObject(entity: entity,
                                               insertInto: managedContext)
                    data.setValue(fav.id, forKeyPath: restIdAttr)
                    data.setValue(fav.favoriteId, forKeyPath: favIdAttr)
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
        }
    }
    
    static func addFavorite(_ favorite: Favorite)
    {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.performAndWait
            {
                let entityName = String(describing: Favorites.self)
                
                let entity =
                    NSEntityDescription.entity(forEntityName: entityName,
                                               in: managedContext)!
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try managedContext.execute(request)
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
                
                let data = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
                data.setValue(favorite.id, forKeyPath: restIdAttr)
                data.setValue(favorite.favoriteId, forKey: favIdAttr)
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
        }
    }
    
    static func deleteFavorite(_ id: Int)
    {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.performAndWait
            {
                let entityName = String(describing: Favorites.self)
                let predicate = NSPredicate(format: "id == %d", id)
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                fetch.predicate = predicate
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try managedContext.execute(request)
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
        }
    }
    
    static func isFavorited(id: Int) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityName = String(describing: Favorites.self)
        let predicate = NSPredicate(format: "id == %d", id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    static func dataCount() -> Int {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return 0
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityName = String(describing: Favorites.self)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount
    }
    
    static func getFavoritedId(id: Int) -> Int? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityName = String(describing: Favorites.self)
        let predicate = NSPredicate(format: "id == %d", id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        
        //  var entitiesCount = 0
        var favId: Int? = nil
        
        do {
            let favorites = try managedContext.fetch(fetchRequest)
            //entitiesCount = try managedContext.count(for: fetchRequest)
            if let favorite = favorites.first as? Favorites
            {
                // we've got the profile already cached!
                return Int(favorite.favid)
            }
            else
            {
                return nil
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return favId
    }
}
