//
//  DataSource.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTableDataSource: NSObject, UITableViewDataSource
{
    static private let kCellID = "EntryCell"
    
    private let dictModel:DictModel
    
//    var displayedEntries:Results<TranslationEntity>?
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dictModel.searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableDataSource.kCellID, for: indexPath)
        if let entry = self.dictModel.searchResults?[indexPath.row] {
            
            let range = (entry.stringValue as NSString).range(of: self.dictModel.currentSearchTerm)
            
            let attrString = NSMutableAttributedString(string: entry.stringValue)
            attrString.setAttributes([NSBackgroundColorAttributeName : UIColor(red: 1, green: 1, blue: 0, alpha: 0.2)], range: range)
            
            cell.textLabel?.attributedText = attrString
            cell.detailTextLabel?.text = self.dictModel.toStorage.translation(withID: entry.termID)?.stringValue
            
            let isEven = (Int(indexPath.row % 2) == 0)
            cell.backgroundColor = UIColor.init(white: isEven ? 0.96 : 1.0, alpha: 1)
        }
        return cell
    }
    
    func footerTotal() -> String {
        return TotalLabelViewModel(total: self.dictModel.searchResults?.count ?? 0).output
    }
    
    func languagesLabel() -> String {
        if let fromLang = self.dictModel.fromStorage.languageID.components(separatedBy: "_").first,
            let toLang = self.dictModel.toStorage.languageID.components(separatedBy: "_").first
        {
            return "\(fromLang.uppercased()) -> \(toLang.uppercased())"
        }
        
        return "XX -> YY"
    }
}