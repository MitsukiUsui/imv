# imv
Integrative Movie Viewer (imv)

## What's this?
**Integrative Movie Viewer** (or **imv**) is an OSX application for visualizing a movie together with corresponding time-series numeric data. Time-series numeric data will be visualized as a waveform, and it will be automatically redrawn as you play, pause, and seek the movie. imv helps you bring boring lists of numeric data to life, and boost your understanding on the overview of those data.

## demo (temporal)
![test](demo/imv_proto_demo.gif)

## Prerequisites
You need Xcode >= 8.0 to build, as imv is written in Swift3.

## Usage
imv adopts simple drag & drop interface. Currently imv accepts 2 file types as input, `.mp4` for movie and `.txt` for time-series numeric data. 

### input format(.txt)
`.txt` needs to be composed of two parts 

1. a configuration header which starts with '#'
2. time-series numeric data stored line by line.

You can control how to draw a waveform by specifying configurations in the header line of `.txt`. 

e.g.) `#title=sample;fps=20;yMax=5;yMin=-5;windowSec=10`

The following is a description of each configuration field.

| Field | Type | Description |
|:--|:--:|:--|
|title|String|title of data|
|fps|Double|frame rate for the time-series data|
|yMax|Double|upper limit for plot|
|yMin|Double|lower limit for plot|
|windowSec|Double|Time range for the plot window|

