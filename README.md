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
Organisation, and Vote data), or available over an HTTP API that returns
JSON (e.g. from Morph.io). 

Currently these are required to be 'complete' files (i.e. lists of *all*
votes, or legislators). Fetching individual records one by one over an
API is not yet supported (though patches welcome).

Pull requests for handling other sources and formats are also appreciated. 

Note: Where the documentaion says something like "must contain `voter_id`", a
`voter` record with a nested `id` field should also work.

1. Vote Data (required)

  The actual data that says things like “Joe Smith voted Yes on Motion 134/b/2”

  This can either be in a 'motions' file with embedded votes (all in
  [Popolo Vote format](http://www.popoloproject.com/specs/motion.html)),
  or separate 'motions' and 'votes' files of flat JSON.

  How you get this data is out of scope for here: talk to a local
  [Parliamentary Monitoring Organisation](http://en.wikipedia.org/wiki/Parliamentary_informatics)
  if you're having difficulty (or contact me if you're really stuck).

  Example: [t/data/motions.json](t/data/motions.json) + [t/data/votes.json](t/data/votes.json) 

2. Issues (required)

  These are topic areas that usually involve more than one vote. For
  example, in the UK, there have been at least ten different motions
  related to the issue of making smoking illegal in public — some on
  entire Bills related to the area (e.g. the Smoking (Restaurants) Bill);
  some on related parts of other Acts (e.g. using the Children and
  Families Bill to make it illegal to smoke in a car with a child
  present). 

  You can largely have whatever fields you like here, depending on how
  you're going to display them. The only essential fields are `id` and
  `indicators` (see below)

  Example: [t/data/issues.json](t/data/issues.json)

3. Indicators (required)

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

  Example: [t/data/indicators.json](t/data/indicators.json)

4. Vote Descriptions (optional)

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

  These can either be a human-readable title for the motion, or an 'aye'
  and 'nay' pairing to provide different text depending on which way a
  vote was cast.

  Example: *not yet implemented*

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

  stancer = Stancer.new({
    sources: { ... },
  })

  stancer.all_stances(group_by: 'voter').each { |s| ... }
  ```

The `group_by` option can be any field available on an individual vote
record. This will usually be 'voter' (the parliamentarian / MP) or
'group' (their political grouping/bloc/party). However you could also
add other fields to your data source to group by here (e.g. geographical
region, gender, age-bands, etc).

## Contributing

Contributions are very welcome (against `master`, or as new feature
branches), but for anything significant (especially if you're going to
add anything with a new public-facing component), it's preferred that
you raise an issue first, or submit documentation patches in advance of
code.

