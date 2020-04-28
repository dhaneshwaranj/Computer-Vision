Dhaneshwaran Jotheeswaran
903204867

If you run the file as is, you will run the Bag of SIFTs + SVM. Comment and uncmment the 
relevant lines in proj4.m to run all 3 combinations.

Extra Credits (15)
I implemented the following extra credits.

Features at Multiple Scales (3)
I got SIFT features of the images at various scales. This is by default. But, I already 
generated the vocab.mat file and submitted.

Complementary Features (5)
I added the GIST features of the images to the feature space. I commented this out, because 
this didn't give me an improved accuracy.

Spatial Pyramid Representation (4)
I added spatial information in my feature space by implementing the spatial pyramid feature 
representation. This is by default.

Different Vocabulary Sizes (3)
I changed the size of the vocabulary and observed the change in the accuracy.