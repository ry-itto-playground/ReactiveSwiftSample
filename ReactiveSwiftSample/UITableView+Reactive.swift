//
//  UITableView+Reactive.swift
//  ReactiveSwiftSample
//
//  Created by 伊藤凌也 on 2019/12/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

protocol ReactiveDataSource: AnyObject, UITableViewDataSource {
    var backgroundView: SignalProducer<UIView?, Never> { get }
    var elementsChanged: Signal<(), Never> { get }
    var emptyView: UIView { get }
    var isScrollEnabled: Property<Bool> { get }
}

extension Reactive where Base: UITableView {
    /// Set up a reactive data source binding. Uses the binding target internally.
    func setDataSource<T: ReactiveDataSource>(_ dataSource: T) {
        self.dataSource.action(dataSource)
    }

    /// A binding target that allows you to dynamically update the data source over time.
    var dataSource: BindingTarget<ReactiveDataSource> {
        let disposable = SerialDisposable()
        lifetime += disposable
        return makeBindingTarget { base, dataSource in
            disposable.inner?.dispose()
            base.dataSource = dataSource
            disposable.inner = CompositeDisposable([
                base.reactive.backgroundView <~ dataSource.backgroundView,
                base.reactive.isScrollEnabled <~ dataSource.isScrollEnabled,
                base.reactive.reloadData <~ dataSource.elementsChanged,
            ])
            base.reloadData()
        }
    }

    var backgroundView: BindingTarget<UIView?> {
        return makeBindingTarget { $0.backgroundView = $1 }
    }
}

