# These prefixes sort the various pages into categories
BIN_DIR ?= output
HDR_DIR ?= templates
SRC_DIR ?= pages
INSTALL_DIR ?= a5.millennium.berkeley.edu:/project/eecs/parlab/www/bar/data

JQUERY_VERSION ?= 1.11.3
SLICK_VERSION ?= 1.5.7
BLOGC_VERSION ?= 0.5
FRONT_NEWS_ENTRIES ?= 5

NEWS_DIR ?= $(SRC_DIR)/news
JS_DIR ?= $(SRC_DIR)/js
CSS_DIR ?= $(SRC_DIR)/css
IMG_DIR ?= $(SRC_DIR)/images
PROJECT_DIR ?= $(SRC_DIR)/projects
PUBS_DIR ?= $(SRC_DIR)/publications
PEOPLE_DIR ?= $(SRC_DIR)/people
KEEP_DIR ?= $(SRC_DIR)/keep

# These programs are needed to build the website, if you don't have them then
# some will be built automatically, some won't.
BLOGC ?= $(shell which blogc 2> /dev/null)
MENUGEN ?= tools/menugen
RSYNC ?= $(shell which rsync 2> /dev/null)
CURL ?= $(shell which curl 2> /dev/null)

ifeq (,$(wildcard $(BLOGC)))
BLOGC = tools/blogc/build/blogc
endif

