//
//  Note.swift
//  Notes
//
//  Created by Danylo Nazaruk on 07.11.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import Foundation

struct Note {
    let noteId: Int
    var name: String
    var text: String
    var tags: Set<String>
    var isFavorite: Bool
    let creationDate: Date
    var deletionDate: Date?
    
    init(noteId: Int, name: String = "", text: String = "", tags: Set<String> = [], isFavorite: Bool = false, creationDate: Date = Date(), deletionDate: Date? = nil) {
        self.noteId = noteId
        self.name = name
        self.text = text
        self.tags = tags
        self.isFavorite = isFavorite
        self.creationDate = creationDate
        self.deletionDate = deletionDate
    }
    
    mutating func changeFavorite() {
        self.isFavorite = !self.isFavorite
    }
    
    mutating func delete() {
        self.deletionDate = Date()
    }
    
    mutating func restore() {
        self.deletionDate = nil
    }
}
