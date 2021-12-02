//
//  ViewController.swift
//  PhylloConnect
//
//  Created by Sanket on 08/13/2021.
//  Copyright (c) 2021 Sanket. All rights reserved.
//

import UIKit
import PhylloConnect

class ViewController: UIViewController {

    var phylloConfig = PhylloConfig()
    //Set enviroment
    var env = PhylloEnvironment.sandbox
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBOutlet weak var existingUser: UIButton!{
        didSet{
            if(G.userId.isEmpty){
                existingUser.isEnabled = false
            }
            existingUser.setImage(UIImage(named:"unchecked"), for: .normal)
            existingUser.setImage(UIImage(named:"checked"), for: .selected)
        }
    }
    
    
    @IBOutlet weak var platformBtm: UIButton! {
        didSet{
            platformBtm.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var instagramBtn: UIButton!{
        didSet{
            instagramBtn.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var youtubeBtn: UIButton!{
        didSet{
            youtubeBtn.layer.cornerRadius = 4
        }
    }
    
    
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        initLaunch(workPlatformId: "")
    }
    
    
    @IBAction func instagramBtnClicked(_ sender: Any) {
        initLaunch(workPlatformId: "9bb8913b-ddd9-430b-a66a-d74d846e6c66")
    }
    @IBAction func youtubeBtnClicked(_ sender: Any) {
        initLaunch(workPlatformId: "14d9ddf5-51c6-415e-bde6-f8ed36ad7054")
    }
    
    @IBAction func existingUserClicked(_ sender: UIButton) {
        if(G.userId.isEmpty){
            return;
        }
        sender.isSelected = !sender.isSelected
    }
    
    func initLaunch(workPlatformId : String){
        if let waitController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "waitVC") as? WaitVC {
            waitController.modalPresentationStyle = .fullScreen
            self.present(waitController, animated: true, completion: nil)
        }
        getUserId(workPlatformId: workPlatformId)
    }
    
    
    func getUserId(workPlatformId : String){
        if(existingUser.isSelected){
            getSDKToken(workPlatformId : workPlatformId)
        }
        else{
            NetworkHandler.post(suffix: "/v1/users", mapData: ["name" : G.randomString(length: 8), "external_id" : G.randomString(length: 20)], env: env, completion: {
                    [weak self] (rs, e) in
                    guard self != nil else {
                        return
                    }
                    if((rs["id"]) != nil){
                        self!.existingUser.isEnabled = true
                        G.userId = rs["id"] as! String
                        self!.getSDKToken(workPlatformId: workPlatformId)
                    }
            })
        }
    }
    
    func getSDKToken(workPlatformId : String){
        NetworkHandler.post(suffix: "/v1/sdk-tokens", mapData: ["user_id" : G.userId, "products" : ["IDENTITY","ENGAGEMENT","INCOME"]], env: env, completion: {
                [weak self] (rs, e) in
                guard self != nil else {
                    return
                }
            if((rs["sdk_token"]) != nil){
                G.sdkToken = "Bearer " + ((rs["sdk_token"] as! String)) 
                self!.launchSDK(workPlatformId: workPlatformId)
            }
        })
    }
    
    func launchSDK(workPlatformId : String){
        //Phyllo configuration
        phylloConfig.developerName =  "Etzy"
        phylloConfig.deepLinkURL = "https://etsy.ai"
        phylloConfig.sdkToken = G.sdkToken
        phylloConfig.userId = G.userId
        phylloConfig.env = env
        phylloConfig.phylloVC = getTopViewController()!
        
        let phyllo = PhylloConnectSDK(configuration: phylloConfig)
        phyllo.launchSDK(workPlatformId: workPlatformId)
    }
    
    func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

