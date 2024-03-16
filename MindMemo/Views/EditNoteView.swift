//
//  EditNoteView.swift
//  MindMemo
//
//  Created by Мария Нестерова on 12.03.2024.
//

import UIKit

class EditNoteView: UIView {
    
    var onDeleteTap: ((_ note: Note) -> Void)?
    private var note: Note?
    
    private let noteNameTextField: UITextField = {
        let noteNameTextField = UITextField()
        noteNameTextField.placeholder = "Note title"
        noteNameTextField.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        noteNameTextField.textColor = .black
        
        return noteNameTextField
    }()
    
    private let noteTextView: UITextView = {
        let noteTextView = UITextView()
        noteTextView.backgroundColor = .white
        noteTextView.font = UIFont(name: "Montserrat-Regular", size: 16)
        noteTextView.textColor = .black
        noteTextView.contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        noteTextView.layer.cornerRadius = 12
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.systemGray.cgColor
        
        return noteTextView
    }()
    
    private let borderLineBottom: UIView = {
        let borderLineBottom = UIView()
        borderLineBottom.backgroundColor = .systemGray
        borderLineBottom.alpha = 0.5
        
        return borderLineBottom
    }()
    
    private let deleteNoteButton: UIButton = {
        let deleteNoteButton = UIButton()
        deleteNoteButton.backgroundColor = .black
        deleteNoteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteNoteButton.imageView?.tintColor = .white
        deleteNoteButton.addTarget(self, action: #selector(deleteNoteButtonTapped), for: .touchUpInside)
        
        return deleteNoteButton
    }()
    
    init(_ parentVC: EditNoteViewController, note: Note?) {
        self.note = note
        super.init(frame: .zero)
        parentVC.delegate = self
        configureNoteText()
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteNoteButton.layer.cornerRadius = deleteNoteButton.frame.width / 2
        deleteNoteButton.clipsToBounds = true
    }
    
    private func configureNoteText() {
        noteNameTextField.delegate = self
        noteTextView.delegate = self
        if let note {
            noteNameTextField.text = note.name
            noteTextView.text = note.text
        } else {
            noteTextView.textColor = .systemGray
            noteTextView.text = "Type here something..."
        }
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(noteNameTextField)
        addSubview(noteTextView)
        addSubview(borderLineBottom)
        addSubview(deleteNoteButton)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            noteNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            noteNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            noteNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            borderLineBottom.heightAnchor.constraint(equalToConstant: 1),
            borderLineBottom.widthAnchor.constraint(equalTo: widthAnchor),
            borderLineBottom.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderLineBottom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -92),
            deleteNoteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteNoteButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            deleteNoteButton.heightAnchor.constraint(equalTo: deleteNoteButton.widthAnchor),
            deleteNoteButton.centerYAnchor.constraint(equalTo: borderLineBottom.centerYAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            noteTextView.topAnchor.constraint(equalTo: noteNameTextField.bottomAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteNameTextField.trailingAnchor)
        ])
        
        if note == nil || note?.name == "Getting Started" {
            borderLineBottom.isHidden = true
            deleteNoteButton.isHidden = true
            NSLayoutConstraint.activate([
                noteTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
            ])
            if note?.name == "Getting Started" {
                noteNameTextField.isEnabled = false
                noteTextView.isEditable = false
            }
        } else {
            NSLayoutConstraint.activate([
                noteTextView.bottomAnchor.constraint(equalTo: deleteNoteButton.topAnchor, constant: -12)
            ])
        }
    }
    
    @objc private func deleteNoteButtonTapped(_ sender: UIButton) {
        noteNameTextField.delegate?.textFieldDidEndEditing?(noteNameTextField)
        noteTextView.delegate?.textViewDidEndEditing?(noteTextView)
        onDeleteTap?(note!)
    }
}

extension EditNoteView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if note == nil {
            note = Note(name: textField.text ?? "", text: "")
        } else {
            note?.name = textField.text ?? ""
        }
    }
}

extension EditNoteView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if note == nil || note?.text == "" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if note == nil || note?.name == "" {
            note = Note(name: "", text: textView.text)
        } else {
            note?.text = textView.text
        }
    }
}

extension EditNoteView: EditNoteViewControllerDelegate {
    func saveNote() -> Note {
        noteNameTextField.delegate?.textFieldDidEndEditing?(noteNameTextField)
        noteTextView.delegate?.textViewDidEndEditing?(noteTextView)
        return note!
    }
}
