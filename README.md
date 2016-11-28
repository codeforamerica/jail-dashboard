# Jail Dashboard

The jail dashboard helps jail administrators, judges, and other stakeholders understand the conditions in metro jails, and use this data to visualize how their decisions–at both the individual and policy level–affect program, facility, and inmate outcomes. The Jail Dashboard is intended to help municipalities safely reduce jail populations and prioritize their use of limited jail beds, saving taxpayer dollars and boosting public safety.


###Current Status

This application is currently in development. Please refer to this README as updates are pushed; installation instructions and other technical notes will be added as the application evolves.

## Setting up for development

[Make sure your machine has Docker installed][docker].

[docker]: https://github.com/codeforamerica/howto/blob/master/Docker.md

Run:

```
./bin/docker-compose up
./bin/docker-compose run web rake db:create db:migrate
./bin/docker-compose run web rake db:seed
```
