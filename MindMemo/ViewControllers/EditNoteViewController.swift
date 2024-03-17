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
    private var note: Note?
    
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        setupUI()
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        let editView = EditNoteView(self, note: note)
        editView.onDeleteTap = deleteNote
        editView.creatingFirstNote = { [weak self] in
            self?.title = "New note"
            let bar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self?.saveAndClose))
            self?.navigationItem.rightBarButtonItem = bar
        }
        view = editView
        
        if note == nil {
            title = "New note"
            let bar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndClose))
            navigationItem.rightBarButtonItem = bar
        } else if note?.name == "Getting Started" {
            note = nil
            title = "Hello!"
        } else {
            title = "Edit note"
            let bar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndClose))
            navigationItem.rightBarButtonItem = bar
        }
    }
    
    private func deleteNote() {
        let deleteAlert = DeleteNoteAlertController()
        deleteAlert.onDelete = {
            StorageManager.shared.deleteNote()
            self.navigationController?.popViewController(animated: true)
        }
        present(deleteAlert, animated: true)
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

