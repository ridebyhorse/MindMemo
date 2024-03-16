//
//  EditNoteViewController.swift
//  MindMemo
//
//  Created by Мария Нестерова on 12.03.2024.
//

import UIKit

protocol EditNoteViewControllerDelegate: AnyObject {
    func saveNote() -> Note
}

class EditNoteViewController: UIViewController {
    
    weak var delegate: EditNoteViewControllerDelegate?
    private let note: Note?
    
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if note?.name != "Getting Started" {
            let bar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndClose))
            navigationItem.rightBarButtonItem = bar
        }
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        if note != nil {
            title = "Edit note"
        } else {
            title = "New note"
        }
        
        let editView = EditNoteView(self, note: note)
        editView.onDeleteTap = deleteNote
        view = editView
    }
    
    private func deleteNote(_ note: Note) {
        let alert = UIAlertController(title: "Delete note \"\(note.name)\"?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) {_ in 
            StorageManager.shared.deleteNote()
            self.navigationController?.popViewController(animated: true)
        })

        present(alert, animated: true)
    }
    
    @objc private func saveAndClose(_ sender: UIBarButtonItem) {
        if let noteToSave = delegate?.saveNote() {
            if note != nil {
                StorageManager.shared.updateNote(noteToSave)
            } else {
                StorageManager.shared.saveNote(noteToSave)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

