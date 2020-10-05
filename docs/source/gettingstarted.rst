.. _gettingstartedref:

Getting Started
===============

To get started with *sqlfluff* you'll need python and pip installed
on your machine, if you're already set up, you can skip straight to
`Installing sqlfluff`_.

Installing Python
-----------------

How to install *python* and *pip* depends on what operating system
you're using. In any case, the python wiki provides up to date
`instructions for all platforms here`_.

There's a chance that you'll be offered the choice between python
versions. Support for python 2 was dropped in early 2020, so you
should always opt for a version number starting with a 3. As for
more specific options beyond that, *sqlfluff* aims to be compatible
with all current python versions, and so it's best to pick the most
recent.

You can confirm that python is working as expected by heading to
your terminal or console of choice and typing :code:`python --version`
which should give you a sensible read out and not an error.

.. code-block:: bash

    $ python --version
    Python 3.6.7

For most people, their installation of python will come with
:code:`pip` (the python pacakge manager) preinstalled. To confirm
this you can type :code:`pip --version` similar to python above.

.. code-block:: bash

    $ pip --version
    pip 10.0.1 from ...

If however, you do have python installed but not :code:`pip`, then
the best instructions for what to do next are `on the python website`_.

.. _`instructions for all platforms here`: https://wiki.python.org/moin/BeginnersGuide/Download
.. _`on the python website`: https://pip.pypa.io/en/stable/installing/

Installing sqlfluff
-------------------

Assuming that python and pip are already installed, then installing
*sqlfluff* is straight forward.

.. code-block:: bash

    $ pip install sqlfluff

You can confirm it's installation by getting *sqlfluff* to show it's
version number.

.. code-block:: bash

    $ sqlfluff version
    0.3.1

Basic Usage
-----------

To get a feel for how to use *sqlfluff* it helps to have a small
:code:`.sql` file which has a simple structure and some known
issues for testing. Create a file called :code:`test.sql` in the
same folder that you're currently in with the following content:

.. code-block:: sql

    SELECT a+b  AS foo,
    c AS bar from my_table

You can then run :code:`sqlfluff lint test.sql` to lint this file.

.. code-block:: bash

    $ sqlfluff lint test.sql
    == [test.sql] FAIL
    L:   1 | P:   9 | L006 | Operators should be preceded by a space.
    L:   1 | P:  10 | L006 | Operators should be followed by a space.
    L:   2 | P:   1 | L003 | Indent expected and not found compared to line #1
    L:   2 | P:  10 | L010 | Inconsistent capitalisation of keywords.
    L:   2 | P:  15 | L009 | Files must end with a trailing newline.

You'll see that *sqlfluff* has failed the linting check for this file.
On each of the following lines you can see each of the problems it has
found, with some information about the location and what kind of
problem there is. The first one has been found on *line 1*, *position 9*
(as shown by :code:`L:   1 | P:   9`) and it's a problem with rule
*L006* (for a full list of rules, see :ref:`ruleref`). From this
(and the following error) we can see that the problem is that there
is no space either side of the :code:`+` symbol in :code:`a+b`.
Head into the file, and correct this issue so that the file now
looks like this:

.. code-block:: sql

    SELECT a + b  AS foo,
    c AS bar from my_table

Rerun the same command as before, and you'll see that the original
problems now no longer show up.

.. code-block:: bash

    $ sqlfluff lint test.sql
    == [test.sql] FAIL
    L:   2 | P:   1 | L003 | Indent expected and not found compared to line #1
    L:   2 | P:  10 | L010 | Inconsistent capitalisation of keywords.
    L:   2 | P:  15 | L009 | Files must end with a trailing newline.

To fix the remaining issues, we're going to use one of the more
advanced features of *sqlfluff*, which is the *fix* command. This
allows more automated fixing of some errors, to save you time in
sorting out your sql files. Not all rules can be fixed in this way
and there may be some situations where a fix may not be able to be
applied because of the context of the query, but in many simple cases
it's a good place to start. Another thing to note is that when fixing,
you must always be specific about which rules you wish to fix. This
is to minimise any unintended consequences from making large scale
changes to your code. In this case we want to try and fix rules
*L003*, *L009* and *L010*.

.. code-block:: bash

    $ sqlfluff fix test.sql --rules L003,L009,L010
    ==== finding violations ====
    == [test.sql] FAIL
    L:   2 | P:   1 | L003 | Indent expected and not found compared to line #1
    L:   2 | P:  10 | L010 | Inconsistent capitalisation of keywords.
    L:   2 | P:  15 | L009 | Files must end with a trailing newline.
    ==== fixing violations ====
    3 linting violations found
    Are you sure you wish to attempt to fix these? [Y/n]

...at this point you'll have to confirm that you want to make the
changes by pressing :code:`y` on your keyboard...

.. code-block:: bash

    Are you sure you wish to attempt to fix these? [Y/n] ...
    Attempting fixes...
    Persisting Changes...
    == [test.sql] PASS
    Done. Please check your files to confirm.

If we now open up :code:`test.sql`, we'll see the content is
now different.

.. code-block:: sql

    SELECT a + b  AS foo,
        c AS bar FROM my_table

In particular:

* The :code:`FROM` keyword has been capitalised to match the
  other keywords.
* The second line has been indented to reflect being inside the
  :code:`SELECT` statement.
* A final newline character has been added at the end of the
  file (which may not be obvious in the snippet above).

Custom Usage
------------

So far we've covered the stock settings of *sqlfluff*, but there
are many different ways that people style their sql, and if you
or your organisation have different conventions, then many of
these behaviours can be configured. For example, given the
example above, what if we actually think that indents should only
be two spaces, and rather than upeercase keywords, they should
all be lowercase?

To achieve this we create a configuration file named :code:`.sqlfluff`
and place it in the same directory as the current file. In that file
put the following content:

.. code-block:: ini

    [sqlfluff:rules]
    tab_space_size = 2

    [sqlfluff:rules:L010]
    capitalisation_policy = lower

Then rerun the same command as before.

.. code-block:: bash

    $ sqlfluff fix test.sql --rules L003,L009,L010

Then examine the file again, and you'll notice that the
file has been fixed accordingly.

.. code-block:: sql

    select a + b  as foo,
      c as bar from my_table

Going further
-------------

From here, there are several more things to explore.

* To understand how *sqlfluff* is interpreting your file
  explore the :code:`parse` command. You can learn more about
  that command and more by running :code:`sqlfluff --help` or
  :code:`sqlfluff parse --help`.
* To start linting more than just one file at a time, experiment
  with passing sqlfluff directories rather than just single files.
  Try running :code:`sqlfluff lint .` (to lint every sql file in the
  current folder) or :code:`sqlfluff lint path/to/my/sqlfiles`.
* To find out more about which rules are available, see :ref:`ruleref`.
* To find out more about configuring *sqlfluff* and what other options
  are available, see :ref:`config`.

One last thing to note is that *sqlfluff* is a relatively new project
and you may find bugs or strange things while using it. If you do find
anything, the most useful thing you can do is to `post the issue on
github`_ where the maintainers of the project can work out what to do with
it. The project is in active development and so updates and fixes may
come out regularly.

.. _`post the issue on github`: https://github.com/sqlfluff/sqlfluff/issues