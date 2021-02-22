# VaxSpotter

The is an application to help identify open and available Covid-19 vaccine appointments in San Diego county. Hopefully this can become a working template to be used in other locations.

by [Kyle Shannon](https://www.kmshannon.com/).

## License

*raise todo: probably MIT or apache*

## Getting started

**ruby '2.7.1'**
**rails '6.1.13'**

To get started, clone the repo and install the needed gems. Migrate the database and run the test suite for verification:

```
$ bundle install --without production
$ rails db:migrate
$ rails test
```

Next, run the app in your local server:

```
$ rails s
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

Services and deployment instructions:

*raise todo*

## Acknowledgements

Inspired by the [TurboVax](https://www.turbovax.info/) project in New York City.

