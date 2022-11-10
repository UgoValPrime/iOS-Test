//
//  GitHomeTableView.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 05/11/2022.
//

import UIKit
import GitModels
import GitUtility

class GitDetailsView: UIView {

    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1550922005)
        return view
    }()

    lazy var viewTitleLabel: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.textAlignment = .center
        viewTitle.text = "Profile"
        viewTitle.font = UIFont.boldSystemFont(ofSize: viewTitle.font.pointSize)
        return viewTitle
    }()

    lazy var profileImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0327676786)
        return view
    }()

    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 45
        image.backgroundColor = .red
        return image
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()

    lazy var editProfileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        return image
    }()

    lazy var editProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .link
        label.text = "See my github Profile"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(editTap))
        label.addGestureRecognizer(tap)
        return label
    }()

    lazy var editProfileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.editProfileImage, self.editProfileLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    lazy var notificationProfileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        image.image = UIImage(systemName: "person")
        image.tintColor = .black
        return image
    }()

    lazy var notificationProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Followers | 0"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var notificationProfileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.notificationProfileImage, self.notificationProfileLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    lazy var changePasswordProfileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "person")
        image.tintColor = .black
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return image
    }()

    lazy var changePasswordProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Following | 35"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var changePasswordProfileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.changePasswordProfileImage, self.changePasswordProfileLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()


    
    lazy var addFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Favs", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()
    
    lazy var favConditinLabel: UILabel = {
     let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.textAlignment = .center
        label.text = "Fav added successfully"
        label.textColor = .white
        label.layer.cornerRadius = 15
        label.backgroundColor = .green
        label.layer.masksToBounds = true
        return label
    }()
    
    var logoutTapped: ((URL)-> Void)?
    var editTapped: ((URL)-> Void)?
    var notificationTapped: ((URL)-> Void)?
    var changePasswordTapped: ((URL)-> Void)?
    var editImageTapped: ((URL)-> Void)?
    var appendToFavArray: (()-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var followersLink : String?
    var followingLink : String?
    var reposLink : String?
    var starLink: String?


    @objc func editTap() {
        let url = URL(string: followingLink ?? String())!
        editTapped?(url)
    }

    @objc func buttonTapped() {
        appendToFavArray?()
    }

    
    func configureView(_ data: Item, ffr: Int, ffl: Int) {
        nameLabel.text = data.login
        changePasswordProfileLabel.text = "Followers | \(ffr)"
        notificationProfileLabel.text = "Following | \(ffl)"
        editProfileImage.downloadImage(from: data.avatarURL)
        profileImage.downloadImage(from: data.avatarURL)
        followingLink = data.htmlURL
        followersLink = data.followersURL
        reposLink = data.reposURL
        starLink = data.starredURL
    }


    func setupSubviews() {
        [topView, lineView, profileImageView,
         editProfileStackView, notificationProfileStackView,
         changePasswordProfileStackView, addFavoriteButton, favConditinLabel].forEach { self.addSubview($0) }

        topView.addSubview(viewTitleLabel)
        [profileImage, nameLabel].forEach { profileImageView.addSubview($0) }
        addFavoriteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        favConditinLabel.isHidden = true

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 30),

            viewTitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            viewTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8),

            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),

            profileImageView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 187),

            profileImage.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 32),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -32),

            editProfileStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            editProfileStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            notificationProfileStackView.topAnchor.constraint(equalTo: editProfileStackView.bottomAnchor, constant: 35),
            notificationProfileStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            changePasswordProfileStackView.topAnchor.constraint(equalTo: notificationProfileStackView.bottomAnchor, constant: 35),
            changePasswordProfileStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            addFavoriteButton.topAnchor.constraint(equalTo:   changePasswordProfileStackView.bottomAnchor, constant: 50),
            addFavoriteButton.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            addFavoriteButton.heightAnchor.constraint(equalToConstant: 50),
            addFavoriteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            addFavoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            
            favConditinLabel.topAnchor.constraint(equalTo:   addFavoriteButton.bottomAnchor, constant: 70),
            favConditinLabel.heightAnchor.constraint(equalToConstant: 30),
            favConditinLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            favConditinLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50)
        ])
    }
}
