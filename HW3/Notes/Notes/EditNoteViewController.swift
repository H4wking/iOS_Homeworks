//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Danylo Nazaruk on 07.11.2020.
//  Copyright © 2020 Danylo Nazaruk. All rights reserved.
//

import UIKit

protocol EditNoteDelegate {
    func updateNote(updatedName: String, updatedText: String, updatedFavorite: Bool, updatedTags: Set<String>)
}

class EditNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var tagsField: UITextField!
    
    var editNoteDelegate: EditNoteDelegate?
    var noteText: String!
    var favoriteStatus: Bool!
    var favoriteChanged = false
    var noteTags: Set<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        self.textView.text = noteText
        self.textView.becomeFirstResponder()
        
        self.favoriteSwitch.isOn = favoriteStatus
        self.tagsField.text = noteTags.joined(separator: ",")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.doneButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.editNoteDelegate != nil {
            self.editNoteDelegate?.updateNote(updatedName: self.getName(), updatedText: self.textView.text, updatedFavorite: self.favoriteChanged, updatedTags: self.splitTags())
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.textView.resignFirstResponder()
        
        self.doneButton.isEnabled = false
    }
    
    func getName() -> String {
        let name = self.textView.text.components(separatedBy: "\n")[0]
        
        if name == "" {
            return self.navigationItem.title ?? ""
        }
        
        return name
    }
    
    func splitTags() -> Set<String> {
        let tags: String = self.tagsField.text ?? ""
        
        if tags == "" {
            return Set<String>()
        }
        
        let tagsSet: Set<String> = Set(tags.split(separator: ",").map { String($0) })
        return tagsSet
    }

    @IBAction func favoriteSwitched(_ sender: Any) {
        self.favoriteChanged = !self.favoriteChanged
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
