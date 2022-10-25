//
//  SearchResults+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Саша Василенко on 23.10.2022.
//
//

import Foundation
import CoreData


extension SearchResults {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResults> {
        return NSFetchRequest<SearchResults>(entityName: "SearchResults")
    }

    @NSManaged public var dataFromApi: Data?

}

extension SearchResults : Identifiable {

}
