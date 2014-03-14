//
//  ViewController.m
//  AWCollectionViewDialLayoutDemo
//
//  Created by Antoine Wette on 14.03.14.
//  Copyright (c) 2014 Antoine Wette. All rights reserved.
//

#import "ViewController.h"
#import "AWCollectionViewDialLayout.h"

@interface ViewController ()

@end

static NSString *cellId = @"cellId";


@implementation ViewController{
    NSMutableDictionary *thumbnailCache;
}

@synthesize collectionView, items;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [collectionView registerNib:[UINib nibWithNibName:@"dialCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    
    
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"players" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"jsonString:%@",jsonString);
    items = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    CGFloat radius = 300;
    CGFloat angularSpacing = 18;
    CGFloat xOffset = 70;
    CGFloat cell_width = 240;
    CGFloat cell_height = 100;
    AWCollectionViewDialLayout *dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andItemHeight:cell_height andType:1 andXOffset:xOffset];
    [collectionView setCollectionViewLayout:dialLayout];
    
    //[collectionView reloadData];
   
	// Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *visiblePaths = [collectionView indexPathsForVisibleItems];
    NSLog(@"visiblePaths:%@", visiblePaths);
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.item];
    
    NSString *playerName = [item valueForKey:@"name"];
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
    [nameLabel setText:playerName];
    
    
    
    
    NSString *imgURL = [item valueForKey:@"picture"];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    
    UIView *borderView = [cell viewWithTag:102];
    NSString *hexColor = [item valueForKey:@"team-color"];
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = [self colorFromHex:hexColor].CGColor;
 
    
    
    [imgView setImage:nil];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        imgView.image = imageProduct;
    }
    else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
    
    return cell;
}


- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

-(UIColor*)colorFromHex:(NSString*)hexString{
    unsigned int hexint = [self intFromHexString:hexString];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];
    
    return color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
