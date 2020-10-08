import Foundation

struct Note {
    let noteId: Int
    var name: String
    var text: String
    var tags: Set<String>
    var isFavorite: Bool
    let creationDate: Date
    var deletionDate: Date?
    
    init(noteId: Int, name: String = "", text: String = "", tags: Set<String> = []) {
        self.noteId = noteId
        self.name = name
        self.text = text
        self.tags = tags
        
        self.isFavorite = false
        self.creationDate = Date()
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


class NoteDataManager {
    var notes: [Note]
    var idCounter: Int
    
    
    init() {
        self.notes = []
        self.idCounter = 0
    }
    
    func newNote(name: String = "", text: String = "", tags: Set<String> = []) {
        self.notes.append(Note(noteId: idCounter, name: name == "" ? "New Note \(idCounter)" : name, text: text, tags: tags))
        
        self.idCounter += 1
    }
    
    func updateNoteName(noteId: Int, newName: String) {
        self.notes[noteId].name = newName
    }
    
    func updateNoteText(noteId: Int, newText: String) {
        self.notes[noteId].text = newText
    }
    
    func addNoteTag(noteId: Int, tag: String) {
        self.notes[noteId].tags.insert(tag)
    }
    
    func removeNoteTag(noteId: Int, tag: String) {
        self.notes[noteId].tags.remove(tag)
    }
    
    func deleteNote(noteId: Int) {
        notes[noteId].delete()
    }
    
    func restoreNote(noteId: Int) {
        notes[noteId].restore()
    }
    
    func noteChangeFavourite(noteId: Int) {
        notes[noteId].changeFavorite()
    }
    
    func isInList(note: Note) -> Bool {
        let name = note.name
        
        for n in self.notes {
            if n.name == name {
                return true
            }
        }
        return false
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

// Testing
var nm = NoteDataManager()

nm.newNote()

nm.notes[0].noteId
nm.notes[0].name
nm.notes[0].text
nm.notes[0].tags
nm.notes[0].isFavorite
nm.notes[0].creationDate
nm.notes[0].deletionDate

nm.newNote(name: "TODO", text: "iOS Homework", tags: ["important"])

nm.notes[1].noteId
nm.notes[1].name
nm.notes[1].text
nm.notes[1].tags
nm.notes[1].isFavorite
nm.notes[1].creationDate
nm.notes[1].deletionDate

nm.updateNoteName(noteId: 0, newName: "Shopping list")
nm.updateNoteText(noteId: 0, newText: "Bread")

nm.notes[0].name
nm.notes[0].text

nm.addNoteTag(noteId: 0, tag: "Chores")

nm.notes[0].tags

nm.removeNoteTag(noteId: 0, tag: "Chores")

nm.notes[0].tags

nm.deleteNote(noteId: 0)

nm.notes[0].deletionDate

nm.restoreNote(noteId: 0)

nm.notes[0].deletionDate

nm.noteChangeFavourite(noteId: 0)

nm.notes[0].isFavorite

nm.noteChangeFavourite(noteId: 0)

nm.notes[0].isFavorite

nm.isInList(note: nm.notes[0])

var todoNote = nm.notes[1]

nm.isInList(note: todoNote)

var newNote = Note(noteId: 123, name: " ")

nm.isInList(note: newNote)

nm.searchByName(name: "TODO")
nm.searchByName(name: "Shopping list")
nm.searchByName(name: "Guest list")

print(nm.filterNotes(f: { (note: Note) -> Bool in note.tags.contains("important") }))

print(nm.sortNotes(f: { (note1: Note, note2: Note) -> Bool in note1.noteId > note2.noteId}))
