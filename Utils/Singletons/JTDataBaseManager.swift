//
//  JTDataBaseManager.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import FMDB

struct JTDataBaseManager {
    private let dbName = "journey.db"
    
    static var manager: JTDataBaseManager = JTDataBaseManager()
    private init() {
    }
    
    lazy var dbURL: URL = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        return fileURL
    }()
    
    lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
    lazy var dbQueue: FMDatabaseQueue? = {
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()


}
