//
//  NoteListTableViewCell.swift
//  MindMemo
//
//  Created by Мария Нестерова on 13.03.2024.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 12
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.systemGray.cgColor
        
        return background
    }()
    
    private let noteNameLabel: UILabel = {
        let noteNameLabel = UILabel()
        noteNameLabel.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        noteNameLabel.textColor = .black
        noteNameLabel.numberOfLines = 2
        
        return noteNameLabel
    }()
    
    private let noteDescriptionLabel: UILabel = {
        let noteDescriptionLabel = UILabel()
        noteDescriptionLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        noteDescriptionLabel.textColor = .black
        noteDescriptionLabel.numberOfLines = 2
        
        return noteDescriptionLabel
    }()
    
    func setupUI(with note: Note) {
        backgroundColor = .clear
        
        noteNameLabel.text = note.name
        noteDescriptionLabel.text = note.text
        
        contentView.addSubview(background)
        contentView.addSubview(noteNameLabel)
        contentView.addSubview(noteDescriptionLabel)
        contentView.subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            noteNameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12),
            noteNameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 14),
            noteNameLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
            noteDescriptionLabel.leadingAnchor.constraint(equalTo: noteNameLabel.leadingAnchor),
            noteDescriptionLabel.topAnchor.constraint(equalTo: noteNameLabel.bottomAnchor, constant: 4),
            noteDescriptionLabel.trailingAnchor.constraint(equalTo: noteNameLabel.trailingAnchor),
            noteDescriptionLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -14)
        ])
    }
}
