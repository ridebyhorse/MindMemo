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
