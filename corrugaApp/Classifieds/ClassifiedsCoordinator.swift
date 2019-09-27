//
//  ClassifiedsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 10/5/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class ClassifiedsCoordinator: BaseFeatureCoordinator {
    
    let newsViewController:NewsViewController
    
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        super.init()
        self.newsViewController.navigationDelegate = self
        self.newsViewController.viewModel = NewsViewModel(itemSource: NewsSource(itemType: .boardItemType))
        self.start(viewController: newsViewController)
    }
}

extension ClassifiedsCoordinator: NewsViewControllerDelegate {
    func newsViewControllerDidSelect(item : NewsItem) {
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "NewsItemViewController") as! WebItemViewController
        itemViewController.urlString = item.url
        itemViewController.title = item.title
        self.newsViewController.navigationController?.pushViewController(itemViewController, animated: true)
    }
}
