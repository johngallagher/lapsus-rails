Lapsus
======

Step 1
======

Track time for project container folders

Stories
--------

As a user I want to CRUD project container folders
As a user I want to see how much time I've spent on each project
As a user I want to approve times so far
As an API generator I want to POST my times to an endpoint
As an API consumer I want to see how long I've spent on projects

"The simplest thing that can work"

* CRUD project container folders
* Container folders define what's a project
* Anything within a project folder gets tracked to that project
* No manual assignment of individual entries
* Any time between documents is assigned to the last project (maybe an option to assign to no project)
* Approve times so far (a single button - very simple - fixes times so far)

User Experience

1. Log in
2. Setup or edit project container folders
3. Approve times to date
4. View times

Questions

* How does the user see times? (some kind of pie chart? With numbers below in a table?)
* How does approve work? Is it destructive? (Probably yes)
* Does this app need javascript on for it to work? (Get a very basic non JS UI working first)
* What browsers do we support?


Long Term Objective
----------

A time tracker that is minimal hassle and tells you how long you spend on projects.

Killer usability and really fast. Looks nice too. Most importantly - really useful!

Maximise intelligence to reduce data input.
