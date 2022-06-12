//
//  ProfileFlowLayout.swift
//  ProfileSofi
//
//  Created by Phil Wright on 6/12/22.
//

import UIKit

class ProfileCollectionViewLayout: UICollectionViewLayout {
    
    private let kSideItemWidthCoef: CGFloat = 0.33
    private let kSideItemHeightAspect: CGFloat = 1
    private let kNumberOfSideItems: CGFloat = 3
    private let kRowOffset: CGFloat = 2
    
    private var layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var columnsYoffset: [CGFloat]!
    private var contentSize: CGSize!
    
    private(set) var totalItemsInSection = 0
    private var mainItemSize: CGSize!
    private var sideItemSize: CGSize!
    private var columnsXoffset: [CGFloat]!
    private var totalColumns = 0
    private var interItemsSpacing: CGFloat = 8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.totalColumns = 2
    }
    
    var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        layoutMap.removeAll()
        columnsYoffset = Array(repeating: 0, count: totalColumns)
        
        totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        
        if totalItemsInSection > 0 && totalColumns > 0 {
            self.calculateItemsSize()
            
            var itemIndex = 0
            
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < totalItemsInSection {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let columnIndex = self.columnIndexForItemAt(indexPath: indexPath)
                
                let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnYoffset: columnsYoffset[columnIndex])
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect
                
                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                
                if itemIndex != 4 {
                    columnsYoffset[columnIndex] = attributeRect.maxY + interItemsSpacing
                }
                layoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }
            contentSize = CGSize(width: collectionView!.bounds.width - contentInsets.left - contentInsets.right,
                                 height: contentSizeHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutMap[indexPath]
    }
    
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        
        let columnIndex = indexPath.item % totalItemsInSection
        var section:Int = 0
        
        switch(columnIndex) {
        case 0,4,5: section = 0
        default: section = 1
        }
        return section
    }
    
    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        var size = columnIndex == 0 ? mainItemSize : sideItemSize
        
        if(columnYoffset > 0 && columnIndex == 0) {
            size = sideItemSize
        }
        
        if(indexPath.item == 5) {
            size = sideItemSize
            return CGRect(origin: CGPoint(x: columnsXoffset[2] - kRowOffset, y: columnsYoffset[columnIndex]), size: size!)
        }
        return CGRect(origin: CGPoint(x: columnsXoffset[columnIndex], y: columnYoffset), size: size!)
    }
    
    func calculateItemsSize() {
        let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let resolvedContentWidth = contentWidthWithoutIndents - interItemsSpacing
        
        // Calculate side item size first, in order to calculate main item height
        let sideItemWidth = resolvedContentWidth * kSideItemWidthCoef
        let sideItemHeight = sideItemWidth * kSideItemHeightAspect
        
        sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
        
        // Now we can calculate main item height
        let mainItemWidth = resolvedContentWidth - sideItemWidth
        let mainItemHeight = sideItemHeight * (floatNumberOfSideItems - 1) +  interItemsSpacing
        mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
        
        // Calculating offsets by X for each column
        columnsXoffset = [0, mainItemSize.width + interItemsSpacing, sideItemSize.width + interItemsSpacing]
    }
}
