// SceneDelegate.swift
// Copyright (c) 2022 Aliia Umergalina
// Created on 08.08.2022.

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Internal

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.systemBlue
    }

    // MARK: Private

    private func makeRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeDictionaryController(), makeLikedWordsController()]
        return tabBarController
    }

    private func makeDictionaryController() -> UIViewController {
        let navigationController = UINavigationController()
        let dictionaryController = DictionaryViewController()
        navigationController.viewControllers = [dictionaryController]
        navigationController.tabBarItem.title = "Словарь"
        navigationController.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.portrait")
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    private func makeLikedWordsController() -> UIViewController {
        let navigationController = UINavigationController()
        let likedWordsController = LikedWordsController(model: LikedWordsModel())
        navigationController.viewControllers = [likedWordsController]
        navigationController.tabBarItem.title = "Избранное"
        navigationController.tabBarItem.image = UIImage(systemName: "star.fill")!
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
