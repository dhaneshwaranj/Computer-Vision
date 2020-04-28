Dhaneshwaran Jotheeswaran
903204867

You just have to run proj1.m file in "code/proj1.m". This code generates the Hybrid image 
with dog.bmp as the low frequency component and cat.bmp as the high frequency component. 
I have chosen two cut-off frequencies for the hybrid image, one for the lowpass filter 
and one for the highpass filter. This seemed to work better. I have commented out the 
values that I used for generating the images. You just have to change the filename in 
the imread function and choose the cut-off frequency for the image you intend to generate.

That's pretty much it. There's nothing convoluted here to run the .m file. Thanks.