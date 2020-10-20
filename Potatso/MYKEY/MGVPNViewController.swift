//
//  MGVPNViewController.swift
//  Potatso
//
//  Created by 毛立 on 2020/10/19.
//  Copyright © 2020 TouchingApp. All rights reserved.
//

import UIKit
import ChameleonFramework

class MGVPNViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Interstellar"
        label.font = UIFont(name: "PingFangSC-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var switchBtn: UISwitch = {
        let switchs = UISwitch()
        switchs.onTintColor = UIColor.white
        switchs.tintColor = UIColor.white
        switchs.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1)
        switchs.layer.cornerRadius = switchs.bounds.height/2.0
        switchs.layer.masksToBounds = true
        switchs.thumbTintColor = UIColor(red: 0/255.0, green: 136/255.0, blue: 246/255.0, alpha: 1)
        switchs.addTarget(self, action: #selector(self.switchEvent(switchs:)), for: .valueChanged)
        return switchs
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.text = "未连接"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("自动", for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBorder(UIColor.white)
        button.addTarget(self, action: #selector(self.clickSelectButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named: "icon_down_white")
        return imageView
    }()
    
    /// 当前连接状态
    private var status: VPNStatus = .off {
        didSet(o) {
            updateConnectButton()
            self.resizeSubviewSize()
        }
    }
    
    /// true:全局/false:自动
    private var proxy: Bool = false {
        didSet {
            self.updateSelectButton()
        }
    }
    
    var window: MGWindow? = nil
    
    var navVC: MGNavigationController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationUpdateConnectButton(_:)), name: Notification.Name.MG.MG_UpdateConnectButton, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.defaultToProxy(_:)), name: Notification.Name.MG.MG_DefaultToProxy, object: nil)
        
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(switchBtn)
        
        self.view.addSubview(typeLabel)
        
        self.view.addSubview(selectButton)
        
        self.selectButton.addSubview(selectImageView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.MG.MG_UpdateConnectButton, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.MG.MG_DefaultToProxy, object: nil)
    }
    
    /// 在这里设置Frame
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.resizeSubviewSize()
    }
    
    private func resizeSubviewSize() {
        
        let colors = [ UIColor(red: 12/255.0, green: 170/255.0, blue: 249/255.0, alpha: 1) , UIColor(red: 49/255.0, green: 36/255.0, blue: 255/255.0, alpha: 1)]
        self.view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: UIScreen.main.bounds, andColors: colors)
        
        let titleLabelSize: CGSize = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.frame = CGRect(x: (UIScreen.main.bounds.size.width - titleLabelSize.width)/2.0, y: (44 - titleLabelSize.height)/2.0 + (isFullScreen ? 44 : 20), width: titleLabelSize.width, height: titleLabelSize.height)
        
        switchBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 55)
        switchBtn.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.height/2.0)
        
        let typeLabelSize = typeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        typeLabel.frame = CGRect(x: (UIScreen.main.bounds.size.width - typeLabelSize.width)/2.0, y: switchBtn.frame.maxY + 14, width: typeLabelSize.width, height: typeLabelSize.height)
        
        selectButton.frame = CGRect(x: (UIScreen.main.bounds.size.width - 180)/2.0, y: UIScreen.main.bounds.size.height - 45 - (isFullScreen ? 115 : 81), width: 180, height: 45)
        selectButton.layer.cornerRadius = selectButton.bounds.height/2.0
        selectButton.layer.masksToBounds = true
        
        selectImageView.frame = CGRect(x: selectButton.frame.size.width - 24 - 10, y: (selectButton.frame.size.height - 6)/2.0, width: 10, height: 6)
        
    }
    
    func show() {
        
        let window = MGWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        
        self.window?.windowLevel = .leastNormalMagnitude
        
        let navVC = MGNavigationController(rootViewController: self)
        
        self.navVC = navVC
        
        self.window?.rootViewController = navVC
        
        self.window?.makeKeyAndVisible()
        
        self.window?.backgroundColor = UIColor.white
        
    }
    
    //MARK: 更新连接状态
    private func updateConnectButton() {
        switch status {
        case .off:
            // 关
            self.typeLabel.text = "未连接"
            if self.switchBtn.isOn == true {
                self.switchBtn.setOn(false, animated: false)
            }
            break
        case .connecting:
            // 链接中..
            self.typeLabel.text = "连接中..."
            if self.switchBtn.isOn == false {
                self.switchBtn.setOn(true, animated: false)
            }
            break
        case .on:
            // 已连接
            self.typeLabel.text = "已连接"
            if self.switchBtn.isOn == false {
                self.switchBtn.setOn(true, animated: false)
            }
            break
        case .disconnecting:
            // 正在断开
            self.typeLabel.text = "正在断开..."
            if self.switchBtn.isOn == true {
                self.switchBtn.setOn(false, animated: false)
            }
            break
        }
    }
    
    //MARK: 更新全局/自动
    private func updateSelectButton() {
        if self.proxy == true {
            selectButton.setTitle("全局", for: .normal)
        }else{
            selectButton.setTitle("自动", for: .normal)
        }
    }
}

//MARK: - 点击相关
extension MGVPNViewController {
    //MARK: 点击选择规则
    @objc private func clickSelectButton() {
        let alert = UIAlertController(title: "请选择", message: nil, preferredStyle: .actionSheet)
        
        let auteAction = UIAlertAction(title: "自动", style: .default) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name.MG.MG_SelectDefaultToProxy, object: false)
        }
        auteAction.setValue(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(auteAction)
        
        let allAction = UIAlertAction(title: "全局", style: .default) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name.MG.MG_SelectDefaultToProxy, object: true)
        }
        allAction.setValue(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(allAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: 点击链接
    @objc private func switchEvent(switchs : UISwitch){
        // 发送连接/断开通知
        NotificationCenter.default.post(name: NSNotification.Name.MG.MG_HandleConnectButtonPressed, object: switchs.isOn)
    }
}

//MARK: - 通知
extension MGVPNViewController {
    //MARK: 更新连接状态通知
    @objc private func notificationUpdateConnectButton(_ notification: Notification?) {
        if let statusV = notification?.object as? Int {
            self.status = VPNStatus(rawValue: statusV) ?? VPNStatus.off
        }
    }
    
    //MARK: true:全局/false:自动
    @objc private func defaultToProxy(_ notification: Notification?) {
        if let proxy = notification?.object as? Bool {
            self.proxy = proxy
        }
    }
}
