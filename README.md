iris
====

Iris Recognition Algorithms Comparison between Daugman algorithm and Hough transform on Matlab.

###DESCRIPTION:
Iris is one of the most important biometric approaches that can perform high confidence recognition.
Iris contains rich and random Information.
Most of commercial iris recognition systems are using the Daugman algorithm. The algorithms are using in this case from open sourse 
with modification, if you want to use the source code, please check the LICENSE.

###Daugman algorithm:

![image](https://github.com/Qingbao/iris/raw/master/images/1.jpg)

where I(x,y) is the eye image, r is the radius to searches
over the image (x,y), G(r) is a Gaussian smoothing function. The algorithm starts to search from the pupil, 
in order to detect the changing of maximum pixel values (partial derivative).

![image](https://github.com/Qingbao/iris/raw/master/images/2.jpg)

![image](https://github.com/Qingbao/iris/raw/master/images/3.jpg)


###Hough transform:

![image](https://github.com/Qingbao/iris/raw/master/images/4.jpg)

The Hough transform is a feature extraction technique used in image analysis, computer vision, and digital image processing.
where (xi, yi) are central coordinates, and r is the radius. Generally, and eye would be modeled by two circles,
 pupil and limbus (iris region), and two parabolas, upper and lower eyelids

Starts to detect the eyelids form the horizontal direction, then detects the pupil and iris boundary by the 
vertical direction.

![image](https://github.com/Qingbao/iris/raw/master/images/5.jpg)

![image](https://github.com/Qingbao/iris/raw/master/images/6.jpg)

###NORMALIZATION AND FEATURE ENCODING:
From circles to oblong block By using the 1D Log-Gabor filter.
In order to extract 9600 bits iris code, the upper and lower eyelids will be processed as a 9600 bits mask during the encoding.

![image](https://github.com/Qingbao/iris/raw/master/images/7.jpg)
![image](https://github.com/Qingbao/iris/raw/master/images/8.jpg)
![image](https://github.com/Qingbao/iris/raw/master/images/9.jpg)

###MATCHING:
Hamming distance (HD):
![image](https://github.com/Qingbao/iris/raw/master/images/10.jpg)
where A and B are subjects to compare, which contains 20*480=9600 template bits and 20*480=9600 mask bits, respectively, in order to calculate by using XOR and AND boolean operators.


###Results:
CASIA Iris Image Database(version 1.0) (http://biometrics.idealtest.org/dbDetailForUser.do?id=1): 756 iris images form 108 different subjects. High quality of images by using NIR camera.

Resolution of 320*280.

Totally, 756*755/2=285390 pairs of comparison for each algorithm, 2268 for intra-class comparison and 283 122 for inter-class comparison.

###EER:
Daugman algorithm: 0.0157    Hough transform: 0.0500


