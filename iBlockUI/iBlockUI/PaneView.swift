//
//  PaneView.swift
//  iBlockUI
//
//  Created by Niu Panfeng on 04/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class PaneView: UIView {

    //栏目的简要信息
    var infomations: NSDictionary?
    
    //初始化视图
    func initView(frame: CGRect, themeColor: UIColor) {
        self.backgroundColor = themeColor
    }
    /*
    init(infomations: NSDictionary?, frame: CGRect) {
        info = infomations
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
}