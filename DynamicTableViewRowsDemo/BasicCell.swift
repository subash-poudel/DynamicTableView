//
//  BasicCell.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

typealias BasicCellTapCompletion = (String) -> ()

class BasicCellWrapper: DynamicRow {
    
    var title: String
    var completion: BasicCellTapCompletion?
    
    init(title: String, completion: BasicCellTapCompletion?) {
        self.title = title
        self.completion = completion
    }
    
    func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasicCell.self), for: indexPath) as! BasicCell
        cell.label.text = title
        return cell
    }
    
    func didSelectRow() {
        completion?(title)
    }
    
}
