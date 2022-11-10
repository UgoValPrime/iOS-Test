//
//  GitDetailsViewController.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

import UIKit
import SafariServices
import GitModels
import GitUtility

class GitDetailsViewController: UIViewController {
 
    let userDefaults = UserDefaults.standard
    let gitDetailsView = GitDetailsView()
    var viewModel: GitViewModel?
    var parsedData: Item?
    var following: Int?
    var follower: Int?
    var favArr = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubView()
        favArr = userDefaults.faves ?? []
    }
    
    func openLink(_ url : URL) {
        let safariVc = SFSafariViewController(url: url)
        self.navigationController?.present(safariVc, animated: true, completion: nil)
    }

    func setupSubView() {
        view.addSubview(gitDetailsView)
        let details = parsedData
        if let details = details {
            gitDetailsView.configureView(details, ffr: follower ?? 0, ffl: following ?? 0)
            
        }
       

        gitDetailsView.appendToFavArray = {[weak self] in

            self?.favArr.append((self?.parsedData)!)
            let setArr = self?.favArr.removingDuplicates()
            if setArr == self?.favArr {
                if self?.favArr.count == 0 {
                    self?.gitDetailsView.favConditinLabel.text = "Uh oh! you don't have any favs"
                    self?.gitDetailsView.favConditinLabel.isHidden = false
                }
              print("now you can dance")
                self?.userDefaults.faves = self?.favArr
                self?.gitDetailsView.favConditinLabel.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.gitDetailsView.favConditinLabel.isHidden = true
                   }
            }else{
                self?.favArr.removeLast()
                self?.gitDetailsView.favConditinLabel.text = "This is already a fav"
                self?.gitDetailsView.favConditinLabel.isHidden = false
                self?.gitDetailsView.favConditinLabel.backgroundColor = .gray
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.gitDetailsView.favConditinLabel.isHidden = true
                   }
            }
            
            
        }

        gitDetailsView.editTapped = { [weak self] link in
            self?.openLink(link)
        }

        NSLayoutConstraint.activate([
            gitDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gitDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gitDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gitDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}



