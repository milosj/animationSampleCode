//
//  DMRCollectionViewLayout.m
//  CollectionView
//
//  Created by Damir Tursunovic on 2/19/13.
//  Copyright (c) 2013 Damir Tursunovic (damir.me). All rights reserved.
//

#import "DMRCollectionViewLayout.h"

// Column sizes are determined in sizeForItemWithColumnType:
static NSUInteger kColumnTypeLarge      = 0;   // 66% collectionView width
static NSUInteger kColumnTypeDefault    = 1;   // 33% collectionView width

@interface DMRCollectionViewLayout ()

@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation DMRCollectionViewLayout

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setItemOffset:UIOffsetMake(0.0, 0.0)];
    }
    return self;
}

-(void)prepareLayout
{
    [self setItemAttributes:nil];
    _itemAttributes = [[NSMutableArray alloc] init];
    
    NSUInteger column = 0;    // Current column inside row
    
    CGFloat xOffset = _itemOffset.horizontal;
    CGFloat yOffset = _itemOffset.vertical;
    CGFloat rowHeight = 0.0;
    
    CGFloat contentWidth = 0.0;         // Used to determine the contentSize
    CGFloat contentHeight = 0.0;        // Used to determine the contentSize
    
    NSUInteger numberOfColumnsInRow = 1;
    
    // Loop through all items and calculate the UICollectionViewLayoutAttributes for each one
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];    
    for (NSUInteger index = 0; index < numberOfItems; index++)
    {        
        CGSize itemSize = [self sizeForItemWithColumnType:((index == 0) || (index % 3 ==0)) ? kColumnTypeLarge : kColumnTypeDefault];
        if (itemSize.height > rowHeight)
            rowHeight = itemSize.height;
        
        // Create the actual UICollectionViewLayoutAttributes and add it to your array. We'll use this later in layoutAttributesForItemAtIndexPath:
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
        [_itemAttributes addObject:attributes];
        
        xOffset = xOffset+itemSize.width+_itemOffset.horizontal;
        column++;
        
        // Create a new row if this was the last column
        if (column == numberOfColumnsInRow)
        {
            if (xOffset > contentWidth)
                contentWidth = xOffset;
            
            // Reset values
            column = 0;
            xOffset = _itemOffset.horizontal;
            yOffset += rowHeight+_itemOffset.vertical;
            rowHeight = 0;
            // Determine how much columns the new row will have
            numberOfColumnsInRow = ((index+1) % 3 == 0) ? 1 : 2;
        }
    }
    
    // Get the last item to calculate the total height of the content
    UICollectionViewLayoutAttributes *attributes = [_itemAttributes lastObject];
    contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
    
    // Return this in collectionViewContentSize
    _contentSize = CGSizeMake(contentWidth, contentHeight);
}

-(CGSize)collectionViewContentSize
{
    return _contentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_itemAttributes objectAtIndex:indexPath.row];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}




#pragma mark -
#pragma mark Helpers

-(CGSize)sizeForItemWithColumnType:(NSUInteger)columnType
{
    if (columnType == kColumnTypeDefault) {
        CGFloat w = self.collectionView.bounds.size.width*0.5-_itemOffset.horizontal;
        return CGSizeMake(w, 3*w/4);
    }
    if (columnType == kColumnTypeLarge) {
        CGFloat w = self.collectionView.bounds.size.width-_itemOffset.horizontal;
        return CGSizeMake(w, 3*w/4);
    }
    return CGSizeZero;
}

@end
