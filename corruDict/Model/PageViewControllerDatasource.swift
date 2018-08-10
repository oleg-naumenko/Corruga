//
//  PageViewControllerDatasource.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import RealmSwift

class PageViewControllerDatasource: NSObject, UIPageViewControllerDataSource {

    private let dictModel:DictModel
    var displayedEntries:Results<TranslationEntity>?
    var currentIndex:Int = 0
    
    private let imageProvider = ImageProvider()
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        super.init()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = self.displayedEntries?.index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = self.displayedEntries?.index(of: (viewController as! DetailViewController).viewModel.entry)
        {
            return self.viewControllerForIndex(index: index + 1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.displayedEntries?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func viewControllerForIndex(index:Int) -> DetailViewController?
    {
        if (index < 0 || index >= (self.displayedEntries?.count)!) {
            return nil
        }
        let detailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        if let entry = self.displayedEntries?[index] {
            let translationValue = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
            detailViewController?.viewModel = DetailViewModel(term:entry.stringValue, translation:translationValue ?? "<no translation>", langID:self.dictModel.toStorage.languageID, entry: entry, imagePath:self.imageProvider.randomImageName())
            currentIndex = index
            return detailViewController
        }
        return nil
    }
    
}
