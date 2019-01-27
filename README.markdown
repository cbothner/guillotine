# Guillotine
## WCBN's Close Cutting Fundraiser


Guillotine is how WCBN manages and tracks donations during its annual fundraiser.

### Development

In order to work on Guillotine, you’ll need to install Ruby, and Postgres. If you’re on a Mac, you can follow these instructions directly. Otherwise, hopefully they’re useful as Google fodder.

### Homebrew

The easiest way to install developer tools on macOS is Homebrew. Install it following [the instructions on their website](https://brew.sh/)

The package manager for Windows known as [Chocolately](https://chocolatey.org/) may (or may not) be useful.

### Ruby

We recommend using `rbenv` to install the necessary version of Ruby without conflicting with other things that use ruby.

```sh
brew install rbenv
cd guillotine
rbenv install  # This installs the version specified by the Gemfile
```

### Postgres

PostgreSQL is our database. It is possible to install PostgreSQL using Homebrew, but it can be difficult to configure. We recommend using [Postgres.app](https://postgresapp.com/)


### Guillotine and its dependencies

After checking out the repo, run `bin/setup` to install dependencies.

The database must have a role `guillotine`, and the extension `pg_trgm`.

Start the development server by running `rails s`.  You can also run `bin/rails console` for an interactive prompt that will allow you to experiment.

Navigate to http://localhost:3000

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cbothner/guillotine. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.

## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
