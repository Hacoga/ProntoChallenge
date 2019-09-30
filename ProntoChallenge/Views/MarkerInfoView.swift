//
//  MarkerInfoView.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit

final class MarkerInfoView: UIView {
    var nameTextPin = "" {
        didSet {
            nameLabel.text = nameTextPin
        }
    }
    var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect.zero
        return containerView
    }()
    var placePhoto: UIImageView = {
        let placePhoto = UIImageView()
        placePhoto.layer.masksToBounds = true
        placePhoto.layer.cornerRadius = 10
        return placePhoto
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRounds()
        addSubViews()
        setupViews()
    }
    
    private func setupRounds() {
        layer.masksToBounds = true
        layer.cornerRadius = 13
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(placePhoto)
    }
    
    private func setupViews() {
        setupContainerView()
        setupNameLabel()
        setupPlacePhoto()
    }
    
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 35)])
    }
    
    private func setupPlacePhoto() {
        placePhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placePhoto.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            placePhoto.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            placePhoto.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            placePhoto.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)])
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 300)])
    }
}
