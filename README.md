# Changems

On the [Ruby Rogues](http://rubyrogues.com) podcast, [Nick
Quaranto](http://quaran.to) (of [Gem Cutter](http://rubygems.org) fame) was
talking about rubygems-related projects he'd like to see. He mentioned something
about a web app that would do something with gems' change logs. I thought that
sounded like an interesting idea.

I envision an app that tracks entries that gem authors put in their change log
and allows users to easily see what changes are associated with which version.
Users will be able to search for gems by name and then browse their versions or
select a range of versions to see changes from.

## Road Map

Some ideas for features I'll be working towards. I'm open to other ideas. In no
particular order:

- API end point to get the changes in a given release.
- API end point to get the changes between 2 arbitrary releases.
- A design that looks good.
- Something intereting on the home page.
- Make the version number regexp in the parser smarter and able to find "...
  1.2.3 beta1 ..." even though space is not strictly allowed in a version
  number.
- Some kind of auto-import for gems the app doesn't know about.
- Some kind of check-for-updates for gems the app *does* know about.
- Improve search (next version of texticle has trigram?)

## Release Notes Parsing

In general, my idea is that release notes in markups like Markdown and
RDoc--ones that have a defined method to render them into HTML--should adhere to
these guideslines. I looked at a few high profile gems to come up with these,
but I'm willing to entertain discussion on their worthiness.

1. The release notes MAY have whatever it wants as preamble.
2. The release notes MUST be divided into sections describing a release with
   each section headed by a level 2 header (H2 tag?) followed by the release's
   notes.
3. The header for a release MUST include the version number and it should be
   valid according to `Gem::Version.new`.
4. The notes for a particular release MAY be in whatever format the author
   wishes, but unordered lists are super-awesome.
5. The release notes MUST be kept in their own file in a gem's root directory
   and be named to match `/^(changelog|changes|history)/i`.
6. The gem MUST be published to [rubygems.org](http://rubygems.org/).

To see what markups the app can handle importing, check out
[app/models/release_notes_parser/*](https://github.com/benhamill/changems/tree/master/app/models/release_notes_parser).

## Getting Started With The Project

### 0. Ruby Version

Changems is designed to run on Ruby **1.9.2**. Ideally, it would use rubygems
**1.8.15**, but Heroku is still behind a bit, so some functionality is
duplicated from the newer version inside the app.

### 1. Setup

Bundle the gems

    $ bundle install

Create, migrate and seed the DB.

    $ rake db:setup

### 2. Tests

First, run 'em.

    $ rake spec

The app is designed to import change logs via a background job, so we don't have
creates, updates or deletes. Thus, we just load the seed file before the test
suite, run all the tests and then delete it. Knowing what's in the seed file
will make the tests make more sense, so make sure to give it a glance.

My personal philosophy is that you should have high level tests that cover
everything and only write unit tests to cover tricky stuff in isolation. So, in
general, prefer adding a request spec that examines a change or feature from the
user point of view. If there's some particularly hairy piece of business logic
in a model somewhere, that's a great time to roll out the unit-style tests.

## Help?

Oh please yes!

1. Fork it.
2. Feature branch.
3. Write test.
4. Make test pass.
5. Send pull request.
6. If I'm particularly slow to respond, add a comment **@mentioning** me and
   I'll get an email.

## License

This program is free software. It comes without any warranty, to the extent
permitted by applicable law. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2, as
published by Sam Hocevar. See the LICENSE file or http://sam.zoy.org/wtfpl for
more details.
