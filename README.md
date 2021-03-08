# VaxSpotter

The is an application to help identify open and available Covid-19 vaccine appointments in San Diego county. Hopefully this can become a working template to be used in other locations.

by [Kyle Shannon](https://www.kmshannon.com/).

## License

Apache License 2.0

## Getting started

**ruby '2.7.1'**
**rails '6.1.13'**

To get started, clone the repo and install the needed gems. Migrate the database and run the test suite for verification:

```
$ bundle install --without production
$ rails db:migrate
$ rails test #TODO...
```

Next, run the app in your local server:

```
$ rails s
$ bin/webpack-dev-server #to compile the css/js packs
```

Finally, run the test suite to verify that everything is working correctly:

**TODO**
```
$ rails test
```

Services and deployment instructions:

Logging in requires you to set environment variables for `ADMIN_EMAIL` AND `ADMIN_PASSWORD`
Log into the admin section via `https://www.vaxspotter/info/login` This panel let's you add locations and appointments.

When a `create` Appointment is committed to the database a tweet job is created. The Twitter gem uses environment variables as well. Twitter provides these to you through your Dev account panel. Make sure to set permissions on the key from *read* to *read and write*. 

A `.env_template` file is provided to test admin and twitter functionality in a local build (you can delete test tweets). Make sure to make a copy of that file as a `.env` file and set all environment variables in there. The `.env` file has been added to the `.gitignore`

## Acknowledgements

Inspired by the [TurboVax](https://www.turbovax.info/) project in New York City.

