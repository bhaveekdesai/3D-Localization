# 3DAudio
3Daudio repository


How to set up the system:
1.	Determine which sensor beacons you will be using
1.1	Choose a beacon to act as the bottom left corner it will be at 0,0

2.	On line 58 of Localization_UDP.m type the list of beacons with the 0,0 beacon first and the others in any order

3.	Now physically set up the beacon high on walls forming a general square/rectangle with the bottom left being the chosen beacon

4.	Now you can start the program.
4.1	The program wil automatically detect and create a window in the size of the room with the 0,0 beacon being at 0,0

5.	No you can populate the environment by clicking onto the window as many times as you need
5.1 To set the sound file of each sound, choose the sound number in the drop down menu and the the sound file you want in the right drop down menu. Then click save.
5.2 To move the sound, choose the sound in the left drop down menu and the use the arrow keys. These work even while the program is running
5.3 Type a SubjectID to keep track of your subjects and press enter
5.4 Now press start and everything should work!

6. To stop the program just close the window and it will automatically save the SubjectID, the path they took and how long it took them.



FUTURE WORK
1. Interpolating angles currently buggy
2. Improve code to make use location update smoother
	Currently there is a minumum distance required to move and moves the player depending on how far they are
3. Have save and load functionality for the menu
4. Clean up code by making more object oriented (ie make a prelim work on localizationm manager)
