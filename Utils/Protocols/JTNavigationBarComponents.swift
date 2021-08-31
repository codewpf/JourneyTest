//
//  JTNavigationBarComponents.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import UIKit
import WPFoundation

enum JTBarButtonItemType {
    case left
    case right
}

protocol JTNavigationBarComponents {
    func barBackBtn(_ sel: Selector)
    
    func leftBbi(_ title: String, _ target: AnyObject, _ action: Selector, _ nImage: String, _ sImage: String)
    func rightBbi(_ title: String, _ target: AnyObject, _ action: Selector, _ nImage: String, _ sImage: String)


    func createBarButtonItem(_ title: String, _ target: AnyObject, _ action: Selector, _ type: JTBarButtonItemType, _ nImage: String, _ sImage: String)
    
    func createBarButtonItems(_ titles: [String], _ target: AnyObject, _ actions: [Selector], _ type: JTBarButtonItemType, _ nImages: [String], _ sImages: [String])
}

extension JTNavigationBarComponents where Self: UIViewController {
    func barBackBtn(_ sel: Selector) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        backButton.setImage(UIImage(named:  "navBackGreen"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: sel, for: .touchUpInside)
        let bbi = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = bbi
    }
    
    func leftBbi(_ title: String, _ target: AnyObject, _ action: Selector, _ nImage: String, _ sImage: String) {
        self.createBarButtonItem(title, target, action, .left, nImage, sImage)
    }
    func rightBbi(_ title: String, _ target: AnyObject, _ action: Selector, _ nImage: String, _ sImage: String) {
        self.createBarButtonItem(title, target, action, .right, nImage, sImage)
    }
    
    func createBarButtonItem(_ title: String, _ target: AnyObject, _ action: Selector, _ type: JTBarButtonItemType, _ nImage: String, _ sImage: String) {
        self.createBarButtonItems([title], target, [action], type, [nImage], [sImage])
    }
    
    
    func createBarButtonItems(_ titles: [String], _ target: AnyObject, _ actions: [Selector], _ type: JTBarButtonItemType, _ nImages: [String], _ sImages: [String]) {
        
        guard nImages.count == sImages.count else {
            return
        }
        
        guard (titles.count + actions.count + nImages.count + sImages.count) % titles.count == 0 else {
            return
        }
        
    
        let font = UIFont.systemFont(ofSize: 18)
        
        var bbis:[UIBarButtonItem] = []
        for (index,title) in titles.enumerated(){
            let nImage: String = nImages[index]
            let hImage: String = sImages[index]
            let action: Selector = actions[index]
            // Image Size
            var imageSize: CGSize
            let nimage: UIImage? = UIImage(named: nImage)
            let himage: UIImage? = UIImage(named: hImage)
            
            if (nimage != nil) {
                imageSize = (nimage?.size)!
            }else{
                imageSize = CGSize.init(width: 0, height: 0)
            }
            // Text Size
            let textSize: CGSize = title.size(with: CGSize(width: UIScreen.main.bounds.width, height: 30), font: font)
            
            // inin button
            let button: UIButton? = UIButton(type: .custom)
            button?.frame = CGRect(x: 0, y: 0, width: imageSize.width+textSize.width+10, height: 30)
            button?.setImage(nimage, for: .normal)
            button?.setImage(himage, for: .highlighted)
            button?.setTitle(title, for: .normal)
            button?.titleLabel?.font = font
            button?.setTitleColor(UIColor(iHex: 0x444444), for: .normal)
            button?.addTarget(target, action: action, for: .touchUpInside)
            
            if type == .left {
                button?.contentHorizontalAlignment = .left
            } else {
                button?.contentHorizontalAlignment = .right
            }
            
            
            let bbi: UIBarButtonItem? = UIBarButtonItem(customView: button!)
            
            bbis.append(bbi!)
            
        }
        
        if type == .left {
            self.navigationItem.leftBarButtonItems = bbis
        }else{
            self.navigationItem.rightBarButtonItems = bbis
        }
        
    }
}
