ScrollWatcher
=============

Know when the user is touching a UIScrollView, or its moving on its own, to prevent CPU intensive tasks from affecting the UI.

The base UITableViewController subclass in **FilesYouNeed** provides the core capability to indicate user interaction with a scrollView.

The ViewController super class uses key-value observing to monitor changes, and move a **worker** block from the high priority queue to the background one.

The current code uses a block that simply bumps a counter and sends updates to a label in the scrollView. You can see that the rate of updates drops when the user is manipulating the scrollView.

At this time, the simple table and counter do not cause the tableView to stutter if the block is NOT moved to the background queue. I plan to update this project in the future to add a bunch of web fetchers to really load the program down, and that should make the value of this technique much more apparent (I did exactly this at my last job, to greatly improve responsiveness while running in huge numbers of web fetchers in the background.)

UPDATE: added a second UIScrollView based UIViewController to verify interworking with horizontal scrolling.

Copyright (c) 2013 David Hoerl

License "Unattributed BSD"