# The big list of all targets goes in here
ALL += $(BIN_DIR)/index.html
ALL += $(BIN_DIR)/news.html
ALL += $(BIN_DIR)/projects.html
ALL += $(BIN_DIR)/history.html
ALL += $(BIN_DIR)/publications.html
ALL += $(BIN_DIR)/people.html
ALL += $(BIN_DIR)/menu.js
ALL += $(BIN_DIR)/news/menu.js
ALL += $(BIN_DIR)/projects/menu.js
ALL += $(BIN_DIR)/publications/menu.js
ALL += $(BIN_DIR)/people/menu.js
ALL += $(BIN_DIR)/favicon.ico
ALL += $(BIN_DIR)/js/jquery.min.js
ALL += $(BIN_DIR)/js/slick.min.js
ALL += $(BIN_DIR)/css/slick.css
ALL += $(BIN_DIR)/css/slick-theme.css
ALL += $(BIN_DIR)/fonts/slick.woff
ALL += $(BIN_DIR)/fonts/slick.ttf
ALL += $(BIN_DIR)/fonts/slick.svg
ALL += $(patsubst $(NEWS_DIR)/%.md,$(BIN_DIR)/news/%.html,$(wildcard $(NEWS_DIR)/*.md))
ALL += $(patsubst $(PROJECT_DIR)/%.md,$(BIN_DIR)/projects/%.html,$(wildcard $(PROJECT_DIR)/*.md))
ALL += $(patsubst $(PUBS_DIR)/%.md,$(BIN_DIR)/publications/%.html,$(wildcard $(PUBS_DIR)/*.md))
ALL += $(patsubst $(PEOPLE_DIR)/%.md,$(BIN_DIR)/people/%.html,$(wildcard $(PEOPLE_DIR)/*.md))
ALL += $(patsubst $(CSS_DIR)/%,$(BIN_DIR)/css/%,$(wildcard $(CSS_DIR)/*.css))
ALL += $(patsubst $(JS_DIR)/%,$(BIN_DIR)/js/%,$(wildcard $(JS_DIR)/*.js))
ALL += $(patsubst $(IMG_DIR)/%,$(BIN_DIR)/images/%,$(wildcard $(IMG_DIR)/*.png))
ALL += $(patsubst $(IMG_DIR)/%,$(BIN_DIR)/images/%,$(wildcard $(IMG_DIR)/*.jpeg))
ALL += $(patsubst $(IMG_DIR)/%,$(BIN_DIR)/images/%,$(wildcard $(IMG_DIR)/*/*.jpeg))
ALL += $(patsubst $(IMG_DIR)/%,$(BIN_DIR)/images/%,$(wildcard $(IMG_DIR)/*/*.png))
ALL += $(patsubst $(KEEP_DIR)/%,$(BIN_DIR)/keep/%,$(wildcard $(KEEP_DIR)/*))
all: $(ALL)

# These simple targets won't really ever change
.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

.PHONY: install
install: all
	$(RSYNC) -av --delete $(BIN_DIR)/ $(INSTALL_DIR)/

.PHONY: view
view: all
	firefox output/index.html

# The additional dependencies that are added to some files, which results in
# them showing up inside the generated output file.  Note that there's some
# hackery in here to make sure the ordering is correct everywhere. 
NEWS = $(shell find $(NEWS_DIR) -iname "*.md" | sort --reverse)
$(BIN_DIR)/news.html: $(NEWS)
$(BIN_DIR)/index.html: $(wordlist 1,$(FRONT_NEWS_ENTRIES),$(NEWS))

PROJECTS = $(shell find $(PROJECT_DIR) -iname "*.md" | sort)
HISTORY = $(shell find $(PROJECT_DIR) -iname "*.md" | sort)
$(BIN_DIR)/projects.html: $(PROJECTS)
$(BIN_DIR)/history.html: $(HISTORY)

PUBLICATIONS = $(shell find $(PUBS_DIR) -iname "*.md" | sort --reverse)
$(BIN_DIR)/publications.html: $(PUBLICATIONS)

PEOPLE = $(shell find $(PEOPLE_DIR) -iname "*.md" | sort)
$(BIN_DIR)/people.html: $(PEOPLE)

# These rules generate pages inside the various sub-directories, and must come
# before the top-level rule below that is capable of matching them all.
$(BIN_DIR)/news/%.html: $(BLOGC) $(SRC_DIR)/news/%.md $(HDR_DIR)/news.html
	mkdir -p $(dir $@)
	$(BLOGC) -o $@ -t $(filter %.html,$^) $(filter %.md,$^)

$(BIN_DIR)/projects/%.html: $(BLOGC) $(SRC_DIR)/projects/%.md $(HDR_DIR)/projects.html
	mkdir -p $(dir $@)
	$(BLOGC) -o $@ -t $(filter %.html,$^) $(filter %.md,$^)

$(BIN_DIR)/publications/%.html: $(BLOGC) $(SRC_DIR)/publications/%.md $(HDR_DIR)/publications.html
	mkdir -p $(dir $@)
	$(BLOGC) -o $@ -t $(filter %.html,$^) $(filter %.md,$^)

$(BIN_DIR)/people/%.html: $(BLOGC) $(SRC_DIR)/people/%.md $(HDR_DIR)/people.html
	mkdir -p $(dir $@)
	$(BLOGC) -o $@ -t $(filter %.html,$^) $(filter %.md,$^)

# This rule is used to generate the top-level pages, and must come after all
# the additional dependencies above.
$(BIN_DIR)/%.html: $(BLOGC) $(SRC_DIR)/%.md $(HDR_DIR)/top-level.html 
	mkdir -p $(dir $@)
	$(BLOGC) -DSHOW=$(patsubst %.html,%,$(notdir $@)) -o $@ -t $(filter %.html,$^) -l $(filter %.md,$^)

# The menu is a bit special, it's generated by a special command I use
$(BIN_DIR)/menu.js: $(MENUGEN) $(patsubst $(BIN_DIR)/%.html,$(SRC_DIR)/%.md,$(filter %.html,$(ALL)))
	mkdir -p $(dir $@)
	$(MENUGEN) -o $@ -p . $(filter %.md,$^)

$(BIN_DIR)/%/menu.js: $(MENUGEN) $(patsubst $(BIN_DIR)/%.html,$(SRC_DIR)/%.md,$(filter %.html,$(ALL)))
	mkdir -p $(dir $@)
	$(MENUGEN) -o $@ -p .. $(filter %.md,$^)

# Many files are just directly copied over from the from the source directory.
$(BIN_DIR)/css/%.css: $(CSS_DIR)/%.css
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/js/%.js: $(JS_DIR)/%.js
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/images/%: $(IMG_DIR)/%
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/favicon.ico: $(IMG_DIR)/favicon.ico
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/keep/%: $(KEEP_DIR)/%
	mkdir -p $(dir $@)
	cp -L $< $@

# Download javascript from the internet
$(BIN_DIR)/js/jquery.min.js:
	mkdir -p $(dir $@)
	$(CURL) -L http://code.jquery.com/jquery-$(JQUERY_VERSION).min.js > $@

$(BIN_DIR)/js/slick.min.js:
	mkdir -p $(dir $@)
	$(CURL) -L http://cdn.jsdelivr.net/jquery.slick/$(SLICK_VERSION)/slick.min.js > $@

$(BIN_DIR)/css/slick%:
	mkdir -p $(dir $@)
	$(CURL) -L http://cdn.jsdelivr.net/jquery.slick/$(SLICK_VERSION)/$(notdir $@) > $@

$(BIN_DIR)/fonts/slick%:
	mkdir -p $(dir $@)
	$(CURL) -L http://cdn.jsdelivr.net/jquery.slick/$(SLICK_VERSION)/fonts/$(notdir $@) > $@

# Some things need to be linked around so they can be used in all the subdirs
LINK_DIRS += $(BIN_DIR)/news/css
LINK_DIRS += $(BIN_DIR)/news/js
LINK_DIRS += $(BIN_DIR)/news/images
LINK_DIRS += $(BIN_DIR)/projects/css
LINK_DIRS += $(BIN_DIR)/projects/js
LINK_DIRS += $(BIN_DIR)/projects/images
LINK_DIRS += $(BIN_DIR)/publications/css
LINK_DIRS += $(BIN_DIR)/publications/js
LINK_DIRS += $(BIN_DIR)/publications/images
LINK_DIRS += $(BIN_DIR)/people/css
LINK_DIRS += $(BIN_DIR)/people/js
LINK_DIRS += $(BIN_DIR)/people/images
all: $(LINK_DIRS)
$(LINK_DIRS):
	mkdir -p $(dir $@)
	rm -f $@
	ln -s ../$(notdir $@) $@

# Build tools that don't exist on this machine
ifeq ($(shell uname),Darwin)
tools/blogc/build/blogc: tools/blogc/build/blogc.tmp
	$(CC) $< -o $@ -lm

tools/blogc/build/blogc.tmp: tools/blogc/autogen.sh
	mkdir -p $(dir $@)
	find $(dir $<)src -iname "*.c" -type f | xargs $(CC) -shared -fPIC -o $@ -DPACKAGE_STRING=\"blogc-$(BLOGC_VERSION)\"
else
tools/blogc/build/blogc: tools/blogc/build/Makefile
	$(MAKE) -C $(dir $@) $(notdir $@)

tools/blogc/build/Makefile: tools/blogc/configure
	mkdir -p $(dir $@)
	cd $(dir $@); ../configure

tools/blogc/configure: tools/blogc/autogen.sh
	cd $(dir $@) && ./autogen.sh
endif

tools/blogc/autogen.sh: tools/blogc-$(BLOGC_VERSION).tar.gz $(wildcard tools/blogc-*.patch)
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -C $(dir $@) -xzpf $(filter %.tar.gz,$^) --strip-components=1
	#cat $(filter %.patch,$^) | patch -d $(dir $@) -p1 -t
	chmod +x $@
	touch $@

tools/blogc-$(BLOGC_VERSION).tar.gz:
	$(CURL) -L https://github.com/blogc/blogc/archive/v$(BLOGC_VERSION).tar.gz > $@

.PHONY: clean-blogc
clean: clean-blogc
clean-blogc:
	rm -rf tools/blogc-$(BLOGC_VERSION).tar.gz
	rm -rf tools/blogc

# This stuff is fetched from the internet, it should go away.  Blame Eric.
all: $(BIN_DIR)/images/projects/2015-hurricane.jpeg
$(BIN_DIR)/images/projects/2015-hurricane.jpeg:
	mkdir -p $(dir $@)
	$(CURL) -L http://burgerbeast.com/wp-content/uploads/2014/04/ElRey_FritaCubana.jpg > $@
