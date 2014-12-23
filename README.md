# ecotone #

Monitoring api of disparate components, written with sinatra, thin, and faye-websocket.

## Running Locally ##

* Install rvm if you haven't.

    $ \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm

* Install the required version of ruby

    $ rvm 2.1.2
    $ bundle install

* Running

    You have to run this in production apparently.  See: https://github.com/ryanb/private_pub/issues/30

    $ RACK_ENV=production rackup

    You should then be able to access the application at http://localhost:8000/

## Testing ##

    $ RACK_ENV=test bundle exec rake

