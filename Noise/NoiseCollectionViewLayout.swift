//
//  NoiseCollectionViewLayout.swift
//  Ello
//
//  Created by Sean on 1/26/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//  Big thanks to https://github.com/chiahsien
//  Swiftified and modified https://github.com/chiahsien/CHTCollectionViewWaterfallLayout

import Foundation
import UIKit

@objc protocol NoiseCollectionViewLayoutDelegate: UICollectionViewDelegate {
    
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize

    optional func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        groupForItemAtIndexPath indexPath: NSIndexPath) -> Int
    
    optional func colletionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: NSInteger) -> UIEdgeInsets

    optional func colletionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: NSInteger) -> CGFloat
}

class NoiseCollectionViewLayout : UICollectionViewLayout {

    enum Direction {
        case ShortestFirst
        case LeftToRight
        case RightToLeft
    }
    
    var columnCount : Int {
        didSet { invalidateLayout() }
    }
    
    var minimumColumnSpacing : CGFloat {
        didSet { invalidateLayout() }
    }

    var minimumInteritemSpacing : CGFloat {
        didSet { invalidateLayout() }
    }

    var sectionInset : UIEdgeInsets {
        didSet { invalidateLayout() }
    }
    
    var itemRenderDirection : Direction {
        didSet { invalidateLayout() }
    }

    weak var delegate : NoiseCollectionViewLayoutDelegate? {
        get {
            return self.collectionView!.delegate as? NoiseCollectionViewLayoutDelegate
        }
    }
    var columnHeights = [Double]()
    var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    var allItemAttributes = [UICollectionViewLayoutAttributes]()
    var unionRects = [CGRect]()
    let unionSize = 20

    override init(){
        self.columnCount = 2
        self.minimumInteritemSpacing = 10
        self.minimumColumnSpacing = 10
        self.sectionInset = UIEdgeInsetsZero
        self.itemRenderDirection = .ShortestFirst
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        self.columnCount = 2
        self.minimumInteritemSpacing = 10
        self.minimumColumnSpacing = 10
        self.sectionInset = UIEdgeInsetsZero
        self.itemRenderDirection = .ShortestFirst
        super.init(coder: aDecoder)
    }
    
