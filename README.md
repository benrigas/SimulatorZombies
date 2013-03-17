SimulatorZombies
================

Mac application to count Xcode zombie processes.

OS X Mountain Lion (10.8) and XCode have a bug that creates a Zombie process every time you build, run, 
and exit an iOS application in the iOS Simulator. There is no way to kill these processes, so eventually 
the system's maximum process limit is hit. The only way to clean this up is to reboot.

Keep an eye on your zombie count with notifications and an easy to read status window. Share your zombie counts with your friends on Twitter and Facebook with the built in NSSharingServicePicker.

This app requires Mountain Lion and Xcode 4.5+, mostly because that's the only combination that is causing the bug.

I've chosen to distribute this as source only, because if you're not writing code all day in Xcode then you probably don't give a care about this app.
