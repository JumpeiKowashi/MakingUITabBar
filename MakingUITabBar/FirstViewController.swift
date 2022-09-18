//
//  FirstViewController.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit
import Combine

class FirstViewController: UIViewController {
    
    //MARK: - Properties
    
    var colorViewModel: ColorModeViewModel
    var userViewModel: UserViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var text: String = "aaa"
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "First"
        label.font = UIFont.boldSystemFont(ofSize: 70.0)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var changeColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("色を変更", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(tappedChangeColorButton), for: .touchUpInside)
        return button
    }()
    
    // 「2つ目のタブを選択」ボタンを追加
    lazy var selectSecondTabButton: UIButton = {
        let button = UIButton()
        button.setTitle("2つ目のタブを選択", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(tapSelectSecondTabButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    init(colorViewModel: ColorModeViewModel, userViewModel: UserViewModel) {
        self.colorViewModel = colorViewModel
        self.userViewModel = userViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerLabel)
        NSLayoutConstraint.activate([
            centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // 「2つ目のタブを選択」ボタンを配置し、タップ時のイベントを設定
        selectSecondTabButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectSecondTabButton)
        NSLayoutConstraint.activate([
            selectSecondTabButton.topAnchor.constraint(equalTo: centerLabel.bottomAnchor),
            selectSecondTabButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        changeColorButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changeColorButton)
        NSLayoutConstraint.activate([
            changeColorButton.topAnchor.constraint(equalTo: selectSecondTabButton.bottomAnchor),
            changeColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        userViewModel.$user
            .map({$0.username})
            .receive(on: DispatchQueue.main)
            .assign(to: \UILabel.text, on: centerLabel)
            .store(in: &cancellables)
        
        colorViewModel.$backgroundColor
            .map({Optional($0)})
            .receive(on: DispatchQueue.main)
            .assign(to: \UIView.backgroundColor, on: view)
            .store(in: &cancellables)
        
        colorViewModel.$textColor
            .map({Optional($0)})
            .receive(on: DispatchQueue.main)
            .assign(to: \UILabel.textColor, on: centerLabel)
            .store(in: &cancellables)
    }
    
    
    //MARK: - Actions
    @objc func tapSelectSecondTabButton() {
        // 2タブに切り替えることができる
        // このときはselectedIndexで操作しているためSecondViewControllerのViewが表示される
        // タブを押下すると、Modalが表示される
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func tappedChangeColorButton() {
        colorViewModel.changeColor()
    }
}
