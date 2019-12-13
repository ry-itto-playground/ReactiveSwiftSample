//
//  DataSource.swift
//  ReactiveSwiftSample
//
//  Created by 伊藤凌也 on 2019/12/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class DataSource: NSObject, ReactiveDataSource {
    var backgroundView: SignalProducer<UIView?, Never> = .init { UIView() }

    var elementsChanged: Signal<(), Never> {
        return viewModel.items.map { _ in }.signal
    }

    var emptyView: UIView = UIView()

    var dataSource: UITableViewDataSource {
        self
    }

    var isScrollEnabled: Property<Bool> = .init(value: true)

    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension DataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = viewModel.item(at: indexPath)
        cell.textLabel?.text = item.title

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
}
