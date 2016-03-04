# Spark
Spark Client for OpenFire Instant Messaging server

These are just a couple of files I use to customize the install and launch of the Spark Client.
The spark.exe does not allow for command-line switches, and all the preferences are stored for each user under their APPDATA directory.

All files are included with the installer in an executeable WinRAR file which expands everything to the C:\Spark directory.  It then runs the installer batch file.

The installer batch file:
  Launches the install
  Addes a version text file
  Copies the launch script into the Application Directory
  Modifies the shortcuts.

The launch script:
  Changes the required Spark properties files
  Launches the Spark Application
