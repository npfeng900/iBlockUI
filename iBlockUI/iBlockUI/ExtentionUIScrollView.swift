//
//  ExtentionUIScrollView.swift
//  iBlockUI
//
//  Created by Niu Panfeng on 06/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

extension UIScrollView {
     /** scrollView水平滑到与page匹配的位置 */
    func scrollToPageHorizontal(page page: Int) {
        var frame = self.frame
        frame.origin.x = frame.size.width * (CGFloat)(page)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: true)
    }
}