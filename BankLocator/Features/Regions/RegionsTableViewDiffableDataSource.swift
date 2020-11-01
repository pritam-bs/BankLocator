//
//  RegionsTableViewDiffableDataSource.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import UIKit

class RegionsTableViewDiffableDataSource: UITableViewDiffableDataSource<Country, Region> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section].name
    }
}
