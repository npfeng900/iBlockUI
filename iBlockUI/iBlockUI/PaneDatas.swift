//
//  PaneData.swift
//  iBlockUI
//
//  Created by Niu Panfeng on 08/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import Foundation

class PaneDatas {
    
    //pane数据数组
    var datas = [NSDictionary]()
   
    /** 加载存储的pane数据
    - parameter fileName: 存储数据的文件名
    */
    func loadDatas(fileName fileName:String, ofType ext: String, inDirectory subPath: String) {
        //获取文件位置
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: ext, inDirectory: subPath)
        //读取json文件中的栏目简要内容,并赋值给paneViews
        if let data = NSData(contentsOfFile: filePath!)
        {
            do
            {
                if let jsonObjects:NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSArray
                {
                    for jsonObject in jsonObjects
                    {
                        if let jsonObjectDic = jsonObject as? NSDictionary
                        {
                            datas.append(jsonObjectDic)
                        }
                        
                    }
                }
            }
            catch
            {
                print("Load PaneData Error!!")
            }
        }
    }
    
    /** 获取datas的个数
     - returns: 个数
     */
    func getCount() -> Int{
        return datas.count
    }
    
    /** 得到指定序号的title
     - parameter index: 序号
     - returns: title名字
     */
    func getTitle(atIndex index: Int) -> String? {
        return datas[index]["title"] as! String?
    }
    
}