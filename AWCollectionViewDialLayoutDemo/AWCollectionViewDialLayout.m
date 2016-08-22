//
//  AWCollectionViewDialLayout.m
//
//
//  Created by Antoine Wette on 30.10.13.
//  Copyright (c) 2013 Antoine Wette. All rights reserved.
//
//  info@antoinewette.com
//  www.antoinewette.com
//

#import "AWCollectionViewDialLayout.h"

@implementation AWCollectionViewDialLayout{
    BOOL shouldSnap;
    BOOL shouldFlip;
    CGPoint lastVelocity;
}



- (id)init
{
    if ((self = [super init]) != NULL)
    {
		[self setup];
        shouldSnap = NO;
        shouldFlip = NO;
    }
    return self;
}

-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andAlignment:(WheelAlignmentType)alignment andItemHeight:(CGFloat)height andXOffset: (CGFloat) xOff{
    if ((self = [super init]) != NULL)
    {
        shouldSnap = NO;
        shouldFlip = NO;

        self.dialRadius = radius;
        self.cellSize = cell;
        self.itemSize = cell;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.itemHeight = height;
        self.AngularSpacing = spacing;
        self.xOffset = xOff;
        self.wheelType = alignment;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
        self.sectionInset = UIEdgeInsetsZero;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        [self setup];
    }
    return self;
}

-(void)setShouldSnap:(BOOL)value{
    shouldSnap = value;
}

-(void)setShouldFlip:(BOOL)value{
    shouldFlip = value;
}

- (void)setup
{
    self.offset = 0.0f;    
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cellCount = (self.collectionView.numberOfSections > 0)? (int)[self.collectionView numberOfItemsInSection:0] : 0;
    self.offset = -self.collectionView.contentOffset.y / self.itemHeight;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}




- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    

    int maxVisiblesHalf = 180 / self.AngularSpacing;
    
    //float firstItem = fmax(0 , floorf(minY / self.itemHeight) - (90/self.AngularSpacing) );
    //float lastItem = fmin( self.cellCount-1 , floorf(maxY / self.itemHeight) );
    int lastIndex = -1;
    for( int i = 0; i < self.cellCount; i++ ){
        CGRect itemFrame = [self getRectForItem:i];
        if(CGRectIntersectsRect(rect, itemFrame) && i > (-1*self.offset - maxVisiblesHalf) && i < (-1*self.offset + maxVisiblesHalf)){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [theLayoutAttributes addObject:theAttributes];
            lastIndex = i;
        }
    }
    
    return theLayoutAttributes;
}



-(CGRect)getRectForItem:(int)item{
    double newIndex = (item + self.offset);
    float scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
    float deltaX = self.cellSize.width/2;
    float rX = cosf(self.AngularSpacing* newIndex *M_PI/180) * (self.dialRadius + (deltaX*scaleFactor));
    float rY = sinf(self.AngularSpacing* newIndex *M_PI/180) * (self.dialRadius + (deltaX*scaleFactor));
    float oX = -self.dialRadius + self.xOffset - (0.5 * self.cellSize.width);
    float oY = self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y - (0.5 * self.cellSize.height);
    
   
    if(shouldFlip){
       oX = self.collectionView.frame.size.width + self.dialRadius - self.xOffset - (0.5 * self.cellSize.width);
       rX *= -1;
    }
    
    CGRect itemFrame = CGRectMake(oX + rX, oY + rY, self.cellSize.width, self.cellSize.height);
    
    return itemFrame;
}



-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    if(shouldSnap){
        int index =(int)floor(proposedContentOffset.y / self.itemHeight);
        int off = ((int)proposedContentOffset.y % (int)self.itemHeight);
        
        CGFloat targetY = (off > self.itemHeight * 0.5 && index <= self.cellCount)? (index+1) * self.itemHeight: index * self.itemHeight;
        return CGPointMake(proposedContentOffset.x, targetY );
    }else{
        return proposedContentOffset;
    }    
}

-(NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position{
    NSLog(@"targetIndexPathForInteractivelyMovingItem");
    return [NSIndexPath indexPathForItem:0 inSection:0];
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
    
    if(shouldFlip){
        rotationT = CGAffineTransformMakeRotation(-self.AngularSpacing* newIndex *M_PI/180);
    }

    CGFloat minRange = -self.AngularSpacing / 2.0;
    CGFloat maxRange = self.AngularSpacing / 2.0;
    CGFloat currentAngle = self.AngularSpacing*newIndex;
    
    if ((currentAngle > minRange) && (currentAngle < maxRange)) {
        self.selectedItem = indexPath.item;
    }
    
    if( self.wheelType == WHEELALIGNMENTLEFT){
        
        scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
        CGRect newFrame = [self getRectForItem:(int)indexPath.item];
        theAttributes.frame = CGRectMake(newFrame.origin.x , newFrame.origin.y, newFrame.size.width, newFrame.size.height);
        translationT =CGAffineTransformMakeTranslation(0 , 0);
    }else  {
        scaleFactor = fmax(0.4, 1 - fabs( newIndex *0.50));
        deltaX =  self.collectionView.bounds.size.width/2;
        
        if(shouldFlip){
            theAttributes.center = CGPointMake( self.collectionView.frame.size.width + self.dialRadius - self.xOffset , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
            translationT =CGAffineTransformMakeTranslation( -1 * (self.dialRadius  + ((1 - scaleFactor) * -30)) , 0);
            NSLog(@"should Flip ");
        }else{
            theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
            translationT =CGAffineTransformMakeTranslation(self.dialRadius  + ((1 - scaleFactor) * -30) , 0);
            NSLog(@"should not Flip ");
        }
    }
    
    
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    theAttributes.alpha = scaleFactor;
    theAttributes.hidden = NO;
    
    theAttributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    
    return(theAttributes);
}



@end
