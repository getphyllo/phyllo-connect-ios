//
//  WaitVC.swift
//  PhylloConnect_Example
//
//  Created by Sanket on 22/08/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PhylloConnect

class WaitVC: UIViewController {
    
    var waitText = "Please wait"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImageView.setGIFImage(name: "loading")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loadingImageView.stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBOutlet weak var loadingImageView: UIImageView!
    
    
    @IBOutlet weak var waitLabel: UILabel!{
        didSet{
            waitLabel.text = waitText
        }
    }
    
    func launchSDK(workPlatformId : String){
        let phyllo = PhylloConnectSDK(configuration: PhylloConfig.shared)
        phyllo.launchSDK(workPlatformId: workPlatformId)
    }

}
