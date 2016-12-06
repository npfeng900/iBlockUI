//
//  MainViewController.swift
//  UIBlockStyle
//
//  Created by Niu Panfeng on 30/11/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,UIScrollViewDelegate {
    
    // 滚动视图
    var scrollView = UIScrollView()
    // 用户的栏目视图数组(包括栏目视图尺寸和简略信息)
    var paneViews = [PaneView]()
    // 滚动视图页面控制器
    var pageControl = UIPageControl()
    // 主题颜色
    var themeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7)
    // 是否使用pageControl更改页面
    var isPageControlUsed = false
    // ///////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInformationsOfPaneViews()
        // 添加设备方向变化的消息通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
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
        //获取屏幕大小
        let screenFrame = UIScreen.mainScreen().bounds
        let screenWidth = screenFrame.width
        let screenHeigt = screenFrame.height
        //上下边界空隙
        let verticalBorderSpace = min(screenWidth, screenHeigt) / 10
    
        /**** 设置背景视图 ****/
        self.view.backgroundColor = UIColor.whiteColor()
        
        /**** 设置页面控制器 ****/
        let pageControlHeigt = verticalBorderSpace
        pageControl.frame = CGRect(x: 0, y: screenHeigt - pageControlHeigt, width: screenWidth, height: pageControlHeigt)
        pageControl.backgroundColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = themeColor
        pageControl.enabled = false
        
        /**** 设置滚动视图 ****/
        scrollView.frame = CGRectMake(0, verticalBorderSpace, screenWidth, screenHeigt-2 * verticalBorderSpace)
        scrollView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        scrollView.delegate = self
        
        /**** 设置pane视图 ****/
        let width = scrollView.frame.width
        let height = scrollView.frame.height
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
        //设置pageControl和UIScrollView
        let numberOfPages = paneViews.count / (numberOfRow * numberOfColumn) + 1
        pageControl.numberOfPages = numberOfPages
        scrollView.contentSize = CGSizeMake(screenWidth * CGFloat(numberOfPages), scrollView.frame.height)
        //计算空隙和每个pane的尺寸
        let horizontalEdgeSpace = width / CGFloat(15)
        let verticalEdgeSpace = height / CGFloat(30)
        let paneSpace = min(width, height) / CGFloat(50)
        let paneWidth = (width - horizontalEdgeSpace * 2 - paneSpace * CGFloat(numberOfColumn - 1)) / CGFloat(numberOfColumn)
        let paneHeigth = (height - verticalEdgeSpace * 2 - paneSpace * CGFloat(numberOfRow - 1)) / CGFloat(numberOfRow)
        //设置pane在父视图scrollView中的位置
        for var i = 0; i < paneViews.count; i++
        {
            let iPage = i / (numberOfRow * numberOfColumn)
            let iRow = i % (numberOfRow * numberOfColumn) / numberOfColumn
            let iColumn = i % (numberOfRow * numberOfColumn) % numberOfColumn
            let x = CGFloat(iPage) * width + horizontalEdgeSpace + CGFloat(iColumn) * (paneWidth + paneSpace)
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
        
        print(view.subviews.count)
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
  
    
    
    // ///////////////////////////////////////////////////////////////////////////////
    // MARK: - UIScrollViewDelegate
    /** 通过触摸滑动控制scrollView的代理方法 */
    func scrollViewDidScroll(scrollView: UIScrollView) {
       
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        pageControl.currentPage = Int(page)
        
    }
    /** ScorllView减速调用的代理方法 */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * (CGFloat)(pageControl.currentPage)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    /** ScorllView结束Drag后的代理方法 */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * (CGFloat)(pageControl.currentPage)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }

   
}
