//
//  NoteDataManager.swift
//  Notes
//
//  Created by Danylo Nazaruk on 07.11.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import Foundation

class NoteDataManager {
    var notes: [Note]
    var deletedNotes: [Note]
    var idCounter: Int
    
    let storage = CoreDataStorage()
    
    
    init() {
        // For clearing purposes
//        do {
//            try storage.deleteNotes()
//        } catch {
//            print("Error: \(error)")
//        }
//
//        do {
//            try storage.deleteCounter()
//        } catch {
//            print("Error: \(error)")
//        }
        
        
        
        do {
            self.notes = try storage.fetchNotes()
        } catch {
            self.notes = []
            print("Error: \(error)")
        }
        
        self.deletedNotes = []
        
        do {
            self.idCounter = try storage.fetchCounter()
        } catch {
            self.idCounter = 0
            print("Error: \(error)")
        }
    }
    
    func newNote(name: String = "", text: String = "", tags: Set<String> = []) {
        let note = Note(noteId: idCounter, name: name == "" ? "New Note \(idCounter)" : name, text: text, tags: tags)
        self.notes.append(note)
        
        do {
            try storage.save(note: note)
        } catch {
            print("Error: \(error)")
        }
        
        self.idCounter += 1
        
        do {
            try storage.saveCounter(counter: self.idCounter)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func updateNoteName(noteId: Int, newName: String) {
        self.notes[noteId].name = newName
        
        do {
            try storage.update(noteId: notes[noteId].noteId, key: "name", newValue: newName)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func updateNoteText(noteId: Int, newText: String) {
        self.notes[noteId].text = newText
        
        do {
            try storage.update(noteId: notes[noteId].noteId, key: "text", newValue: newText)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func addNoteTag(noteId: Int, tag: String) {
        self.notes[noteId].tags.insert(tag)
        
        do {
            try storage.update(noteId: notes[noteId].noteId, key: "tags", newValue: notes[noteId].tags.joined(separator: ","))
        } catch {
            print("Error: \(error)")
        }
    }
    
    func removeNoteTag(noteId: Int, tag: String) {
        self.notes[noteId].tags.remove(tag)
        
        do {
            try storage.update(noteId: notes[noteId].noteId, key: "tags", newValue: notes[noteId].tags.joined(separator: ","))
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteNote(noteId: Int) {
        do {
            try storage.delete(noteId: notes[noteId].noteId)
        } catch {
            print("Error: \(error)")
        }
        
        notes[noteId].delete()
        let deletedNote = notes[noteId]
        deletedNotes.append(deletedNote)
        notes.remove(at: noteId)
    }
    
    func restoreNote(noteId: Int) {
        deletedNotes[noteId].restore()
        let restoredNote = deletedNotes[noteId]
        notes.append(restoredNote)
        deletedNotes.remove(at: noteId)
    }
    
    func noteChangeFavourite(noteId: Int) {
        notes[noteId].changeFavorite()
        
        do {
            try storage.update(noteId: notes[noteId].noteId, key: "isFavorite", newValue: notes[noteId].isFavorite)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func isInList(note: Note) -> Bool {
        return notes.contains(where: { $0.noteId == note.noteId })
    }
    
    func searchByName(name: String) -> Int? {
        for n in self.notes {
            if n.name == name {
                return n.noteId
            }
        }
        
        return nil
    }
    
    func filterNotes(f: (Note) -> Bool) -> [Note] {
        return self.notes.filter(f)
    }
    
    func sortNotes(f: (Note, Note) -> Bool) -> [Note] {
        return self.notes.sorted(by: f)
    }
}
