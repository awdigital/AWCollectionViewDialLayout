AWCollectionViewDialLayout
==========================

UICollectionViewLayout for displaying cells in a semi-circle with a nice fish eye effect.

Very handy for quickly browsing items with your left thumb without having some of the content hidden behind your finger while you scroll.

* * *
Usage:
* * *
```
// Radius : The radius of your circle
// Angular spacing: Angle between items (deg)
// Cell Size: Size of your cell
// Alignment: Supports 2 Types: WHEELALIGNMENTLEFT and WHEELALIGNMENTCENTER
// X-Offset: To translate the circle along the x-axis

AWCollectionViewDialLayout *dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:300.0  andAngularSpacing:18.0 andCellSize:CGSizeMake(240, 100) andAlignment:WHEELALIGNMENTCENTER andItemHeight:100  andXOffset:70];
```

* * *
Screenshots:
* * *
![Screenshot 1](http://raw.github.com/awdigital/AWCollectionViewDialLayout/master/AWCollectionViewDialLayoutDemo/awcollectionviewdiallayout_1.jpg)

![Screenshot 2](http://raw.github.com/awdigital/AWCollectionViewDialLayout/master/AWCollectionViewDialLayoutDemo/awcollectionviewdiallayout_2.jpg)


* * *
Video
* * *
[![ScreenShot](http://antoinewette.com/github/vimeo_screenshot.jpg)](https://vimeo.com/89403786)
