//
//  MVPViewController.swift
//  DiffMVPAndMVVM
//
//  Created by 鈴木大貴 on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

protocol CounterView: class {
    func updateLabel(at index: Int, text: String)
}

final class MVPViewController: UIViewController, CounterView {
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

    private lazy var presenter = CounterPresenter(numberOfPlaceValues: self.labels.count,
                                                  view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        incrementButton.addTarget(presenter, action: #selector(CounterPresenter.incrementButtonTap), for: .touchUpInside)
        upButton.addTarget(presenter, action: #selector(CounterPresenter.upButtonTap), for: .touchUpInside)
        downButton.addTarget(presenter, action: #selector(CounterPresenter.downButtonTap), for: .touchUpInside)
    }

    func updateLabel(at index: Int, text: String) {
        labels[index].text = text
    }
}
