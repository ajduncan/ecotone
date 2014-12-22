# ecotone #

Monitoring api to disparate components written with sinatra and thin.

## Running Locally ##

* Install rvm if you haven't.

    $ \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm

* Install the required version of ruby

    $ rvm 2.1.2
    $ bundle install

* Running

    $ rackup

    You should then be able to access the application at http://localhost:8000/

## Testing ##

    $ RACK_ENV=test bundle exec rake

