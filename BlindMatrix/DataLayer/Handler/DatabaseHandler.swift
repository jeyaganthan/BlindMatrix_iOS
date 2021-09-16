//
//  DatabaseHandler.swift
//  BlindMatrix
//
//  Created by Jeyakanthan's Mac Mini on 09/01/21.
//  Copyright © 2021 Jeyakanthan's Mac Mini. All rights reserved.
//

import UIKit
import CoreData



class DatabaseHandler: NSObject {
    static let sharedInstance = DatabaseHandler()
 
    
    override init() {
        super.init()
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    //Count Check
    
    
    
    func countForDataForTable(Entityname: String,attribute:String?,FetchString:String?) -> Bool {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entityname)
        let Entity = NSEntityDescription.entity(forEntityName: Entityname, in: context)
        fetchRequest.entity = Entity
        
        if(FetchString != nil)
        {
            fetchRequest.predicate = NSPredicate(format: "\(attribute!) == %@", FetchString!)
        }
         var count:Int
        
        do {
            count = try context.count(for: fetchRequest)
            print("Saved!")
        } catch let error as NSError {
            count = 0
            print("Error: \(error)")
        }
         return (count > 0) ? true: false
    }
    
    //Insert
    func InserttoDatabase(Dict:NSDictionary,Entityname:String){
         
//        DispatchQueue.main.async {
            let context = self.getContext()
            //retrieve the entity that we just created
            let obj = NSEntityDescription.insertNewObject(forEntityName: Entityname as String, into: context)
             if(Dict.count > 0)
            {
                 obj.setValuesForKeys(Dict as! [String : AnyObject])
                do {
                    try context.save()
                    
                } catch _ {
                    
                }
             }
            
//        }
       
        
    }
    //Update
    func UpdateData(Entityname:String?,FetchString:String?,attribute:String?,UpdationElements:NSDictionary?)
    {
            let context = self.getContext()
            let batchRequest = NSBatchUpdateRequest(entityName: Entityname! as String) // 2
            batchRequest.propertiesToUpdate = UpdationElements! as? [AnyHashable : Any] // 3
            batchRequest.resultType = .updatedObjectIDsResultType // 4
            batchRequest.predicate = NSPredicate(format: "\(attribute!) == %@", FetchString!)
        
            let error : NSError?
            
            do {
              if let updateResult:NSBatchUpdateResult = try context.execute(batchRequest) as? NSBatchUpdateResult
              {
                
                
                if let res = updateResult.result {
                    
                    let objectID = res as! NSArray
                    
                    for managedObjects in objectID {
                        
                        let object = try! context.existingObject(with: managedObjects as! NSManagedObjectID)
                        context.refresh(object, mergeChanges: false)
                    }
                    
                } else {
                    print("Error during batch update: )")
                }
            }
            }catch let error1 as NSError {
                error = error1
                if let error = error {
                    print(error.userInfo)
                }
            }
         
        
    }
    
    func UpdateDataBasedDB_ID(Entityname:String?,FetchString:String?,attribute:String?,UpdationElements:NSDictionary?,objectID:NSManagedObjectID)
    {
        
        print("\(UpdationElements)")
        let context = self.getContext()
        let batchRequest = NSBatchUpdateRequest(entityName: Entityname! as String) // 2
        batchRequest.propertiesToUpdate = UpdationElements! as? [AnyHashable : Any] // 3
        batchRequest.resultType = .updatedObjectIDsResultType // 4
        batchRequest.predicate = NSPredicate(format: "\(attribute!) == %@", FetchString!)
      
      
        let error : NSError?
       
//      let nsManagedObject =  getContext()
//        if let object = nsManagedObject.existingObjectWithID(NSManagedObjectID(FetchString)) {
//            // do something with it
//        }
//        else {
//            print("Can't find object \(error)")
//        }
        do {
            if let updateResult:NSBatchUpdateResult = try context.execute(batchRequest) as? NSBatchUpdateResult
            {
                
                
                if let res = updateResult.result {
                    
                    let object_ID = res as! NSArray
                    
                    for managedObjects in object_ID {
                        if managedObjects as! NSManagedObjectID == objectID{
                            let object = try! context.existingObject(with: managedObjects as! NSManagedObjectID)
                            context.refresh(object, mergeChanges: false)
                        }
                       
                    }
                    
                } else {
                    print("Error during batch update: )")
                }
            }
        }catch let error1 as NSError {
            error = error1
            if let error = error {
                print(error.userInfo)
            }
        }
        
        
    }

