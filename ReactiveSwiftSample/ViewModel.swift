//
//  ViewModel.swift
//  ReactiveSwiftSample
//
//  Created by 伊藤凌也 on 2019/12/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import ReactiveSwift
import QiitaAPIKit

class ViewModel {

    typealias Elements = QiitaAPIKit.ArticleRequest.Response

    // Input
    let viewDidLoadObserver: Signal<Void, Never>.Observer

    // Output
    let items = MutableProperty<Elements>([])

    init() {
        let disposable = SerialDisposable()

        let viewDidLoadSignal = Signal<Void, Never>.pipe()
        self.viewDidLoadObserver = viewDidLoadSignal.input
        let producer = SignalProducer<Elements, Never> { observer, _ in
            QiitaAPIKit.ArticleRequest(requestQueryItem: .init(query: "iOS")).request { (result) in
                switch result {
                case .success(let response):
                    observer.send(value: response)
                case .failure:
                    observer.send(value: [])
                }
            }
        }

        disposable.inner = CompositeDisposable([
            self.items <~ viewDidLoadSignal.output
                .flatMap(.latest, { _ in producer })
                .observe(on: UIScheduler())
        ])
    }

    var numberOfSections: Int {
        return 1
    }

    func item(at indexPath: IndexPath) -> Elements.Element {
        return items.value[indexPath.row]
    }

    func numberOfItems(in section: Int) -> Int {
        return items.value.count
    }
}
