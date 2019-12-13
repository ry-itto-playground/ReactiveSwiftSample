//
//  ViewController.swift
//  ReactiveSwiftSample
//
//  Created by 伊藤凌也 on 2019/12/10.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import QiitaAPIKit

class ViewController: UITableViewController {

    let viewModel = ViewModel()
    let dataSource: DataSource

    init() {
        fatalError()
    }

    required init?(coder: NSCoder) {
        self.dataSource = DataSource(viewModel: viewModel)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reactive.setDataSource(dataSource)
        viewModel.viewDidLoadObserver.send(value: ())
    }
}
