# README

**_MARKR PROGRAM_**
Hi and welcome to your test marking system caled 'Markr'.
This program allows you to import test results and display aggregate test results.

Initial Set Up:

```bash
docker-compose build
docker-compose run web rake db:create db:migrate
```

Docker start up:

```bash
docker-compose up
```

Docker stop:

```bash
docker-compose down
```

1. Use a browser "Rest Client" (Like Postman) to import test results by inserting the curl commands provided below.
   curl -X POST -H \
    -H 'Content-Type: test/xml+markr' \
    http://localhost:3000/import

   The body of the request should be your XML file content

2. Display test results aggregate data in browser

**INDEX Results/Tests**
http://localhost:3000/results/

**SHOW Result Aggregate**
http://localhost:3000/results/1234/aggregate

**ERROR HANDLING**
There is basic error handling integrated into this system.

- Next calls when data received contains errors e.g. duplicate student ids or duplicate test scores for the same student
- Code print out of error message and explanation

**TESTING**
There is a quick models test integrated into the program.

```bash
bundle exec rspec
```

**PROTOTYPE VS. PRODUCTION SYSTEM**
This prototype allows users to import test results in the form of an XML file and receive aggregate data for each test (mean, median, p25, p50, min, max).

In a production system (and given more time) the following changes could be made:

- More sophisticated error handling - error messages and physical print out of document with errors
- Error handling of missing key information e.g. test-id, student-number
- Different levels of testing (unit, integration, system and acceptance)
- Views for Score and Student Models

**APPROACH**
My approach to the problem involved drawing out the key features of the application and sequencing the process into smaller logical steps:

- Import of XML file
- Extraction of key information
- Error handling
- Data manipulation
- Display of aggregate results and stats
- Testing
  I mapped out the sequence and logic first in my mind and on paper before coding to ensure all considerations were accounted for e.g. What attributes the models needed, potential errors, testing requirements.
