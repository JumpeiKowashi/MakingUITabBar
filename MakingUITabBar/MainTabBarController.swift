//
//  MainTabBarController.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit
import Combine

class MainTabBarController: UITabBarController {
    
    let colorViewModel = ColorModeViewModel()
    let userViewModel = UserViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // ここで適用するクラスを指定
        object_setClass(tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              let customTabBar = tabBar as? CustomTabBar,
              let imageView = customTabBar.barItemImage(index: index) else {
            return
        }
        iconBounceAnimation(view: imageView)
    }
    
    // タップ時のbounce
    func iconBounceAnimation(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }, completion: nil)
    }
}

private extension MainTabBarController {
    func setupTab() {
        delegate = self
        
        let firstViewController = FirstViewController(colorViewModel: colorViewModel, userViewModel: userViewModel)
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        
        let secondViewController = SecondViewController(viewModel: colorViewModel)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        
        let thirdViewController = ThirdViewController(viewModel: colorViewModel)
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        viewControllers = [firstViewController, secondViewController, thirdViewController]
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    // shouldSelectメソッドを実装
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // falseを返却することでActiveなタブをそのままにしておくことができる。
        // そのため、2つ目のタブをタップしても選択されているタブは変更されない。
        
        if viewController == tabBarController.viewControllers?[1] {
            present(ModalViewController(colorViewModel: colorViewModel, userViewModel: userViewModel), animated: true, completion: nil)
            return false
        }
        return true
    }
}


// Tabbarを継承したクラスをつくる
class CustomTabBar: UITabBar {
    // 高さを変える関数
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        sizeThatFits.height += safeAreaInsets.bottom
        return sizeThatFits
    }
    
    
    // indexを受け取り、タブのUIImageViewを返却する
    func barItemImage(index: Int) -> UIImageView? {
        let view = subviews[index + 1]
        return view.recursiveSubviews.compactMap { $0 as? UIImageView }
            .first
    }
}

extension UIView {
    // 再起的にsubviewsを取得
    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}
