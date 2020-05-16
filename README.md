AI self learning car game on Processing.

The objective of the game is to reach from the start point to the end point.
There are several variables to adjust which will determine how well the machine
will develop the map. Tweaking these variables will determine the accurancy and
efficiency of this program.

The main variables are:

epochSize - This variable determines the number of cars per test. Increasing
this will allow for a larger sample of data per test, however it will require
more memory per test.

learnRate - This variable determines the rate at which the map will learn. A
more accurate result can be achieved by decreasing the learn rate, however this
will require more tests to train the map. A higher learn rate will train the map
faster, however it may result in inaccurate results. It is best to find a
balance of both.

driveDistance - The distance of each step for the car. Only use a distance that is
a factor of the distance between the start and end point (i.e if the distance 
between start and end point is 100, suitable driveDistance includes: 1, 2, 4, 5, 10,
and so on).

endTime - The variable determines to time in milliseconds for each test. A longer 
timeframe will train the map much quicker, however, it may produce inaccurate results.
The car travels one driveDistance per millisecond. In order for the game to be possible,
use a minimum time of the distance between the start and end point (i.e if the distance 
between start and end point is 100, a minimum endTime would be 100 for the game to be
possible).

The tests will autosave at every 100 runs and files can be found in the processing
directory called Map.txt and RunCount.txt
