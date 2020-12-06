//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Danylo Nazaruk on 07.11.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, EditNoteDelegate {
        
    var notes = NoteDataManager()
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.notes.count
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.notes.newNote()
        self.selectedIndex = self.notes.notes.count - 1
        self.tableView.reloadData()
        
        performSegue(withIdentifier: "ShowEditScreenSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)

        cell.textLabel?.text = self.notes.notes[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        
        performSegue(withIdentifier: "ShowEditScreenSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notes.deleteNote(noteId: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? EditNoteViewController
        destinationViewController?.title = self.notes.notes[selectedIndex].name
        destinationViewController?.noteText = self.notes.notes[selectedIndex].text
        destinationViewController?.favoriteStatus = self.notes.notes[selectedIndex].isFavorite
        destinationViewController?.noteTags = self.notes.notes[selectedIndex].tags
        destinationViewController?.editNoteDelegate = self
    }
    
    func updateNote(updatedName: String, updatedText: String, updatedFavorite: Bool, updatedTags: Set<String>) {
        self.notes.updateNoteName(noteId: self.selectedIndex, newName: updatedName)
        self.notes.updateNoteText(noteId: self.selectedIndex, newText: updatedText)
        
        if updatedFavorite {
            self.notes.noteChangeFavourite(noteId: self.selectedIndex)
        }
        
        self.notes.notes[selectedIndex].tags.removeAll()
        for tag in updatedTags {
            self.notes.addNoteTag(noteId: selectedIndex, tag: tag)
        }
        
        self.tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
