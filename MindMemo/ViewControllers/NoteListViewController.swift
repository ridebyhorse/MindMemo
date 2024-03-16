//
//  NoteListViewController.swift
//  MindMemo
//
//  Created by Мария Нестерова on 12.03.2024.
//

import UIKit

class NoteListViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        setupUI()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func setupUI() {
        let listView = NoteListView(notes: StorageManager.shared.getNotes())
        listView.onTap = goToEditController
        view = listView
    }
    
    private func goToEditController(_ note: Note?, _ index: Int?) {
        StorageManager.shared.setCurrentNoteIndex(index)
        navigationController?.pushViewController(EditNoteViewController(note: note), animated: true)
    }
}
