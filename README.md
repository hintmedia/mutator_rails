# MutatorRails

Integrate automated mutation testing into your Rails application

## Overview

The goal of mutation testing is to improve your test coverage by finding elements of code that are not tested. 

This gem supports the process of continually mutation testing a Rails application by logging results for analysis
and hashing source and spec files so that future mutation runs will only run against code that has changed.

## Installation

Add these lines to your application's Gemfile and then run `bundle`:

```ruby
gem 'mutant', github: 'mbj/mutant', ref: '90d103dc323eded68a7e80439def069f18b5e990'
gem 'mutant-rspec', github: 'mbj/mutant', ref: '90d103dc323eded68a7e80439def069f18b5e990'
gem 'mutator_rails'
```

You'll notice that both the `mutant` and `mutant-rspec` gems are locked to a specific commit.
This is because that project has gone through some licensing changes and is not open source beyond this commit.
If you're interested in licensing the proprietary version, please contact [Markus Schirp](https://github.com/mbj) regarding how to obtain a license.


## Usage

- `rails mutator:all` - Run all of the following rake tasks (this is likely the one you want to run)
- `rails mutator:files` - Runs mutant on any files missing or changed since the guide file was last created. Also creates the 
guide file if missing. The guide file contains the test subject's file name, MD5 hashes of the source and spec files, and 
the version of Mutant the file was last tested against.
- `rails mutator:cleanup` - Removes entries from guide file for any test subjects that no longer exist in the codebase.
- `rails mutator:analyze` - Generates an analysis TSV that summaries the mutation results for each subject mutated.
- `rails mutator:statistic` - Generates a summary file containing useful statistics about the mutation run.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hintmedia/mutator_rails.
