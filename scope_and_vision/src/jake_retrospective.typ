= Retrospective
#label("retrospective")
#strong[Author:] Jake Goodwin #strong[Class:] CS461 #strong[DATE:] 2023

== Start-Stop-Continue
#label("start-stop-continue")
=== Start
#label("start")
So there are a couple of things I think would probably be useful for our
team moving forwards.

-  More people making use of the github issues/milestones.
-  More work on writing unit tests
-  Start writing comprehensive documentation for each teams
  deliverables.

=== Stop
#label("stop")
-  Trying to commit code directly to repos.
-  Using unprotected github branches.

=== Continue
#label("continue")
-  Weekly team meetings.
-  Working together on assignments using our VCS(version control
  system).
-  Completing github issues and milestones.
-  Committing to forks before submitting pull requests.
-  Posting updates in discord/teams on the projects status.

== Action Items
#label("action-items")
=== Unit tests
#label("unit-tests")
This is the big one for me or my priority item. If we can commit to
making use of TDD we can remove a lot of the possible issues or
misunderstandings up front.

This becomes even more important for the hardware/firmware team because
of how much more time intensive it can be trying to debug issues on a
embedded system versus a regular laptop or desktop machine that supports
a full operating system along with system logging like FreeBSD or Linux.

#strong[TimeLine:] I’m going to self assign the project of setting of
the testing framework/harness for our stm32F103C8TX MCU. Hopefully I can
start to learn more about how TDD is done with rust compared to using
Cmocka or Unity for C and C++.
