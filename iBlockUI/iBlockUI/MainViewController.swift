//
//  MainViewController.swift
//  UIBlockStyle
//
//  Created by Niu Panfeng on 30/11/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,UIScrollViewDelegate {

    
    var menuView = [UIView]()
    
    //滚动视图
    var scrollView = UIScrollView()
    // 滚动视图的页数
    var numberOfPages = 3
    // 滚动视图页面控制器
    var pageControl = UIPageControl()
    // 是否在用pageControl翻页
    var isPageControlUsed = false
    
   
    // 视图加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //获取屏幕大小
        let screenFrame = UIScreen.mainScreen().bounds
        let screenWidth = screenFrame.width
        let screenHeigt = screenFrame.height
        
        //设置滚动视图
        scrollView.frame = screenFrame
        //scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(numberOfPages), height: screenHeigt)
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.delegate = self
        //设置页面控制器
        let pageControlHeigt = screenHeigt / 10
        pageControl.frame = CGRect(x: 0, y: screenHeigt - pageControlHeigt, width: screenWidth, height: pageControlHeigt)
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.grayColor()
        pageControl.addTarget(self, action: "pageControlDidChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
    }
    // 通过pageControl控制scrollView
    func pageControlDidChanged(sender: AnyObject) {
        let currentPage = (CGFloat)(pageControl.currentPage)
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * currentPage
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
        isPageControlUsed = true
    }
    // 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIScrollViewDelegate
    // 同多触摸滑动控制scrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isPageControlUsed
        {
            let pageWidth = scrollView.frame.size.width
            let page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
            pageControl.currentPage = Int(page)
        }
    }
    // ScorllView减速调用的方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isPageControlUsed = false
    }

   
}
