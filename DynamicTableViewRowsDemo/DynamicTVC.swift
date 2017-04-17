//
//  ViewController.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

class DynamicTVC: UITableViewController {
  
  var sections: [DynamicSection] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerRows()
    setupTableViewSectionAndRows()
  }
  
  private func setupTableViewSectionAndRows() {
    // basic section
    let appleCell = BasicCellWrapper(title: "Apple") { [weak self] text in
      self?.showAlert(with: text)
    }
    
    let mangoCell = BasicCellWrapper(title: "Mango") { [weak self] text in
      self?.showAlert(with: text)
    }
    let fruitsSection = BasicSection(title: "Fruits", rows: [appleCell, mangoCell])
    sections.append(fruitsSection)
    
    // switch section
    let pineappleCell = BasicCellWrapper(title: "PineappleCell") { [weak self] text in
      self?.showAlert(with: text)
    }
    let switchCell = SwitchCellWrapper(title: "More Fruits")
    let strawberryCell = BasicCellWrapper(title: "StrawBerry") { [weak self] text in
      self?.showAlert(with: text)
    }
    let switchSection = SwitchSection(title: "More Fruits I like",
                                      requiredRows: [pineappleCell, switchCell],
                                      optionalRows: [strawberryCell], switchRow: switchCell){ [weak self] _ in
                                        self?.tableView.reloadData()
    }
    sections.append(switchSection)
    addSection()
  }
  
  private func addSection() {
    sections.append(getFavouriteSection())
  }
  
  private func removeSection() {
    sections.removeLast()
  }
  
  private func registerRows() {
    let basicCellNib = UINib(nibName: "BasicCell", bundle: nil)
    self.tableView.register(basicCellNib, forCellReuseIdentifier: String(describing: BasicCell.self))
    let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
    self.tableView.register(textFieldCellNib, forCellReuseIdentifier: String(describing: TextFieldCell.self))
    let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)
    self.tableView.register(switchCellNib, forCellReuseIdentifier: String(describing: SwitchCell.self))
    let favouriteHeaderNib = UINib(nibName: "FavouriteHeader", bundle: nil)
    self.tableView.register(favouriteHeaderNib, forCellReuseIdentifier: String(describing: FavouriteHeader.self))
  }
  
  private func showAlert(with message: String) {
    let alertVC = UIAlertController(
      title: "Alert",
      message: message,
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    alertVC.addAction(okAction)
    present(alertVC, animated: true, completion: nil)
  }
  
  private func getFavouriteSection() -> FavouriteSection {
    let grapes = BasicCellWrapper(title: "I love grapes") { [weak self] text in
      self?.showAlert(with: text)
    }
    let addSection = {[weak self] in
      self?.addSection()
      self?.tableView.reloadData()
    }
    let removeSection = { [weak self] in
      self?.removeSection()
      self?.tableView.reloadData()
    }
    let fruitsSection = FavouriteSection(title: "I love", rows: [grapes], addSection: addSection, removeSection: removeSection)
    return fruitsSection
  }
  
}

// #MARK datasource and delegate methods of tableview

extension DynamicTVC {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = sections[indexPath.section].rows[indexPath.row]
    let cell = row.getCellFor(tableView, indexPath: indexPath)
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    row.didSelectRow()
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return sections[section].header(tableView: tableView)
  }
  
}
