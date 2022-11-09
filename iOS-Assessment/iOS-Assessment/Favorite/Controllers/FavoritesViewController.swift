//
//  FavoritesViewController.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 08/11/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var users: [Item]?
    let userDefaults = UserDefaults.standard


    private var newTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: GitTableViewCell.identifier)
        return tableView
    }()
    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Uh oh! \nSeems you have no faves yet 😩"
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        users = userDefaults.faves
    }

    private func setupViews() {
        view.addSubview(newTableView)
        view.addSubview(emptyStateLabel)
        if self.users?.count == 0 {
            newTableView.isHidden = true
            self.emptyStateLabel.isHidden = false
        }else{
            newTableView.isHidden = false
            self.emptyStateLabel.isHidden = true
        }
        
        newTableView.dataSource = self
        newTableView.delegate = self
        NSLayoutConstraint.activate([
            newTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.users?.count == 0 {
            newTableView.isHidden = true
            self.emptyStateLabel.isHidden = false
        }else{
            newTableView.isHidden = false
            self.emptyStateLabel.isHidden = true
        }
    }
    
    func showLoadMoreSpinner() {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newTableView.bounds.width, height: CGFloat(44))
        newTableView.tableFooterView = spinner
    }
}




extension FavoritesViewController : UITableViewDelegate,UITableViewDataSource {
 
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                                                    withIdentifier: GitTableViewCell.identifier,
                                                    for: indexPath) as?
                GitTableViewCell else { return UITableViewCell() }
        if let data = users?[indexPath.row] {
            cell.recieveData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { ( _, _, completion) in
                self.userDefaults.faves?.remove(at: indexPath.row)
                self.users?.remove(at: indexPath.row)
                self.newTableView.reloadData()
                if self.users?.count == 0 {
                    tableView.isHidden = true
                    self.emptyStateLabel.isHidden = false
                }else{
                    tableView.isHidden = false
                    self.emptyStateLabel.isHidden = true
                }
                completion(true)
            }

            let buttonConfig = UISwipeActionsConfiguration(actions: [deleteButton])

            return buttonConfig
        }
}

