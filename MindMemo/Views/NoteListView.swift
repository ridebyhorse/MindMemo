//
//  NoteListView.swift
//  MindMemo
//
//  Created by Мария Нестерова on 12.03.2024.
//

import UIKit

class NoteListView: UIView {
    
    var onTap: ((_ note: Note?, _ index: Int?) -> Void)?
    private let notes: [Note]
    
    private let noteListLabel: UILabel = {
        let noteListLabel = UILabel()
        noteListLabel.font = UIFont(name: "Montserrat-SemiBold", size: 34)
        noteListLabel.textColor = .black
        noteListLabel.text = "My notes"
        
        return noteListLabel
    }()
    
    private let borderLineTop: UIView = {
        let borderLineTop = UIView()
        borderLineTop.backgroundColor = .systemGray
        borderLineTop.alpha = 0.5
        
        return borderLineTop
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
       
        
        return tableView
    }()
    
    private let borderLineBottom: UIView = {
        let borderLineBottom = UIView()
        borderLineBottom.backgroundColor = .systemGray
        borderLineBottom.alpha = 0.5
        
        return borderLineBottom
    }()
    
    private let newNoteButton: UIButton = {
        let newNoteButton = UIButton()
        newNoteButton.backgroundColor = .black
        newNoteButton.setImage(UIImage(systemName: "plus"), for: .normal)
        newNoteButton.imageView?.tintColor = .white
        newNoteButton.addTarget(self, action: #selector(newNoteButtonTapped), for: .touchUpInside)
        
        return newNoteButton
    }()
    
    init(notes: [Note]) {
        self.notes = notes
        super.init(frame: .zero)
        configureTableiew()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        newNoteButton.layer.cornerRadius = newNoteButton.frame.width / 2
        newNoteButton.clipsToBounds = true
    }
    
    private func configureTableiew() {
        tableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: "noteCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(noteListLabel)
        addSubview(borderLineTop)
        addSubview(tableView)
        addSubview(borderLineBottom)
        addSubview(newNoteButton)
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            noteListLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            noteListLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            noteListLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            borderLineTop.heightAnchor.constraint(equalToConstant: 1),
            borderLineTop.widthAnchor.constraint(equalTo: widthAnchor),
            borderLineTop.topAnchor.constraint(equalTo: noteListLabel.bottomAnchor, constant: 16),
            borderLineTop.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderLineBottom.heightAnchor.constraint(equalToConstant: 1),
            borderLineBottom.widthAnchor.constraint(equalTo: widthAnchor),
            borderLineBottom.centerXAnchor.constraint(equalTo: centerXAnchor),
            borderLineBottom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -92),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: borderLineTop.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: borderLineBottom.topAnchor),
            newNoteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newNoteButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            newNoteButton.heightAnchor.constraint(equalTo: newNoteButton.widthAnchor),
            newNoteButton.centerYAnchor.constraint(equalTo: borderLineBottom.centerYAnchor)
        ])
    }
    
    @objc private func newNoteButtonTapped(_ sender: UIButton) {
        onTap?(nil, nil)
    }
}

extension NoteListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteListTableViewCell
        cell.setupUI(with: notes[indexPath.row])
        
        return cell
    }    
}

extension NoteListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTap?(notes[indexPath.row], indexPath.row)
    }
}
