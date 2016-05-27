AWCollectionViewDialLayout
==========================

UICollectionViewLayout for displaying cells in a semi-circle with a nice fish eye effect.

Very handy for quickly browsing items with your left thumb without having some of the content hidden behind your finger while you scroll.

![Demo Gif](http://www.antoinewette.com/github/awdiallayout.gif)


* * *
####Initialize Layout

```Objective-C
// Radius : The radius of your circle
// Angular spacing: Angle between items (deg)
// Cell Size: Size of your cell
// Alignment: Supports 2 Types: WHEELALIGNMENTLEFT and WHEELALIGNMENTCENTER
// X-Offset: To translate the circle along the x-axis

AWCollectionViewDialLayout *dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:300.0  andAngularSpacing:18.0 andCellSize:CGSizeMake(240, 100) andAlignment:WHEELALIGNMENTCENTER andItemHeight:100  andXOffset:70];
```

* * *
####Enable Snap Mode

```Objective-C
[dialLayout setShoulSnap:YES];
```

* * *
####Programmatically scroll to item at index

Use the **cell_height** variable you used to initialize the CollectionViewLayout and multiply it by the IndexPath.item 
```Objective-C
// Scroll to item at indexPath (0,2)
 [self.collectionView setContentOffset:CGPointMake(0, cell_height * 2) animated:YES];
```
* * *
#### Flip Horizontally

You can set the flip option to YES if you want to display your items on the right side of the CollectionView.

```Objective-C
[dialLayout setShoulFlip:YES];
```

* * *
