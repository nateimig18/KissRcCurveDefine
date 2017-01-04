# KISS RC Curve Finder

This is a quick MATLAB script (*.m), I wrote to help me responsibly feel out a good RC curve in KISS Flight Controller that has equal sensitivity at "center-stick" & the same end points at "full-stick". It generates a number of RC curves that meet the center slope & end-point criteria you define while varying the degree of width for the curve's center-stick linearity region. The two output plots both have a legend with the RC Rate, Rate, & Curve shenanigan parameters for each curve that the KISS configurator then uses. Below is a test output:

# Test output plots:
![kiss_rc_curve sensitivity_curve v2](https://cloud.githubusercontent.com/assets/3208983/21647160/beda1da8-d25e-11e6-856f-9a59be0ba0aa.png)

# Application
To provide a little more user friendly way to find an RC-curve that fits your desired flight profile without the constant end-points & center sensitivity parameters changing. 

## TODO:
Learn how to make a Chrome GUI Addon for this.

# Another (Better) Explanation from "FinalGlideAus"
[linkname](https://youtu.be/mqRzJKC-FHo?t=432)
