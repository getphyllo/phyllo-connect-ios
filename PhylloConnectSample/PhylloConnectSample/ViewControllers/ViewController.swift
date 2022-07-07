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

   
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set card view for iPad only
        if UIDevice.current.userInterfaceIdiom == .pad {
             // iPad
            self.view.backgroundColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            height.isActive = true
            width.isActive = true
            height.constant = 667.0
            width.constant = 375.0
            DispatchQueue.main.async {
                self.mainView.dropShadow()
                self.view.layoutIfNeeded()
            }
         } else {
             height.isActive = false
             width.isActive = false
         }
        
        //Light Mode
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    @IBOutlet weak var existingUser: UIButton!{
        didSet{
            if(Constants.userId.isEmpty){
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
        if(Constants.userId.isEmpty){
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
            //showLoading()
            showActivityIndicator()
            NetworkHandler.post(suffix: "/v1/users", mapData: ["name" : Constants.randomString(length: 8), "external_id" : Constants.randomString(length: 20)], env: Config.env, completion: {
                    [weak self] (rs, e) in
                    //self?.hideLoading()
                self?.hideActivityIndicator()
                    guard self != nil else {
                        return
                    }
                
                    if((rs["id"]) != nil){
                        self!.existingUser.isEnabled = true
                        Constants.userId = rs["id"] as! String
                        self!.getSDKToken(workPlatformId: workPlatformId)
                    }
            })
        }
    }
    
    func getSDKToken(workPlatformId : String){
        showActivityIndicator()
        NetworkHandler.post(suffix: "/v1/sdk-tokens", mapData: ["user_id" : Constants.userId, "products" : ["IDENTITY","ENGAGEMENT","INCOME"]], env: Config.env, completion: {
            [weak self] (rs, e) in
            self?.hideActivityIndicator()
            guard self != nil else {
                return
            }
            if((rs["sdk_token"]) != nil){
                Constants.sdkToken = ((rs["sdk_token"] as! String))
                print("Token ==> \(Constants.sdkToken)")
                self!.launchSDK(workPlatformId: workPlatformId)
            }
        })
    }
    
    func launchSDK(workPlatformId : String) {
        //Phyllo configuration
    
        let phylloConfig = PhylloConfig (
                                            environment: Config.env,
                                            clientDisplayName: Constants.clientDisplayName,
                                            token: Constants.sdkToken,
                                            userId: Constants.userId,
                                            delegate:self,workPlatformId: workPlatformId
                                        )
        
        PhylloConnect.shared.initialize(config: phylloConfig)
        PhylloConnect.shared.open()
    }

}

extension ViewController : PhylloConnectDelegate {
    
    func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountConnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
    }
    
    func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountDisconnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
    }
    
    func onTokenExpired(user_id: String) {
        print("onTokenExpired => user_id : \(user_id)")
    }
    
    func onExit(reason: String, user_id: String) {
        print("onExit => reason : \(reason),user_id : \(user_id)")
    }
    
    func connectionFailure(reason: String, user_id: String) {
        print("connectionFailure => reason : \(reason),user_id : \(user_id)")
    }
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 10
    layer.cornerRadius = 10
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
