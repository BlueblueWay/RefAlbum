//
//  ViewController.swift
//  RefAlbum
//
//  Created by lingshun kong on 11/23/21.
//

import UIKit
import SwiftUI


class ViewController: UIViewController {


    
    
    let contentView = UIHostingController(rootView: SwiftUIView())


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addChild(contentView)
        view.addSubview(contentView.view)
        setup()
    }
    
    func setup() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
}