    func itemWidthInSectionAtIndex (section : NSInteger) -> CGFloat {
        var insets : UIEdgeInsets
        if let sectionInsets = self.delegate?.colletionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section){
            insets = sectionInsets
        }else{
            insets = self.sectionInset
        }
        let width:CGFloat = self.collectionView!.frame.size.width - sectionInset.left-sectionInset.right
        let spaceColumCount:CGFloat = CGFloat(self.columnCount-1)
        return floor((width - (spaceColumCount*self.minimumColumnSpacing)) / CGFloat(self.columnCount))
    }
    
    override func prepareLayout(){
        super.prepareLayout()
        
        let numberOfSections = self.collectionView!.numberOfSections()
        if numberOfSections == 0 {
            return
        }

        unionRects.removeAll()
        columnHeights.removeAll()
        allItemAttributes.removeAll()
        sectionItemAttributes.removeAll()

        for index in 0..<columnCount {
            self.columnHeights.append(0)
        }

        var attributes = UICollectionViewLayoutAttributes()
        
        for section in 0..<numberOfSections {

            var minimumInteritemSpacing : CGFloat
            let minimumSpacing = self.delegate?.colletionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAtIndex: section)

            if let minimumSpacing = minimumSpacing {
                minimumInteritemSpacing = minimumSpacing
            }
            else {
                minimumInteritemSpacing = self.minimumColumnSpacing
            }
            
            var sectionInsets :  UIEdgeInsets
            let insets = self.delegate?.colletionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section)
            if let insets = insets {
                sectionInsets = insets
            }
            else {
                sectionInsets = self.sectionInset
            }
            
            let width = self.collectionView!.frame.size.width - sectionInset.left - sectionInset.right
            let spaceColumCount = CGFloat(self.columnCount-1)
            let itemWidth = floor((width - (spaceColumCount*self.minimumColumnSpacing)) / CGFloat(self.columnCount))
            

            let itemCount = self.collectionView!.numberOfItemsInSection(section)
            var itemAttributes = [UICollectionViewLayoutAttributes]()

            // Item will be put into shortest column.
            var groupIndex = 0
            var currentColumIndex = 0
            for index in 0..<itemCount {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let itemGroup:Int? = self.delegate?.collectionView?(self.collectionView!, layout: self, groupForItemAtIndexPath: indexPath)
                if let itemGroup = itemGroup {
                    if itemGroup != groupIndex {
                        groupIndex = itemGroup
                        currentColumIndex = self.nextColumnIndexForItem(index)
                    }
                }
                else {
                    currentColumIndex = self.nextColumnIndexForItem(index)
                }
                let xOffset = sectionInset.left + (itemWidth + self.minimumColumnSpacing) * CGFloat(currentColumIndex)
                let yOffset = columnHeights[currentColumIndex]
                let itemSize = self.delegate?.collectionView(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
                var itemHeight : CGFloat = 0.0
                if itemSize?.height > 0 && itemSize?.width > 0 {
                    itemHeight = floor(itemSize!.height*itemWidth/itemSize!.width)
                }

                attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectMake(xOffset, CGFloat(yOffset), itemWidth, itemHeight)
                itemAttributes.append(attributes)

                allItemAttributes.append(attributes)
                columnHeights[currentColumIndex] = Double(CGRectGetMaxY(attributes.frame))
            }

            sectionItemAttributes.append(itemAttributes)
        }

        let itemCounts = self.allItemAttributes.count
        var index = 0
        while(index < itemCounts){
            var rect1 = allItemAttributes[index].frame
            index = min(index + unionSize, itemCounts) - 1
            var rect2 = allItemAttributes[index].frame
            self.unionRects.append(CGRectUnion(rect1, rect2))
            index++
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        var numberOfSections = self.collectionView!.numberOfSections()
        if numberOfSections == 0 {
            return CGSizeZero
        }

        let contentWidth = self.collectionView!.bounds.size.width
        return CGSize(width: contentWidth, height: CGFloat(columnHeights.first!))
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }

    override func layoutAttributesForElementsInRect (rect : CGRect) -> [AnyObject] {
        var i = 0
        var begin = 0
        var end = unionRects.count
        var attrs = [AnyObject]()
        
        for var i = 0; i < end; i++ {
            if CGRectIntersectsRect(rect, unionRects[i]) {
                begin = i * unionSize;
                break
            }
        }
        for var i = self.unionRects.count - 1; i>=0; i-- {
            if CGRectIntersectsRect(rect, unionRects[i]) {
                end = min((i+1) * unionSize, allItemAttributes.count)
                break
            }
        }

        for var i = begin; i < end; i++ {
            var attr = allItemAttributes[i]
            if CGRectIntersectsRect(rect, attr.frame) {
                attrs.append(attr)
            }
        }
            
        return attrs
    }
    
    override func shouldInvalidateLayoutForBoundsChange (newBounds : CGRect) -> Bool {
        var oldBounds = self.collectionView!.bounds
        return CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)
    }

    private func shortestColumnIndex() -> Int {
        return find(columnHeights, minElement(columnHeights)) ?? 0
    }

    private func longestColumnIndex () -> NSInteger {
        return find(columnHeights, maxElement(columnHeights)) ?? 0
    }

    private func nextColumnIndexForItem (item : NSInteger) -> Int {
        switch (itemRenderDirection) {
        case .ShortestFirst: return self.shortestColumnIndex()
        case .LeftToRight: return (item % self.columnCount)
        case .RightToLeft: return (self.columnCount - 1) - (item % self.columnCount);
        }
    }
}