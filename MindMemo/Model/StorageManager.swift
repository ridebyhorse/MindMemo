//
//  StorageManager.swift
//  MindMemo
//
//  Created by Мария Нестерова on 14.03.2024.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    private var userDefaults = UserDefaults.standard
    private let key = "notes"
    private var currentNoteIndex = 0
    private let startNote = Note(name: "Getting Started", text: "MindMemo is a good helper to manage your notes. It gives you a quick and simple notepad editing experience when you write notes, memo or message. Go ahead and create your first note!")
    
    func setCurrentNoteIndex(_ index: Int?) {
        guard let index else { return }
        currentNoteIndex = index
    }
    
    func saveNote(_ note: Note) {
        if var notes = get(forKey: key) {
            notes.append(note)
            set(object: notes, forKey: key)
        } else {
            set(object: [note], forKey: key)
        }
    }
    
    func updateNote(_ note: Note) {
        if var notes = get(forKey: key) {
            notes.remove(at: currentNoteIndex)
            notes.insert(note, at: currentNoteIndex)
            set(object: notes, forKey: key)
        }
    }
    
    func deleteNote() {
        if var notes = get(forKey: key) {
            notes.remove(at: currentNoteIndex)
            if notes.isEmpty {
                remove(forKey: key)
            } else {
                set(object: notes, forKey: key)
            }
        }
    }
    
    func getNotes() -> [Note] {
        if let notes = get(forKey: key) {
            return notes
        } else {
            return [startNote]
        }
    }

    private func set(object: [Note], forKey key: String) {
        let jsonData = try? JSONEncoder().encode(object)
        userDefaults.set(jsonData, forKey: key)
    }
    
    private func get(forKey key: String) -> [Note]? {
        guard let data = userDefaults.object(forKey: key) as? Data else { return nil }
        return try? JSONDecoder().decode([Note]?.self, from: data)
    }
    
    private func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
}
