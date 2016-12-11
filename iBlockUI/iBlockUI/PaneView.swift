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
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    /** 构造函数 */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    /** 遵循NSCode协议 */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    /** nib文件创建view对象是时发送一个awakeFromNib，执行此函数 */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loadView()
    }
    /** 1、 init初始化不会触发layoutSubviews
        2、 addSubview会触发layoutSubviews
        3、 设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化  ⭐️
        4、 滚动一个UIScrollView会触发layoutSubviews
        5、 旋转Screen会触发父UIView上的layoutSubviews事件 ⭐️
        6、 改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件 
    ❓在iphone中本程序中先执行情景5，此时self.bounds无变化，等到MainViewController完成界面刷新后再执行情景3，此时self.bounds有变化；但是在ipad中不会好像不会执行情景5，好奇怪？  */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds//设置完contentView.frame会自动调用布局约束条件
    }
    /** 获取xib名字 */
    private func getXibName() -> String {
        let clzzName = NSStringFromClass(self.classForCoder)
        let nameArray = clzzName.componentsSeparatedByString(".")
        var xibName = nameArray[0]
        if nameArray.count == 2 {
            xibName = nameArray[1]
        }
        return xibName
    }
    /** 根据nib名字返回UIView */
    private func getViewWithNibName(fileName: String, owner: AnyObject) -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: fileName, bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }
    /** 加载视图 */
    func loadView() {
        if self.contentView == nil
        {
            //contentView为空时执行加载操作
            self.contentView = self.getViewWithNibName(self.getXibName(), owner: self)
            self.addSubview(self.contentView)
            
        }
    }
    /** 设置控件的布局约束条件 */
  
    
}
