//
//  MVVMViewController.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class MVVMViewController: UIViewController {
    @IBOutlet private var labels: [UILabel]! {
        didSet {
            labels.forEach { label in
                label.layer.cornerRadius = 4
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.lightGray.cgColor
                label.layer.masksToBounds = true
                label.textColor = UIColor.darkText
            }
        }
    }
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var upButton: UIButton!
    @IBOutlet private weak var downButton: UIButton!

    private lazy var viewModel = CounterViewModel(numberOfPlaceValues: self.labels.count)

    override func viewDidLoad() {
        super.viewDidLoad()

        upButton.addTarget(viewModel, action: #selector(CounterViewModel.incrementEachPlaceValues), for: .touchUpInside)
        downButton.addTarget(viewModel, action: #selector(CounterViewModel.decrementEachPlaceValues), for: .touchUpInside)
        incrementButton.addTarget(viewModel, action: #selector(CounterViewModel.increment), for: .touchUpInside)

        labels.enumerated().forEach { viewModel.observePlaceValues(at: $0.offset, bindTo: $0.element, \.text) }
    }
}
