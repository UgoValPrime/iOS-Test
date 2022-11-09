//
//  GitHomeViewController.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 05/11/2022.
//

import UIKit

class GitHomeViewController: UIViewController{

    
    var users = [Item]()
    var viewModel: GitViewModel?
    let userDefaults = UserDefaults.standard
    let queue = DispatchQueue(label: Controller.monitor)
    var gitLoggers: [Item]?
    var sortedLetters: [String]?
    var sections: [[Item]]?
    var isLastPageLoaded = false
    var pageNumber = 1
    var isWaiting = false
    var totalEntries: Int?
    var following: Int?
    var follower: Int?
    var spinner  = UIActivityIndicatorView()
    var details: Item?
    

    private var newTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: GitTableViewCell.identifier)
        return tableView
    }()
    
    private var favBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setup()
    }
    
    @objc func showFavs() {
        let vc = FavoritesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupViews() {
        [newTableView,spinner,favBtn].forEach { view.addSubview($0)}
        newTableView.dataSource = self
        newTableView.delegate = self
        spinner.color = .black
        spinner.backgroundColor = .blue
        favBtn.addTarget(self, action: #selector(showFavs), for: .touchUpInside)
        NSLayoutConstraint.activate([
            newTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50),
            favBtn.bottomAnchor.constraint(equalTo: newTableView.bottomAnchor, constant: -80),
            favBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,  constant: -30),
            favBtn.heightAnchor.constraint(equalToConstant: 50),
            favBtn.widthAnchor.constraint(equalToConstant: 50)
            
            
        ])
    }
    
    func gotoDetailsPage() {
        let vc = GitDetailsViewController()
        let vm = GitViewModel()
        vc.viewModel = vm
        vc.following = following
        vc.follower = follower
        vm.details = details
        vc.parsedData = details
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoadMoreSpinner() {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newTableView.bounds.width, height: CGFloat(44))
        newTableView.tableFooterView = spinner
    }
    
    fileprivate func setup() {
        viewModel?.delegate = self
        viewModel?.monitorNetwork()
        viewModel?.monitor.start(queue: queue)
        viewModel?.receiveData(pageNumber)
        viewModel?.pageNumber = pageNumber
    }
}




extension GitHomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                                                    withIdentifier: GitTableViewCell.identifier,
                                                    for: indexPath) as?
                GitTableViewCell else { return UITableViewCell() }
        if let data = sections?[indexPath.section][indexPath.row] {
            cell.recieveData(data)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        header.backgroundColor = .tertiarySystemGroupedBackground
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: header.frame.size.width, height: header.frame.size.height - 10))
        headerLabel.text = "\(sortedLetters?[section] ?? "")"
        headerLabel.font = .systemFont(ofSize: 20, weight: .medium)
        header.addSubview(headerLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard sections?.count ?? 0 > 0, indexPath.section == (sections?.count ?? 0) - 1 else {
            return
        }
        if let gitLoggers = gitLoggers {
            if indexPath.section == (sections?.count ?? 0) - 1 {
                if gitLoggers.count < totalEntries ?? 0 {
                    pageNumber+=1
                    self.viewModel?.receiveData(pageNumber)
                }
            }
        }
     
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        spinner.startAnimating()
        let followingg  = sections?[indexPath.section][indexPath.row].followingURL.dropLast(13)
            details = sections?[indexPath.section][indexPath.row]
            viewModel?.followingData(String(followingg!))
            viewModel?.follwersData(sections?[indexPath.section][indexPath.row].followersURL ?? "")
           
    }
}

extension GitHomeViewController: GitDelegate {
    func didRecieveFollowersData(_ data: [FollowResponeData]) {
        follower = data.count
        gotoDetailsPage()
    }
    
    func didRecieveFollowingData(_ data:[FollowResponeData] ) {
        following = data.count
    }
   
    
    func didReceiveData(_ data: GitDataResponse?) {
        if let data = data {
            totalEntries = data.totalCount
            for item in data.items {
                users.append(item)
            }
        }
        totalEntries = data?.totalCount
        gitLoggers = users
        if let gitLoggers = gitLoggers {
            let firstLetters = gitLoggers.map { $0.headerFirstLetter}
            let uniqueLetters = Array(Set(firstLetters))
            sortedLetters = uniqueLetters.sorted()
            
            if let sortedLetters = sortedLetters {
                sections = sortedLetters.map { firstLetter in
                    return gitLoggers
                        .filter { $0.headerFirstLetter == firstLetter}.sorted { $0.login < $1.login}
                }
            }
        }
        
        DispatchQueue.main.async {
            self.newTableView.reloadData()
        }
        
    }
}
