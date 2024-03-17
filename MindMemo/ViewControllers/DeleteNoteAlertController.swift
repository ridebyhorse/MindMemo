//
//  DeleteNoteAlertController.swift
//  MindMemo
//
//  Created by Мария Нестерова on 17.03.2024.
//

import UIKit

class DeleteNoteAlertController: UIViewController {

    var onDelete: (() -> Void)?
    
    let alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12
        alertView.layer.shadowColor = UIColor.systemGray.cgColor
        alertView.layer.shadowOpacity = 0.5
        alertView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        return alertView
    }()
    
    let deleteLabel: UILabel = {
        let deleteLabel = UILabel()
        deleteLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        deleteLabel.textColor = .black
        deleteLabel.textAlignment = .center
        deleteLabel.text = "Delete note?"
        
        return deleteLabel
    }()
    
    let deleteImageView: UIImageView = {
        let deleteImageView = UIImageView()
        deleteImageView.image = .delete
        deleteImageView.contentMode = .scaleAspectFit
        
        return deleteImageView
    }()
    
    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        return cancelButton
    }()
    
    let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.titleLabel?.textAlignment = .center
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        return deleteButton
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        view.addSubview(alertView)
        view.addSubview(deleteLabel)
        view.addSubview(deleteImageView)
        view.addSubview(cancelButton)
        view.addSubview(deleteButton)
        view.subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            deleteLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            deleteLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 18),
            deleteImageView.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 12),
            deleteImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            deleteImageView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            deleteImageView.widthAnchor.constraint(equalTo: deleteLabel.widthAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: deleteImageView.bottomAnchor, constant: 18),
            cancelButton.trailingAnchor.constraint(equalTo: alertView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -12),
            deleteButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)
        ])
    }
    
    @objc private func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func deleteTapped(_ sender: UIButton) {
        onDelete?()
        dismiss(animated: true)
    }

}
