//
//  NFXHTTPModelManager.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

    // MARK: - Private Properties
    
private let _sharedInstance = NFXHTTPModelManager()

final class NFXHTTPModelManager: NSObject
{
    
    // MARK: - Public Properties
    
    static let sharedInstance = NFXHTTPModelManager()
    fileprivate var models = [NFXHTTPModel]()
    
    // MARK: - Public Functions
    
    func add(_ obj: NFXHTTPModel)
    {
        self.models.insert(obj, at: 0)
    }
    
    func clear()
    {
        self.models.removeAll()
    }
    
    func getModels() -> [NFXHTTPModel]
    {        
        var predicates = [NSPredicate]()
        
        let filterValues = NFX.sharedInstance().getCachedFilters()
        let filterNames = HTTPModelShortType.allValues
        
        var index = 0
        for filterValue in filterValues {
            if filterValue {
                let filterName = filterNames[index].rawValue
                let predicate = NSPredicate(format: "shortType == '\(filterName)'")
                predicates.append(predicate)

            }
            index += 1
        }

        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (self.models as NSArray).filtered(using: searchPredicate)
        
        return array as! [NFXHTTPModel]
    }
}
