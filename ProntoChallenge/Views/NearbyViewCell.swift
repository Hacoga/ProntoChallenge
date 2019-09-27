//
//  NearbyViewCell.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit

final class NearbyViewCell: UITableViewCell {
    private let dataProvider = GoogleDataProvider()
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeHolderFood")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let restaurantTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14.0)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let priceRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14.0)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let ratingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14.0)
        label.textColor = .orangeMexican
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        selectionStyle = .none
        addSubviews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupContentView()
        setupRestaurantImageView()
        setupRestaurantTitleLabel()
        setupCategoryLabel()
    }
    
    private func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(restaurantImageView)
        containerView.addSubview(restaurantTitleLabel)
        containerView.addSubview(categoryLabel)
    }
    
    
    private func setupContentView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
    }
    
    private func setupRestaurantImageView() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            restaurantImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 120),
            restaurantImageView.widthAnchor.constraint(equalToConstant: 120)
            ])
    }
    
    private func setupRestaurantTitleLabel() {
        NSLayoutConstraint.activate([
            restaurantTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            restaurantTitleLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 5),
            restaurantTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            ])
    }
    
    private func setupCategoryLabel() {
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 5)
            ])
    }
    
    func fillData(using model: NearbyLocationModel) {
        restaurantTitleLabel.text = model.name
        dataProvider.fetchPhotoFromReference(model.reference) {
            [weak self] image in
            guard let self = self else { return }
            self.restaurantImageView.image = image
        }
    }
}
