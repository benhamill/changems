## Rails 3.1.3 (November 20, 2011) ##

*   Perf fix: If we're deleting all records in an association, don't add a IN(..) clause
    to the query. *GH 3672*

    *Jon Leighton*

*   Fix bug with referencing other mysql databases in set_table_name. *GH ##3690*

*   Fix performance bug with mysql databases on a server with lots of other databses. *GH 3678*

    *Christos Zisopoulos and Kenny J*

## Rails 3.1.2 (November 18, 2011) ##

*   Fix bug with PostgreSQLAdapter#indexes. When the search path has multiple schemas, spaces
    were not being stripped from the schema names after the first.

    *Sean Kirby*

*   Preserve SELECT columns on the COUNT for finder_sql when possible. *GH 3503*

    *Justin Mazzi*

*   Reset prepared statement cache when schema changes impact statement results. *GH 3335*

    *Aaron Patterson*

*   Postgres: Do not attempt to deallocate a statement if the connection is no longer active.

    *Ian Leitch*

*   Prevent QueryCache leaking database connections. *GH 3243*

    *Mark J. Titorenko*

## Rails 3.1.1 (October 7, 2011) ##

*   Add deprecation for the preload_associations method. Fixes #3022.

    *Jon Leighton*

*   Don't require a DB connection when loading a model that uses set_primary_key. GH #2807.

    *Jon Leighton*

*   Fix using select() with a habtm association, e.g. Person.friends.select(:name). GH #3030 and
    \#2923.

    *Hendy Tanata*

## Rails 3.1.0 (August 30, 2011) ##

*   Add a proxy_association method to association proxies, which can be called by association
    extensions to access information about the association. This replaces proxy_owner etc with
    proxy_association.owner.

    *Jon Leighton*

*   ActiveRecord::MacroReflection::AssociationReflection#build_record has a new method signature.

    Before: def build_association(*options)
    After:  def build_association(*options, &block)

    Users who are redefining this method to extend functionality should ensure that the block is
    passed through to ActiveRecord::Base#new.

    This change is necessary to fix https://github.com/rails/rails/issues/1842.

    *Jon Leighton*

*   AR#pluralize_table_names can be used to singularize/pluralize table name of an individual model:

        class User < ActiveRecord::Base
          self.pluralize_table_names = false
        end

    Previously this could only be set globally for all models through ActiveRecord::Base.pluralize_table_names. *Guillermo Iguaran*

*   Add block setting of attributes to singular associations:

        class User < ActiveRecord::Base
          has_one :account
        end

        user.build_account{ |a| a.credit_limit => 100.0 }

    The block is called after the instance has been initialized. *Andrew White*
