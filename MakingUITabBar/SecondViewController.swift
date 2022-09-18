//
//  SecondViewController.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit
import Combine

class SecondViewController: UIViewController {
    
    let viewModel: ColorModeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "Second"
        label.font = UIFont.boldSystemFont(ofSize: 70.0)
        label.textColor = UIColor.black
        return label
    }()

    init(viewModel: ColorModeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerLabel)
        NSLayoutConstraint.activate([
            centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        viewModel.$backgroundColor
            .map({Optional($0)})
            .receive(on: DispatchQueue.main)
            .assign(to: \UIView.backgroundColor, on: view)
            .store(in: &cancellables)

        viewModel.$textColor
            .map({Optional($0)})
            .receive(on: DispatchQueue.main)
            .assign(to: \UILabel.textColor, on: centerLabel)
            .store(in: &cancellables)

    }
}


