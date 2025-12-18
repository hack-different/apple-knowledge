# A Proposal For Sane Software Layouts
Every year new technology and project types are created that ever lengthen the `.ignore` files of our repos.  The creators of these files frequently know if the resultant file does or does not belong in source control.  For example any source project typically ignores build outputs quite directly

The proposal here is for a sane common set of files and folders that taxonomies and automate the management of a version control system.

Think of this as a software development version of https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard


## An example (IDEs)…

Today we have multiple IDEs that our engineers use, two I commonly use are VS Code and the IntelliJ product line.  These IDEs store data in the root folders `.vscode` and `.idea` respectively.  The proposed solution is to have both re-locate their default directories as `.ide/vscode` and `.ide/idea` so that if you wish to ignore all IDE files, one can ignore `.ide/` and not have to configure for every single IDE


## A second example (System Files)…

Another common example is the ignoring of files that are OS specific.  Every repository does not need to specify that `.DS_Store` and `desktop.ini` should be ignored (IMHO these operating systems are screwing up by leaving these junk files everywhere when Alternate Data Streams and eXtended Attributes are perfectly adequate).  The OS should be able to indicate “system files” that should be ignored by default.  This may require API changes in underlying operating systems.  For an operating system like linux this may require the ability to register system file patterns may have to be an extension point as the definition of “system file” on linux is very much a matter of the packages installed (GNOME has DBus specific files etc).


## A third example (Caches)…

Creating a common project root of `.cache` as an always ignored root to ensure that a complex specification of paths and extensions is not required.  An example of this is the `.pytest_cache` folder which again can simply be specified as `.cache/pytest` therefore simplifying the directives required


## A fourth example (Logs)…

Any sort of build or runtime log can be placed under `.log` while if an app like rails wishes to expose these a symbolic link at the root from `logs` to `.log/rails` would make it visible to the user.  

