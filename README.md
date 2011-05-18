What is Conneccty
==================

The simple and easy to use service for collecting user feedback.

How?
==================
1. Register and create your project
2. Insert code provided into your web site.
3. That is it.


What can I do with it?
======================

Users of a web site can:
-------------------------------------------------

- create suggestions;
- no any registration required for them (so they are more likely to leave feedback for ya);
- vote for existing suggestions;


You, as an owner of a web site, can:
------------------------------------
- have multiple projects;
- have multiple projects within one web site (thus feedback for different areas of the site);
- use the same project across multiple web sites (so you can accumulate all the feedback in one place);
- invite users to a project, so more people can moderate it;
- mark suggestions as 'In-Progress', 'Done' etc, so that users can see how great you are responding to the feedback;
- copy a suggestion to PivotalTracker as a Story, so that your team can actually start working on it;
- more features are to come with *your help*, please leave some feedback for us.


Just show me
============
If you want to get the feel of it, we host the service at [connecty.ApproachE.com](http://connecty.ApproachE.com).

Run it yourself
==================

    gem install rails
    git clone https://github.com/dnagir/connecty.git
    cd connecty
    bundle
    rake db:migrate
    rails server

You will also need to configure:

- [Rails Mailer](http://guides.rubyonrails.org/action_mailer_basics.html#example-action-mailer-configuration)



Requirements
============
A user must run a modern browser.
No specific requirement for a web site to use Connecty.
Server running Connecty is Rails 3 compatible with RDBMS.


License
=================
MIT


Who is using?
================
- [PropConnect Pty Ltd](http://www.propconnect.com).
- [Approach Excellence](http://www.ApproachE.com).
- [Blog of @dnagir](http://blog.ApproachE.com).


Credits
=================
Supported and sponsored by [PropConnect Pty Ltd](http://www.propconnect.com).
Maintened by [Dmytrii Nagirniak](http://ApproachE.com).
