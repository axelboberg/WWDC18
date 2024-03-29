# WWDC18

## TLDR;
A demo of a machine learning model made to classify photographs of notes, here used on drawings.

## What this is
A year-long graduation project is a requirement of the swedish upper secondary school.
My project, a machine learning model trained to recognize photographs of music notes (middle-C to B), resulted in this demo.

However, the playground restricted me from using the camera as it's not availble in the iOS simulator and so I had to find another solution. That solution was to add a canvas allowing the user to draw the noteheads. As expected, since the model was trained on photographs, this solution did not yield great results from the classifier. Still this demo acts as a working proof of the model's aspirations.

As a final touch I added an algorithm calculating the note from the location of the points in the drawing.
The output from this algorithm acts as a complement to the machine-learning output.

## Dataset
I collected all data in the dataset myself through a combination of a home-made iOS app allowing me to automatically upload
cropped photographs to my webserver and data collected from the open-source sheet website http://www.mutopiaproject.org/
A total of 3000 photographs were collected.
The final dataset contained about 700 photographs (after selecting only the highest-quality datapoints).

## Contact
For questions or contact in general, send me an email at hello[at]axelboberg.se or meet me at WWDC18.
