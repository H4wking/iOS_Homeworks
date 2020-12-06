//
//  Persistence.swift
//  Notes
//
//  Created by Danylo Nazaruk on 06.12.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import Foundation

protocol Persistence {
    
    func save(note: Note) throws
    
    func fetchNotes() throws -> [Note]
}
