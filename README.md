BAR Website
------
This repository contains the sources for the BAR website.  To build the
website, just type "make".  This will fetch the relevant code from the internet
and build a copy of the website in "output/".  The website is built using
[blogc](http://blogc.org), which converts a markdown-like language to HTML by
filling out a HTML-like template.

During normal use, you shouldn't need to modify any of the HTML templates, and
should only need to add new .md files (or possibly modify existing .md files)
inside either pages/news/ or pages/projects/.

If you are trying to test your modifications to the website, running "make
view" will show you the generated output.  You shouldn't need to install your
changes to the public site (I will do that if you submit a PR), but if you want
to you can do so (though you won't be able to unless you have UNIX permissions)
by typing "make install".

# Menu generator

The menu at the top of all pages is created by tools/menugen, which is a little
script I wrote.  You shouldn't have to look inside during normal operation, as
it's controlled by the key/value pairs inside the .md files.  There are some
key/value pairs that are specific to the menu generator, and can exist in any
file:

* MENU: Indicates that a top-level menu entry should be shown that links to
  this page, with the link text defined by the given value.  You probably don't
  want to mess with this.

* INMENU/SUBMENU: Indicates that a second-level menu entry should be shown that
  links to this page.  The menu this sub-menu entry is under is defined by the
  value if INMENU, and then text for the sub-mune entry is defined by the value
  of SUBMENU.  You need to define either both of these, or neither of them.

# News Items

News entries are defined by a .md file in pages/news/, so to add a new news
entry you create a new file.  News entries are sorted alphabetically, so you
should follow the convention of prepending the filename with the post date.
Each news .md file generates an entry in the news page (output/news.html), a
stand-alone HTML file in output/news/ (for permanent links).  The 5 newest news
entries are added to the carousel at the start page (output/index.html).  

News entries need to have the following keys defined in order to produce sane
output:

* TITLE: The title of the news entry.  This is shown on the carousel, the news
  list, and the top of the stand-alone news page.

* POSTDATE: The date the news entry was posted.  This is shown on the carousel,
  the news list, and at the top of the stand-alone news page.

* IMAGE: An image (which must be in pages/images/, but should not have images/
  prepended to it) that is relevant to this news entry.  This is ONLY shown in
  the carousel, if you want an image to show up in other places then you have
  to put it inside the CONTENT section of the news entry.

* PERMALINK: The file name of this .md file, needed to make some linking steps
  work.

* (Optionally) BLURB{1,2,3}: These are shown on the carousel on the front page,
  and should be short descriptions of the news entry. 

News entries shouldn't define INMENU/SUBMENU, as it doesn't make sense to have
the "News" menu have sub-menus.  

# Project/History Entries

Both project and history entries are defined by a .md file in pages/projects/,
so to add a new project you create a new file.  Project/history entries are
sorted alphabetically, so you should follow the convention nof prepending the
filename with the year the project started.  Each .md file generates an entry
either the project page or the history page (which one gets generated depends
on the value of "STATUS"), and generates a stand-alone file in output/projects/
(for permanent links).

Project entries need to have the following keys defined in order to produce
sane output:

* PROJECT: The name of the project

* SHOWPROJECTNAME: "false" if the project content contains the project name,
  "true" (or undefinded) if the project should start with the project name.
  This is a workaround for the "jumbotron" stuff, I need to fix it.

* STATUS: Either "projects" (to put in output/projects.html) or "history" (to
  put in output/history.html).

* IMAGE: Some picture that's relevant to your project.

* PERMALINK: The name of the .md file, used for some linking steps.

Additionally, if you want your project to show up as a submenu entry under
either "Projects" or "History", it makes sense to add a INMENU/SUBMENU pair. 

# Publications List

Like everything else, publication entries are alphabetically sorted .md files
(this time in pages/publications).  Each .md file generates an entry in the
publications list, as well as a HTML file cooresponding to that publication.

Publication entries need to have the following keys defined in order to produce
sane output:

* TITLE: The publication title.

* AUTHOR: The author list, comma seperated.

* PUBDATE: The date of publication.

* PERMALINK: The name of the .md file, used for some linking steps.

Additionally, depending on the sort of publication that's being entered, the
following keys should be defined:

* CONFERENCE, LOCATION: The name and location of the conference this appeared
  in.

# People List

Like everything else, people entries are alphabetically sorted .md files (this
time in pages/people).  Each .md file generates an entry in the people list, as
well a HTML file cooresponding to that person.  Entries in the people list need
to have the following keys defined in order to produce sane output:

* NAME: The person's name, as you want it to appear when formatted.  This name
  must match one of the comma-seperated entries in the publication list if you
  want cross-linking to eventually work.

* WEBSITE: This user's personal website, listed for more information.

* PROJECTS: A comma-seperated list of projects this person is involved in.

* IMAGE: A picture of you.

In addition to these items, a short (paragraph or so) description of each
person should be provided.  I just copied the first bit from my personal
website, and linked to that.

# Top-Level Pages

Most of the content of the top-level pages lives in the CONTENT section
(everything below the "------"), and that's probably what you want to edit.

The key/value system for the top-level pages is a bit more complicated, and
shouldn't require modification unless you're trying to change the structure of
the site -- they're a bit flaky, so be careful! 

* TITLE: The title of the page (shown in the title bar, not at the top of the
  site).

* SHOWON: Need to be defined to the name of the .md file.  This is used
  internally to avoid writing a different template for every single top-level
  page.  The value "index" is a bit special here, as the index page looks
  somewhat different than the rest of the pages.

* SPONSORS: If this is defined, the lab sponsors are shown at the right side of
  the page.

Additionally, most top-level pages will have "MENU" defined so the page is
accessible (with the notable exception of "index", which is implicitly linked
to the BAR logo).
