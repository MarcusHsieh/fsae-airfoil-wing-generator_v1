# FSAE Front Wing Generator
This is a Matlab script that can create a 2D side view of the front wing for an FSAE car (small F1-style racing cars) 

## Why?

This allows the user to modify and adjust values (Angle of attack, scale, position) before throwing it into CAD Design software. Ensures consistency of position, sizing, and rotation during the CAD process.

## How does it work?

1.  Pick an airfoil of choice from an airfoil database (example file is airfoil E423)
    -  Download its DAT file (coordinates) into a .txt file
    -  Rename it conventionally 
    -  Put it into the same folder as the .mlx and .m files.
2.  Change the 2nd line in FrontWingEditorScript.mlx to contain your .txt file ("*[your file].txt*")
3.  Adjust each value for each element to your preferences
    - Base airfoil (if using multiple airfoils, make sure to load each one)
    - Flip airfoil (typically true)
    - Angle of attack (rotation)
    - Scale (size)
    - Output file name
    - Translate (position)
4. Depending on the number of elements, comment and uncomment the other *combinedCoordinates* variable to create the full list of coordinates to display
5. Run the .mlx file
6. Will write 3 files with the coordinates of each element in the folder (...\fsae-front-wing-generator)
