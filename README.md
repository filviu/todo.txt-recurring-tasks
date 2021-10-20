## Why the Fork

Why this fork: integrate fixes from other users, add support for priorities in 
recuring tasks, enabled adding creation date. Also upstream(s) seemed abandoned.
PERL is really not my language but I will try and maintain this for as long as 
I use it.

---

An add-on for Gina Trapani's [todo.txt](https://github.com/ginatrapani/todo.txt-cli) script,
allowing the automatic addition of recurring tasks to the todo list.

Once installed, the `todo.sh recur` command should be run from a `cron` job (or
other scheduler), once a day.  Any tasks applicable to the current date will be
appended to the todo list (if they're not already present).

The recurring tasks are pulled from a `recur.txt` file, living in the same 
directory as `todo.txt`.  Each line in `recur.txt` has the syntax:

    [week[,week ...] ] day : task
    
or

    daily: task    

Where:

- `every` is an optional keyword: tasks recur after a period since they were 
  previously completed.
- `week` is an optional list of weeks - "first", "second", "third", "fourth", 
  "fifth" or "last".  Weeks are separated by commas __only__ (no spaces).
- `day` is __one__ of "monday", "tuesday", "wednesday", "thursday", "friday", 
  "saturday" or "sunday".  If a task needs to happen on two different days of
  the week, you'll need two lines.
- `task` is anything that might appear in a todo.txt task, including priority,
  contexts or projects.  Do *not* include an added-on date, however.

## Examples:

    sunday: (A) Weekly review of projects list
    monday: Take out the trash @home
    last saturday: Apply the dog's flea medicine
    first,third friday: Collect and file expenses
    daily: run the dishwasher
    every 2 months: clean the oven
Note that the add-on attempts to be smart about things, so if you ran this on a
Sunday when `todo.txt` already contained:

    (B) Weekly review of projects list @home

It would notice the task with the same text (ignoring priority, context, 
project) and add nothing.

## Installation:

Download the latest [recur archive](https://github.com/downloads/paulroub/todo.txt-recurring-tasks/Todotxt-Recur-1.02.tar.gz),
and unpack it in a temporary directory, e.g.

    tar zxf Todotxt-Recur-1.02.tar.gz
    cd Todotxt-Recur-1.02

If you are using the standard `todo.sh` location for add-ons 
(`$HOME/.todo.actions.d`), you'll want to run:

    perl Makefile.PL
    make
    make test
    sudo make install

to install the recur script and its component modules.

There are a few common Perl modules you'll need if you want to run the
`make test` step: `Test::Harness`, `Test::More` and `Test::Class`. These are 
not required for normal script operation.

If your add-ons live elsewhere, you'll need to specify that directory as an
`INSTALLSITESCRIPT` option when generating the Makefile.

    perl Makefile.PL INSTALLSITESCRIPT=/some/other/directory
    make
    make test
    sudo make install

(Installing the modules in a user-specific directory, rather than system-wide, 
calls for setting `LIB=` as appropriate, and is left as an exercise for the reader.)

See the general [Creating and Installing Add-Ons](https://github.com/ginatrapani/todo.txt-cli/wiki/Creating-and-Installing-Add-ons)
documentation to learn where your add-ons live if you're unsure.
