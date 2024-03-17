//
//  EditNoteView.swift
//  MindMemo
//
//  Created by Мария Нестерова on 12.03.2024.
//

import UIKit

class EditNoteView: UIView {
    
    var onDeleteTap: (() -> Void)?
    var creatingFirstNote: (() -> Void)?
    private var note: Note?
    
    private let noteNameTextField: UITextField = {
        let noteNameTextField = UITextField()
        noteNameTextField.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        noteNameTextField.textColor = .black
        noteNameTextField.returnKeyType = .done
        
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
        noteTextView.addDoneButton(title: "Done", target: self, action: #selector(doneTapped))
        
        return noteTextView
    }()
    
    private let borderLineBottom: UIView = {
        let borderLineBottom = UIView()
        borderLineBottom.backgroundColor = .systemGray
        borderLineBottom.alpha = 0.5
        
        return borderLineBottom
    }()
    
    private let mainButton: UIButton = {
        let deleteNoteButton = UIButton()
        deleteNoteButton.backgroundColor = .black
        deleteNoteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteNoteButton.imageView?.tintColor = .white
        deleteNoteButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
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
        mainButton.layer.cornerRadius = mainButton.frame.width / 2
        mainButton.clipsToBounds = true
    }
    
    private func configureNoteText() {
        noteNameTextField.delegate = self
        noteTextView.delegate = self
        if let note {
            noteNameTextField.text = note.name
            noteTextView.text = note.text
        } else {
            noteNameTextField.textColor = .systemGray
            noteNameTextField.text = "Note title"
            noteTextView.textColor = .systemGray
            noteTextView.text = "Type here something..."
        }
    }

    private func setupUI() {
        backgroundColor = .white
        
        addSubview(noteNameTextField)
        addSubview(noteTextView)
        addSubview(borderLineBottom)
        addSubview(mainButton)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            noteNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            noteNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            noteNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            borderLineBottom.heightAnchor.constraint(equalToConstant: 1),
            borderLineBottom.widthAnchor.constraint(equalTo: widthAnchor),
            borderLineBottom.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderLineBottom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -92),
            mainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            mainButton.heightAnchor.constraint(equalTo: mainButton.widthAnchor),
            mainButton.centerYAnchor.constraint(equalTo: borderLineBottom.centerYAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            noteTextView.topAnchor.constraint(equalTo: noteNameTextField.bottomAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteNameTextField.trailingAnchor)
        ])
        
        if note == nil {
            borderLineBottom.isHidden = true
            mainButton.isHidden = true
            NSLayoutConstraint.activate([
                noteTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
            ])
        } else {
            NSLayoutConstraint.activate([
                noteTextView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -12)
            ])
        }
        
        if note?.name == "Getting Started" {
            mainButton.setImage(UIImage(systemName: "plus"), for: .normal)
            noteTextView.isUserInteractionEnabled = false
            noteNameTextField.isUserInteractionEnabled = false
            
        }
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        noteTextView.endEditing(true)
    }
    
    @objc private func mainButtonTapped(_ sender: UIButton) {
        if note?.name == "Getting Started" {
            creatingFirstNote?()
            borderLineBottom.isHidden = true
            mainButton.isHidden = true
            NSLayoutConstraint.activate([
                noteTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
            ])
            note = nil
            configureNoteText()
            noteTextView.isUserInteractionEnabled = true
            noteNameTextField.isUserInteractionEnabled = true
            
        } else {
            onDeleteTap?()
        }
    }
    
    @objc private func doneTapped(_ sender: UIBarButtonItem) {
        noteTextView.endEditing(true)
    }
}

extension EditNoteView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if note == nil || note?.name == "" {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
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
        if noteNameTextField.text == "Note title" || noteNameTextField.text == "" {
            note?.name = "No title"
        }
        if noteTextView.text == "Type here something..." {
            note?.text = ""
        }
        return note!
    }
}

extension UITextView {

    func addDoneButton(title: String, target: Any, action: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
