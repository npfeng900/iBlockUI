//
//  MainViewController.swift
//  UIBlockStyle
//
//  Created by Niu Panfeng on 30/11/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // ///////////////////////////////////////////////////////////////////////////////
    // MARK: - 自定义属性
    // AppHeader视图
    var appHeaderView = UIImageView()
    // 滚动视图页面控制器
    var pageControl = UIPageControl()
    // 滚动视图
    var scrollView = UIScrollView()
    // 用户的栏目视图数组(包括栏目视图尺寸和简略信息)
    var paneViews = [PaneView]()
    // pane数据，存储了所有pane数据
    let paneDatas = PaneDatas()
    // 主题颜色
    var themeColor = UIColor(red: 0/255, green: 140/255, blue: 80/255, alpha: 1)
    
    
    // ///////////////////////////////////////////////////////////////////////////////
    // MARK: - UIViewController方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDatas()
        initNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    deinit {
        deinitNotifications()
    }
    
    // ///////////////////////////////////////////////////////////////////////////////
    // MARK: - 自定义函数
    /** init数据信息 */
    func initDatas() {
        //加载appHeaderView数据
        appHeaderView.image = UIImage(named: "AppHeader")
        appHeaderView.contentMode = UIViewContentMode.ScaleToFill
        //加载paneDatas数据
        paneDatas.loadDatas(fileName: "panes", ofType: "json", inDirectory: "SupportFiles")
        //加载paneViews数据
        for var i = 0; i < paneDatas.getCount(); i++
        {
            let paneViewObject = PaneView()
            paneViewObject.titleLabel.text = paneDatas.getTitle(atIndex: i)
            paneViewObject.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
            paneViews.append(paneViewObject)
        }
    }
    /** init通知消息 */
    func initNotifications() {
        // 添加设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        // 添加手势滑动通知(要禁用scrollView的sroll功能)
        
        for var touchCount = 1; touchCount <= 3; touchCount++
        {
            let horizontalLeft = UISwipeGestureRecognizer(target: self, action: "horizontalSwipeLeft:")
            horizontalLeft.direction = UISwipeGestureRecognizerDirection.Left
            horizontalLeft.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(horizontalLeft)
            let horizontalRight = UISwipeGestureRecognizer(target: self, action: "horizontalSwipeRight:")
            horizontalRight.direction = UISwipeGestureRecognizerDirection.Right
            horizontalRight.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(horizontalRight)
        }

    }
    /** deninit通知消息 */
    func deinitNotifications() {
        // 移除设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().removeObserver(UIDeviceOrientationDidChangeNotification)
        // 移除手势滑动通知
        if let gNotisfications = self.view.gestureRecognizers
        {
            for gNotisfication in gNotisfications
            {
                self.view.removeGestureRecognizer(gNotisfication)
            }
        }
    }
    /** 显示背景中的视图 */
    func refreshViews() {
        /*********************** 获取基本信息 ***********************/
        //根据设备类型方向设置布局的行列数
        var numberOfRow: Int = 0
        var numberOfColumn: Int = 0
        let device = UIDevice.currentDevice()
        switch (device.orientation, device.userInterfaceIdiom)
        {
        case (.Portrait, .Phone),(.PortraitUpsideDown, .Phone):
            numberOfRow = 3
            numberOfColumn = 2
            break
        case (.LandscapeLeft, .Phone), (.LandscapeRight, .Phone):
            numberOfRow = 2
            numberOfColumn = 3
            break
        case (.Portrait, .Pad),(.PortraitUpsideDown, .Pad):
            numberOfRow = 4
            numberOfColumn = 3
            break
        case (.LandscapeLeft, .Pad), (.LandscapeRight, .Pad):
            numberOfRow = 3
            numberOfColumn = 4
            break
        default:
            break
        }
        //获取屏幕大小
        let viewWidth = self.view.frame.width
        let viewHeigt = self.view.frame.height
        //上下边界空隙
        let verticalBorderSpace = min(viewWidth, viewHeigt) / 10
    
        /*********************** 设置背景视图 ***********************/
        self.view.backgroundColor = UIColor.whiteColor()
        
        /*********************** 设置pageControl视图 ***********************/
        let pageControlHeigt = verticalBorderSpace
        pageControl.frame = CGRect(x: 0, y: viewHeigt - pageControlHeigt, width: viewWidth, height: pageControlHeigt)
        pageControl.enabled = false
        pageControl.numberOfPages = paneViews.count / (numberOfRow * numberOfColumn) + 1
        pageControl.backgroundColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = themeColor
        
        /*********************** 设置scrollView视图 ***********************/
        scrollView.frame = CGRectMake(0, verticalBorderSpace, viewWidth, viewHeigt-2 * verticalBorderSpace)
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(pageControl.numberOfPages), scrollView.frame.height)
        scrollView.scrollEnabled = false
        scrollView.scrollToPageHorizontal(page: pageControl.currentPage)
        scrollView.backgroundColor = UIColor.whiteColor()//UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        /*********************** 设置paneViews视图 ***********************/
        let scrollFrameWidth = scrollView.frame.width
        let scrollFrameHeight = scrollView.frame.height
        //计算边间、空隙、pane的尺寸
        let horizontalEdgeSpace = scrollFrameWidth / CGFloat(15)
        let verticalTopEdgeSpace = scrollFrameHeight / CGFloat(15)
        let verticalBottomEdgeSpace = CGFloat(0) //scrollFrameHeight / CGFloat(30)
        let paneSpace = min(scrollFrameWidth, scrollFrameHeight) / CGFloat(100)
        let paneWidth = (scrollFrameWidth - horizontalEdgeSpace * 2 - paneSpace * CGFloat(numberOfColumn - 1)) / CGFloat(numberOfColumn)
        let paneHeigth = (scrollFrameHeight - verticalTopEdgeSpace - verticalBottomEdgeSpace - paneSpace * CGFloat(numberOfRow - 1)) / CGFloat(numberOfRow)
        //设置pane在父视图scrollView中的位置和背景颜色
        for var i = 0; i < paneViews.count; i++
        {
            let iPage = i / (numberOfRow * numberOfColumn)
            let iRow = i % (numberOfRow * numberOfColumn) / numberOfColumn
            let iColumn = i % (numberOfRow * numberOfColumn) % numberOfColumn
            let x = CGFloat(iPage) * scrollFrameWidth + horizontalEdgeSpace + CGFloat(iColumn) * (paneWidth + paneSpace)
            let y = verticalTopEdgeSpace + CGFloat(iRow) * (paneHeigth + paneSpace)
            paneViews[i].frame = CGRectMake(x, y, paneWidth, paneHeigth)
            paneViews[i].contentView.backgroundColor = themeColor
            paneViews[i].titleLabel.textColor = UIColor.whiteColor()
        }
        
        /*********************** 设置appHeaderView视图 ***********************/
        appHeaderView.backgroundColor = themeColor
        appHeaderView.frame = CGRect(x: horizontalEdgeSpace, y: 0, width: paneWidth, height: verticalBorderSpace)
        
        /****************** 添加所有视图 ********************/
        self.view.addSubview(appHeaderView)
        self.view.addSubview(pageControl)
        self.view.addSubview(scrollView)
        for var i = 0; i < paneViews.count; i++
        {
            scrollView.addSubview(paneViews[i])
        }
    }
    /** 设备方向变化的通知处理函数 */
    func orientationChanged(notification: NSNotification) {
        switch UIDevice.currentDevice().orientation
        {
        //下面四种情况，重新布局
        case .Portrait, .PortraitUpsideDown, .LandscapeLeft, .LandscapeRight:
            refreshViews()
            break
        //剩余情况，无变化
        default:
            break
        }
    }
    /** 设备手势滑动->的通知处理函数 */
    func horizontalSwipeLeft(recognizer: UIGestureRecognizer) {
        pageControl.currentPage++
        scrollView.scrollToPageHorizontal(page: pageControl.currentPage)
    }
    /** 设备手势滑动<-的通知处理函数 */
    func horizontalSwipeRight(recognizer: UIGestureRecognizer) {
        pageControl.currentPage--
        scrollView.scrollToPageHorizontal(page: pageControl.currentPage)
    }
    /** 长按事件处理函数 */
    func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began
        {
            print("长按事件")
        }
    }

    
    /*
    // //////////////////////////⚠️UIScrollViewDelegate/////////////////////////////////////
    // MARK- UIScrollViewDelegate
    /** 通过触摸滑动控制scrollView的代理方法 */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //获取正确的currentPage
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        pageControl.currentPage = Int(page)
        //根据currentPage，设置界面
    }
    */
    
}
