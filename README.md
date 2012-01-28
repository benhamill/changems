# Changems

On the [Ruby Rogues](http://rubyrogues.com) podcast, [Nick Quaranto](http://quaran.to) (of [Gem Cutter](http://rubygems.org) fame) was talking about rubygems-related projects he'd like to see. He mentioned something about a web app that would do something with gems' change logs. I thought that sounded like an interesting idea.

I envision an app that tracks entries that gem authors put in their change log and allows users to easily see what changes are associated with which version. Users will be able to search for gems by name and then browse their versions or select a range of versions to see changes from.

## Road Map

Some ideas for features I'll be working towards. I'm open to other ideas. In no particular order:

- API end point to get the changes in a given release
- API end point to get the changes between 2 arbitrary releases
- A design that looks good
- Something intereting on the home page
- Make the version number regexp in the parser smarter and able to find "... 1.2.3 beta1 ..." even though space is not strictly allowed in a version number.

## Getting Started With The Project

### 0. Ruby Version

Changems is designed to run on Ruby **1.9.2** and RubyGems **1.8.15**. That latter is why rubygems is vendored; so I can make Heroku load that instead of the older version they're using.

### 1. Setup

Bundle the gems

    $ bundle install

Create, migrate and seed the DB.

    $ rake db:setup

### 2. Tests

First, run 'em.

    $ rake spec

The app is designed to import change logs via a background job, so we don't have creates, updates or deletes. Thus, we just load the seed file before the test suite, run all the tests and then delete it. Knowing what's in the seed file will make the tests make more sense, so make sure to give it a glance.

My personal philosophy is that you should have high level tests that cover everything and only write unit tests to cover tricky stuff in isolation. So, in general, prefer adding a request spec that examines a change or feature from the user point of view. If there's some particularly hairy piece of business logic in a model somewhere, that's a great time to roll out the unit-style tests.

## Help?

Oh please yes!

1. Fork it.
2. Feature branch.
3. Write test.
4. Make test pass.
5. Send pull request.
6. If I'm particularly slow to respond, add a comment **@mentioning** me and I'll get an email.
