# KISS RC Curve Finder

This is a quick MATLAB script (*.m), I wrote to help me responsibly feel out a good RC curve in KISS Flight Controller that has equal sensitivity at "center-stick" & the same end points at "full-stick". It generates a number of RC curves that meet the slope & end-point criteria you define while varying the exponential-ness. The two output plots both have a legend with the RC Rate, Rate, & Curve shenanigan parameters for each curve that the KISS configurator then uses. Below is a test output:


