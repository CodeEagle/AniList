//
//  ViewController.swift
//  AniList
//
//  Created by CodeEagle on 05/19/2016.
//  Copyright (c) 2016 CodeEagle. All rights reserved.
//

import UIKit
import AniList

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		AniAPIManager.register(<#clientId#>, clientSecret: <#clientSecret#>)
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