    //fetch
    
    func FetchFromDatabaseWithPredicate(Entityname:String?, SortDescriptor: String?,predicate:NSPredicate?,Limit:NSInteger!)->Any
    {
        
        let context = getContext()
        
        let entity =  NSEntityDescription.entity(forEntityName: Entityname! as String, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entityname!)
        fetchRequest.entity = entity
        
        if (SortDescriptor?.isEmpty) != nil {
            
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: SortDescriptor!, ascending: false)
            fetchRequest.sortDescriptors = [descriptor]
        }
          if(predicate != nil)
        {
            fetchRequest.predicate = predicate!
        }
      
        if(Limit != 0)
        {
            fetchRequest.fetchLimit=Limit;
        }
        
         var returnData:Any!
        do {
             returnData = try context.fetch(fetchRequest) as Any
         } catch {
        }
         return returnData
    }
    
    
    
    func FetchFromDatabase(Entityname:String?,attribute:String?,FetchString:String?, SortDescriptor: String?)->Any
    {
        
        let context = getContext()
        
        let entity =  NSEntityDescription.entity(forEntityName: Entityname! as String, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entityname!)
        fetchRequest.entity = entity
        
        if (SortDescriptor?.isEmpty) != nil {
            
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: SortDescriptor!, ascending: false)
            
            fetchRequest.sortDescriptors = [descriptor]
        }
        
        
        if(FetchString != nil)
        {
        fetchRequest.predicate = NSPredicate(format: "\(attribute!) == %@", FetchString!)
        }
        
        var returnData:Any!
        do {
            
            returnData = try context.fetch(fetchRequest) as Any
            
        } catch {
        }
        
        return returnData
    }
    
    func fetchTableAllData(Entityname: String?) -> NSArray {
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: Entityname!, in: context)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        let savedObjects = try! context.fetch(fetchRequest) as? [NSManagedObject]
        return savedObjects! as NSArray
    }
    
    func FetchFromDatabaseWithLimit(Entityname:String?,attribute:String?,Predicatefromat:String?,FetchString:String?,Limit:NSInteger!, SortDescriptor: String?)->[Any]
    {
        
        let context = getContext()
        
        let Entity = NSEntityDescription.entity(forEntityName: Entityname!, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entityname!)
        fetchRequest.entity = Entity
        
        fetchRequest.predicate = NSPredicate(format: "\(attribute!) == %@", FetchString!)
        
        if (SortDescriptor?.isEmpty) != nil {
            
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "\(SortDescriptor!)", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
        }
        if(Limit != 0)
        {
        fetchRequest.fetchLimit=Limit;
        }
        
        
        var returnData = [Any]()
        do {
            returnData = try context.fetch(fetchRequest) as [Any]
        } catch {
        }
        return returnData
    }
    //Delete
    
    func DeleteFromDataBase(Entityname:String?,Predicatefromat:String?,Deletestring:String?,AttributeName:String?) {
        let context = getContext()
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: Entityname!, in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entityname!)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "\(AttributeName!) \(Predicatefromat!) %@", Deletestring!)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func truncateDataForTable(Entityname: String?) {
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: Entityname!, in: context)
        fetchRequest.includesPropertyValues = false
        
        let error:NSError?
        if let results = try! context.fetch(fetchRequest) as? [NSManagedObject] {
            for result in results {
                context.delete(result)
            }
            
            
            do {
                try context.save()
                // do something after save
                
            } catch let error1 as NSError {
                error = error1
                if let error = error {
                    print(error.userInfo)
                }
            }
            
        }
    }
    
}
