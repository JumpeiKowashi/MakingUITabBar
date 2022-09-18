//
//  ModalViewController.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit
import Combine

class ModalViewController: UIViewController {
    
    var colorViewModel: ColorModeViewModel
    var userViewModel: UserViewModel
    private var cancellables = Set<AnyCancellable>()

    let userLabel = UILabel()
    
    lazy var changeAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("アカウント変更", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50.0)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(tappedChangeAccountButton), for: .touchUpInside)
        return button
    }()
    
    init(colorViewModel: ColorModeViewModel, userViewModel: UserViewModel) {
        self.colorViewModel = colorViewModel
        self.userViewModel = userViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .darkGray

        changeAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changeAccountButton)
        NSLayoutConstraint.activate([
            changeAccountButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            changeAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLabel)
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: changeAccountButton.bottomAnchor),
            userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        colorViewModel.$backgroundColor
            .map({Optional($0)})
            .receive(on: DispatchQueue.main)
            .assign(to: \UIView.backgroundColor, on: view)
            .store(in: &cancellables)
        
        userViewModel.$user
            .map({"現在のユーザー：" + $0.username})
            .receive(on: DispatchQueue.main)
            .assign(to: \UILabel.text, on: userLabel)
            .store(in: &cancellables)
    }
    
    @objc func tappedChangeAccountButton() {
        userViewModel.changeUser("BBB", "Keigo")
    }
}
