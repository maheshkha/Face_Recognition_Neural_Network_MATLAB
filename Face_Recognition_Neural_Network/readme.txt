Vision For Matlab
-----------------

About VFM
---------
VFM uses Microsoft's Video for Windows driver model, to access video source devices on the 
system. Upto ten such devices are possible in the current model. VFM provides functionality
to connect to these drivers, to modify their properties, and to capture still image 
sequences in a format suitable for Matlab.

Installation and Use
--------------------
Compiled binaries are in the 'compiled' folder. In order to use, extract these to a folder
in Matlab's path and type "help vfm" at the console for usage information. 

Source code is stored in the source directory. The projects were built using MS Visual C++ 
v6.0 (service patch 1). Compilation with earlier versions is possible, but may require the
recreation of the project file. This being the case, please ensure that the required Matlab
environment variable is setup as according to its documentation, and that the
Video for Windows library (vfw.lib) is linked in.

