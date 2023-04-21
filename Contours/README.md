## Contours
These are some scripts for handeling contours in Matlab, mostly for making specific tasks faster to perform.


### GetContourValues.m
This script can be used to easily get the mean, median or sum of the image values defined by a contour.

**Usage examples**

*For an 'image' and a 'contour'*

```matlab
[mean, std] = GetContourValues(contour, image, 'mean');
```
