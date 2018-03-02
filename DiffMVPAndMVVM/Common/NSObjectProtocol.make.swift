//
//  NSObjectProtocol.make.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

extension NSObjectProtocol where Self: UIViewController {
    static func makeFromNib() -> Self {
        let nibName = String(describing: self)
        let vc = Self(nibName: nibName, bundle: nil)
        vc.navigationItem.title = nibName
        vc.tabBarItem = UITabBarItem(title: nibName, image: nil, selectedImage: nil)
        return vc
    }
}
