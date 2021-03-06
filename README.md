# imv
Integrative Movie Viewer (imv)

## What's this?
**Integrative Movie Viewer** (or **imv**) is an OSX application for visualizing a movie together with a corresponding time-series data (numeric or categorical). Time-series data will be visualized as a waveform (numerical) or an colored bar (categorical), and they will be automatically redrawn as you play, pause, and seek the movie. imv helps you bring boring lists of time-series data to life and boost your understanding on the data.

## demo (temporal)
![test](demo/imv_proto_demo.gif)

## Prerequisites
You need Xcode >= 8.0 to build this project as imv is written in Swift3.

## Usage
### Input
imv adopts a simple drag & drop interface. imv accepts 3 file types as an input, `.mp4`(movie) ,`.txt`(numeric), and `.txt`(categorical). The following is a description of the　formats.

#### 1.movie
Just a mp4.

#### 2.numeric

`.txt`(numeric) is a plain text which is composed of the following 2 parts.

1. a configuration header starts with '#'
2. time-series numeric data stored line by line

You can control how to draw a waveform by specifying configurations in the header line of `.txt`. Each configuration should be given in a form of `Field=Value` with `;` as a separator.

e.g.) `#title=sample;fps=20;yMax=5;yMin=-5;windowSec=10`

The following is a description of each configuration field.

| Name | Type | Description |
|:--|:--:|:--|
|fps|Double|Frame rate for the time-series data|
|windowSec|Double|Time range for the plot window|
|title|String|Title of the data|
|yMax|Double|Upper limit for plot|
|yMin|Double|Lower limit for plot|

* **!!!FIELD NAME IS CASE SENSITIVE!!!**

#### 3.categorical

`.txt`(categorical) is a plain text which is composed of the following 3 parts.

1. a configuration header starts with '#'
2. a color configuration header starts with '##'
3. time-series categorical data stored line by line

You can control how to draw a bar by specifying configurations in the first header line.

e.g.) `#fps=20;windowSec=60`

You can also control the colors of a bar by specifying an HTML color code for each category in the second header line. If given no color code, white will be automatically assigned to the category.

e.g.) `##ctg1=002FDC;ctg2=289772;ctg3=FA919B`

### Padding
In case the first sample of time-series data does not correspond to 0 sec for the movie, you can specify the gap seconds in the text field bottom left.
