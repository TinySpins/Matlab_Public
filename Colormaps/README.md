## Colormaps
These are custom colormaps for plotting in Matlab.


### Creating new Colormaps
Additional colormaps can easily be generated [here](http://jdherman.github.io/colormap/). When creating a new colormap script, follow the structure below

```matlab
% NewColormap

function [NewColormap] = NewColormap();
NewColormap = [
% The generated colormap values go here..
]./255;
end
```


### Usage
A custom colormap can be called using

```matlab
colormap(MyColormap);
```

Where MyColormap is the name of the custom colormap you want to use.
Normally, a colormap is called in Matlab via colormap(‘jet’), but the ‘ ’ are not needed for this custom format.
