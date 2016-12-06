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
    // 主题颜色
    var themeColor = UIColor(red: 0/255, green: 131/255, blue: 38/255, alpha: 1.0)
    // 滚动视图
    var scrollView = UIScrollView()
    // 用户的栏目视图数组(包括栏目视图尺寸和简略信息)
    var paneViews = [PaneView]()
    // 滚动视图页面控制器
    var pageControl = UIPageControl()
    
    
    // ///////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadInformationsOfPaneViews()
        
        // 添加设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        // 添加手势滑动通知(要禁用scrollView的sroll功能)
        scrollView.scrollEnabled = false
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(UIDeviceOrientationDidChangeNotification)
    }
    
    
    // ///////////////////////////////////////////////////////////////////////////////
    // MARK: - 自定义函数
    /** 加载paneView的简要信息数据 */
    func loadInformationsOfPaneViews() {
        //获取文件位置
        let filePath = NSBundle.mainBundle().pathForResource("panes", ofType: "json", inDirectory: "SupportFiles")
        //读取json文件中的栏目简要内容,并赋值给paneViews
        if let data = NSData(contentsOfFile: filePath!)
        {
            do
            {
                if let jsonObjects:NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSArray
                {
                    for jsonObject in jsonObjects
                    {
                        let paneViewObject = PaneView()
                        paneViewObject.infomations = jsonObject as? NSDictionary
                        paneViewObject.backgroundColor = themeColor
                        paneViews.append(paneViewObject)
                    }
                }
            }
            catch
            {
                print("Error: Parse 'channels.json'")
            }
        }
    }
    /** 显示背景中的视图 */
    func refreshViews() {
        
        /************** 获取基本信息 **************/
        //根据设备类型方向设置布局的行列数
        var numberOfRow: Int = 0
        var numberOfColumn: Int = 0
        let device = UIDevice.currentDevice()
        switch (device.orientation, device.userInterfaceIdiom)
        {
        case (.Portrait, _),(.PortraitUpsideDown, _):
            numberOfRow = 3
            numberOfColumn = 2
            break
        case (.LandscapeLeft, .Phone), (.LandscapeRight, .Phone):
            numberOfRow = 2
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
    
        /************** 设置背景视图 **************/
        self.view.backgroundColor = UIColor.whiteColor()
        
        /************** 设置页面控制器 **************/
        let pageControlHeigt = verticalBorderSpace
        pageControl.frame = CGRect(x: 0, y: viewHeigt - pageControlHeigt, width: viewWidth, height: pageControlHeigt)
        pageControl.backgroundColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = themeColor
        pageControl.enabled = false
        pageControl.numberOfPages = paneViews.count / (numberOfRow * numberOfColumn) + 1
        
        /************** 设置滚动视图 **************/
        scrollView.frame = CGRectMake(0, verticalBorderSpace, viewWidth, viewHeigt-2 * verticalBorderSpace)
        scrollView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(pageControl.numberOfPages), scrollView.frame.height)
        scrollView.scrollToPageHorizontal(page: pageControl.currentPage)
        //scrollView.delegate = self
        
        /************** 设置pane视图 **************/
        let scrollFrameWidth = scrollView.frame.width
        let scrollFrameHeight = scrollView.frame.height
        //计算边间、空隙、pane的尺寸
        let horizontalEdgeSpace = scrollFrameWidth / CGFloat(15)
        let verticalEdgeSpace = scrollFrameHeight / CGFloat(30)
        let paneSpace = min(scrollFrameWidth, scrollFrameHeight) / CGFloat(50)
        let paneWidth = (scrollFrameWidth - horizontalEdgeSpace * 2 - paneSpace * CGFloat(numberOfColumn - 1)) / CGFloat(numberOfColumn)
        let paneHeigth = (scrollFrameHeight - verticalEdgeSpace * 2 - paneSpace * CGFloat(numberOfRow - 1)) / CGFloat(numberOfRow)
        //设置pane在父视图scrollView中的位置
        for var i = 0; i < paneViews.count; i++
        {
            let iPage = i / (numberOfRow * numberOfColumn)
            let iRow = i % (numberOfRow * numberOfColumn) / numberOfColumn
            let iColumn = i % (numberOfRow * numberOfColumn) % numberOfColumn
            let x = CGFloat(iPage) * scrollFrameWidth + horizontalEdgeSpace + CGFloat(iColumn) * (paneWidth + paneSpace)
            let y = verticalEdgeSpace + CGFloat(iRow) * (paneHeigth + paneSpace)
            paneViews[i].frame = CGRectMake(x, y, paneWidth, paneHeigth)
        }
        
        /**** 添加滚动视图和页面控制器 (由于到此才完成了所有的视图属性设置，才可以添加到此)****/
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
    
    /*
    // //////////////////////////⚠️UIScrollViewDelegate/////////////////////////////////////
    // MARK: - UIScrollViewDelegate
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
