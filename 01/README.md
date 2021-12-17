# continents_grouping
Exercise 01/03

This script parses professions and job offers csv files and prepares statistic in accordance with 
profession category and continents.

### Usage
Before running this script please ensure that elixir is installed.

```bash
    mix deps.get
    mix aggregate
```

Without any parameters aggregate mix task uses file samples from the priv directory.
Also you can provide another files as:
```bash
    mix aggregate /Users/user_1/technical-test-professions.csv /Users/user_1/technical-test-jobs.csv
```
Professions CSV file format:

*id,name,category_name*

Job offers CSV file format:

*profession_id,contract_type,name,office_latitude,office_longitude*