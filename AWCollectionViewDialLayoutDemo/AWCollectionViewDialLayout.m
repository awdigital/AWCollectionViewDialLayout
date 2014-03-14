//
//  DialLayout.m
//  ggl_archives
//
//  Created by Antoine Wette on 30.10.13.
//  Copyright (c) 2013 Antoine Wette. All rights reserved.
//

#import "AWCollectionViewDialLayout.h"

@implementation AWCollectionViewDialLayout

- (id)init
{
    if ((self = [super init]) != NULL)
    {
		[self setup];
    }
    return self;
}

-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andItemHeight:(CGFloat)height andType: (int) type andXOffset: (CGFloat) xOff{
    if ((self = [super init]) != NULL)
    {
        self.dialRadius = radius;//420.0f;
        self.cellSize = cell;//(CGSize){ 220.0f, 80.0f };
        self.itemHeight = height;
        self.AngularSpacing = spacing;//8.0f;
        self.wheelType = type;
        self.xOffset = xOff;        
        [self setup];
    }
    return self;
}

- (void)setup
{    
	self.snapToCells = NO;
    self.offset = 0.0f;
    
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.offset = -self.collectionView.contentOffset.y / self.itemHeight;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return(YES);
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    
    float minY = CGRectGetMinY(rect);
    float maxY = CGRectGetMaxY(rect);
    
    int firstIndex = floorf(minY / self.itemHeight);
    int lastIndex = floorf(maxY / self.itemHeight);
    int activeIndex = (int)(firstIndex + lastIndex)/2;
    
    int maxVisibleOnScreen = 180 / self.AngularSpacing + 2;
    
    int firstItem = fmax(0, activeIndex - (int)(maxVisibleOnScreen/2) );
    int lastItem = fmin( self.cellCount-1 , activeIndex + (int)(maxVisibleOnScreen/2) );

    //float firstItem = fmax(0 , floorf(minY / self.itemHeight) - (90/self.AngularSpacing) );
    //float lastItem = fmin( self.cellCount-1 , floorf(maxY / self.itemHeight) );
    
    
    
    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
 
    
    return [theLayoutAttributes copy];
}



- (CGSize)collectionViewContentSize
{
    const CGSize theSize = {
        .width = self.collectionView.bounds.size.width,
        .height = (self.cellCount-1) * self.itemHeight + self.collectionView.bounds.size.height,
    };
    return(theSize);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double newIndex = (indexPath.item + self.offset);
    
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    theAttributes.size = self.cellSize;
    float scaleFactor;
    float deltaX;
    CGAffineTransform translationT;
    CGAffineTransform rotationT = CGAffineTransformMakeRotation(self.AngularSpacing* newIndex *M_PI/180);
    if( self.wheelType == 1 ){
        scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
        deltaX = self.cellSize.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset  , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius + (deltaX*scaleFactor) , 0);
    }else{
        scaleFactor = fmax(0.4, 1 - fabs( newIndex *0.50));
        deltaX =  self.collectionView.bounds.size.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + deltaX , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius  + ((1 - scaleFactor) * -30) , 0);
    }
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    theAttributes.alpha = scaleFactor;
    
    /*
    if( fabs(self.AngularSpacing* newIndex) > 90 ){
        theAttributes.hidden = YES;
    }else{
        theAttributes.hidden = NO;
    }
     */
    
    theAttributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    theAttributes.zIndex = indexPath.item;
    
    return(theAttributes);
}



@end
