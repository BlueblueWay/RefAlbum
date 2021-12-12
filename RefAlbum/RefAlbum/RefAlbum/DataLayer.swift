//
//  DataLayer.swift
//  RefAlbum
//
//  Created by lingshun kong on 11/25/21.
//

import Foundation
import SQLite


class Database {
    //declear variable
    var conn : Connection!
    
    //collection variabale
    var tb1 : Table!
    var cID : Expression<Int>!
    var cInfo : Expression<String>!
    //event variable
    var tb2 : Table!
    var eid : Expression<Int>!
    var eInfo: Expression<String>!
    
    init() {
        //create database
        let rootPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = rootPath.appendingPathComponent("RefAlbum.sqlite").path
        print("Database location: \(dbPath)")
        conn = try! Connection(dbPath)
        //
       initialize()
    }
    private func initialize() {
        
        //define table
        
        //table collection
        tb1 = Table("Collection")
        cID = Expression<Int>("cID")
        cInfo = Expression<String>("content")
        
        //table Event
        tb2 = Table("Event")
        eid = Expression("eid")
        eInfo = Expression("content")
        
        //create table - collection
        let crTb1 = tb1.create(ifNotExists: true){t in
            t.column(cID, primaryKey: true)
            t.column(cInfo)
        }
        
        //create table - event
        let crTb2 = tb2.create(ifNotExists: true){t in
            t.column(eid, primaryKey: true)
            t.column(cID) // collection foreignkey
            t.column(eInfo)
        }
        
        //update table
        try! conn.run(crTb1)
        try! conn.run(crTb2)
    }
    
    func listCollection() -> [CollectionModel] {
        let db = Database()
        
        
        let tb1 = db.tb1!
        let rs = try! db.conn.prepare(tb1)
        var list = [CollectionModel]()
        
        for r in rs {
            let collectionModel: CollectionModel = CollectionModel()
            collectionModel.id = try! r.get(db.cID)
            collectionModel.content = try! r.get(db.cInfo)
            try! list.append(collectionModel)
            
        }
        
        return list
    }
    
//delete collection
    func deleteCollection(_ id: Int) {
        let toDelete: Table = tb1.filter(cID == id)
        let toDeleteEvent: Table = tb2.filter(cID == id)
        try! conn.run(toDelete.delete())
        try! conn.run(toDeleteEvent.delete())
    }
    
    func listEvents(_ id: Int) -> [EventModel] {
        let db = Database()
        let toList: Table = tb2.filter(cID == id)
        
        let rs = try! db.conn.prepare(toList)
        var list = [EventModel]()
        
        for r in rs {
            let eventModel: EventModel = EventModel()
            eventModel.id = try! r.get(db.eid)
            eventModel.content = try! r.get(db.eInfo)
            try! list.append(eventModel)
        }
        
        return list
    }
    
    func deleteEvent(_ id: Int) {
        let toDelete:Table = tb2.filter(eid == id)
        try! conn.run(toDelete.delete())
    }
    
}

class RefAlbumRepository {
    
    
    var db = Database()
    
    static private var repository : RefAlbumRepository!
    
    static func get() -> RefAlbumRepository {
        if repository == nil {
            repository = RefAlbumRepository()
        }
        return repository
    }
    
    // table repo - collection
    func insertCollection(_ content : String) {
        let conn = db.conn!
        let tb1 = db.tb1!
        
        print("inserting collection table")
        let insTb1 = tb1.insert(db.cInfo <- content)
        try! conn.run(insTb1)
        
    }
    
    //table repo - event
    func insertEvent(_ cid: Int, _ info: String) {
        let conn = db.conn!
        let tb2 = db.tb2!
        
        print("inserting event table")
        let insTb2 = tb2.insert(db.cID <- cid, db.cInfo <- info)
        try! conn.run(insTb2)
    }
    
    
}
