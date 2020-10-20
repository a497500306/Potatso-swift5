//
//  MGConst.swift
//  Potatso
//
//  Created by 毛立 on 2020/10/20.
//  Copyright © 2020 TouchingApp. All rights reserved.
//

/// 是否是全面屏
var isFullScreen : Bool {
    get{
        if #available(iOS 11.0, *) {
            if Thread.current != Thread.main {
                var safeInsetBottom: CGFloat = 0.0
                //切换到主线程获取值，以免奔溃
                DispatchQueue.main.sync {
                    safeInsetBottom = UIWindow().safeAreaInsets.bottom
                }
                return safeInsetBottom > 0
                
            }else {
                //主线程直接返回
                return UIWindow().safeAreaInsets.bottom > 0
            }
            
        }
        return false
    }
}

extension UIImage{
    // 颜色生成图片
    public class func createImageWithColor(color: UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let tImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tImage!
    }
}

extension UIFont {
    
    /// 显示平方粗体字体
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    open class func bh_systemFontPingFangSC_Medium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    /// 显示平方细体字体
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    open class func bh_systemFontPingFangSC_Light(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// 使用字体包
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    open class func bh_systemFontDINAlternateBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

extension UIView {
    func setBorder(_ borderColor : UIColor,borderWidth : CGFloat = 0.5){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
}

extension Notification.Name {
    public struct MG {
        
        /// 更新连接状态
        public static let MG_UpdateConnectButton = Notification.Name(rawValue: "MG_UpdateConnectButton")
        
        /// 点击连接
        public static let MG_HandleConnectButtonPressed = Notification.Name(rawValue: "MG_HandleConnectButtonPressed")
        
        /// 更新全局/自动状态
        public static let MG_DefaultToProxy = Notification.Name(rawValue: "MG_DefaultToProxy")
        
        /// 选择全局/自动
        public static let MG_SelectDefaultToProxy = Notification.Name(rawValue: "MG_SelectDefaultToProxy")
    }
}
