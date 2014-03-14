//
//  DialLayout.h
//  ggl_archives
//
//  Created by Antoine Wette on 30.10.13.
//  Copyright (c) 2013 Antoine Wette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWCollectionViewDialLayout : UICollectionViewLayout

@property (readwrite, nonatomic, assign) int cellCount;
@property (readwrite, nonatomic, assign) int wheelType;
@property (readwrite, nonatomic, assign) CGPoint center;
@property (readwrite, nonatomic, assign) CGFloat offset;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat xOffset;
@property (readwrite, nonatomic, assign) CGSize cellSize;
@property (readwrite, nonatomic, assign) CGFloat AngularSpacing;
@property (readwrite, nonatomic, assign) CGFloat dialRadius;
@property (readwrite, nonatomic, assign) BOOL snapToCells;
@property (readonly, nonatomic, strong) NSIndexPath *currentIndexPath;


-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andItemHeight:(CGFloat)height andType: (int) type andXOffset: (CGFloat) xOffset;
@end
