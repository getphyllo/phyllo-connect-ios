//
//  ViewController.swift
//  XCFrameworkDemo
//
//  Created by Anurag Ajwani on 31/05/2020.
//  Copyright © 2020 Anurag Ajwani. All rights reserved.
//

import UIKit
import PhylloConnect

class ViewController: UIViewController {

    var phylloConfig = PhylloConfig()
    //Set enviroment
   
    
    @IBOutlet weak var imgLoading: UIImageView!
    @IBOutlet weak var viewLoading: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLoading.setGIFImage(name: "loading")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imgLoading.stopAnimating()
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
        initLaunch(workPlatformId: "")
    }
    @IBAction func youtubeBtnClicked(_ sender: Any) {
        initLaunch(workPlatformId: "")
    }
    
    @IBAction func existingUserClicked(_ sender: UIButton) {
        if(G.userId.isEmpty){
            return;
        }
        sender.isSelected = !sender.isSelected
    }
    
    func initLaunch(workPlatformId : String){
        getUserId(workPlatformId: workPlatformId)
    }
    
    
    func getUserId(workPlatformId : String){
        if(existingUser.isSelected){
            getSDKToken(workPlatformId : workPlatformId)
        }
        else{
            showLoading()
            NetworkHandler.post(suffix: "/v1/users", mapData: ["name" : G.randomString(length: 8), "external_id" : G.randomString(length: 20)], env: Config.env, completion: {
                    [weak self] (rs, e) in
                    self?.hideLoading()
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
        showLoading()
        NetworkHandler.post(suffix: "/v1/sdk-tokens", mapData: ["user_id" : G.userId, "products" : ["IDENTITY","ENGAGEMENT","INCOME"]], env: Config.env, completion: {
                [weak self] (rs, e) in
            self?.hideLoading()
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
        phylloConfig.developerName =  "" //Developer
        phylloConfig.deepLinkURL = "" // DeepLink
        phylloConfig.sdkToken = G.sdkToken
        phylloConfig.userId = G.userId
        phylloConfig.env = Config.env
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
    
    private func showLoading() {
        viewLoading.isHidden = false
    }
    
    private func hideLoading() {
        viewLoading.isHidden = true
    }
}
