# Stancer

## Your Goal:

To turn the voting records from your legislature into something understandable by non-experts.

## The Outcome:

I’m assuming you want to create pages like these:

* [MP voting summary](http://www.theyworkforyou.com/mp/10777/david_cameron/witney/votes)
* [‘further details’ pages](http://ukvotes.herokuapp.com/issue/PW-6710/tom_watson)

[The latter one is an unstyled testbed page, to show the sort of thing I
mean, rather than an example of what an eventual page will look like.
I’ll hopefully be able to replace that with a live example from
TheyWorkForYou soon]

But this approach should work for anything that involves grouping
together individual votes (which usually make very little to sense to
the casual observer) into higher level topic Issues.

## How This Works

### Get Data

Note that you don’t need to be definitive. You might even only want to
show data on a couple of key issues. Even just adding one topic a month
gets you something very useful very quickly. 

**Data Formats**

At the moment we assume that data will either be in local JSON files
(where appropriate, conforming to the Popolo specifications for Person,
Organisation, and Vote data), or available over an API that produces
JSON (e.g. from Morph.io). 

Pull requests for handling other sources and formats are appreciated. 

When the documetaion says something like "must contain `voter_id`", this
should also be taken to mean that it has a `voter` with a nested `id`
field.

1. Vote Events

  The actual data that says things like “Joe Smith voted Yes on Motion 134/b/2”

  From this it must be possible to derive a `motion_id`, `voter_id`, and
  `option`, and ideally also a `group_id` (possibly in conjunction with #5
  below).

  How you get this data is out of scope for here: talk to a local
  [Parliamentary Monitoring Organisation](http://en.wikipedia.org/wiki/Parliamentary_informatics)
  if you're having difficulty (or contact me if you're really stuck).

2. Issues

  These are topic areas that usually involve more than one vote. For
  example, in the UK, there have been at least ten different motions
  related to the issue of making smoking illegal in public — some on
  entire Bills related to the area (e.g. the Smoking (Restaurants) Bill);
  some on related parts of other Acts (e.g. using the Children and
  Families Bill to make it illegal to smoke in a car with a child
  present). 

  You can largely have whatever fields you like here, depending on how
  you're going to display them. The only essential field is `id`.

3. Indicators

  An Indicator is something that contributes to a Stance (e.g. Joe Smith
  voting Yes on 134/b/2 strongly indicates that he is against Increased
  Government Transparency). For now the only Indicators we deal with are
  how people vote, as politicians often *say* they support something, but
  then consistently vote against it).

  For each Issue you need to provide a list of the related Vote Events,
  how important that vote was to the topic (some votes are more important
  than others), and whether a Yes vote is in support of the Issue, or
  against it. This should be in the format of `vote_option: score` (e.g.
  `{ "yes": 0, "abstain": 3, "no": 10 }` ), but the stancer will also
  allow you to configure an expansion of standard ways of describing these
  (e.g.  mapping “for” to `{ "yes": 3, "no":0 }` and “strongly against” to
  `{ "yes": 0, "no": 10 }`)

  Each Indicator record must therefore include a `motion_id` and
  `weights`, or the Stancer must be configured to generate the `weights`
  from whatever other fields are provided.

  The Indicator records themselves may be sourced separately, but will
  usually be contained within the Issues file.

4. Motion Data (official + unofficial)

  It’s important that you don’t simply make large claims like “Joe Smith
  MP has consistently voted strongly against increased government
  transparency” without providing any way for readers to verify your
  claims. You need to also show how you arrive at that claim, by — at the
  very least — providing a list of all the votes that make up the stance.
  If all you provide is a list of statements like “March 3rd: voted Yes on
  Motion 134/b/2”, with links to the official transcripts, then that’s
  certainly better than nothing, but it’s back in the territory of only
  really being verifiable by experts (or people strongly motivated enough
  to learn enough about how the system works). So Stancer also allows you
  to mix in human readable descriptions of each vote, so that instead you
  can display things like “March 3rd: voted to exempt the Defence Ministry
  from the Access to Information law" 

  Each Motion record must include an `id`, a `date` or `datetime`, and a
  `result`.

  It must also either have a `title` or `text` **or** an `aye` or `nay`
  description (these latter can also be obtained from a different source,
  as long as they share the same `id`)

5. People & Organisations 

  Depending what data is included in your Vote Event data you might need
  to cross-reference person IDs, or look up what political groups people
  were in at the time of a vote (which may not be the same as what one
  they’re in today, etc). 

  Currently this is required to be in Popolo format.

## Installation

Add this line to your application's Gemfile:

    gem 'stancer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stancer

## Usage

  ```ruby

  require 'stancer'

  stancer = Stancer.new(
    sources: { ... },
    options: { ... },
  )

  stancer.all_stances.each { |s| ... }
  ```

## Contributing

Contributions are very welcome (against `master`, or as new feature
branches), but for anything significant (especially if you're going to
add anything with a new public-facing component), it's preferred that
you raise an issue first, or submit documentation patches in advance of
code.

