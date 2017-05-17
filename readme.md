# Common ecommerce analytics

This is a set of templated ecommerce analytics for use in other dbt packages. As long as your data has been modeled in the way this package expects, you can get a series of battle-tested reports for free.

## Installing this package

There are two methods you can use to integrate this package into yours:

1. Point the required tables at tables in your existing project. In order to do this, copy the config from the `dbt_project.yml` of this project and enter the appropriate tables on your side. In order to use this mechanism, your tables must have the same exact structure and field names that the package expects.

1. Re-implement `order_facts.sql` within your project. This is a more flexible option, as it allows you to perform necessary mapping of your data to the structure that this package expects. In order to do this, simply copy `order_facts.sql` into your project and implement it using whatever logic you choose—just ensure that you keep the field names identical. Once you've done this, disable the model within the package using the `dbt_project.yml` within your project.

## Using this package

Once you've installed the package, access the corresponding analytics by running `dbt compile`. Then check the `target` folder and grab the resulting code and use as you choose. If you'd like to configure the code to hit your production schema, you may want to run `dbt compile --target prod`.
