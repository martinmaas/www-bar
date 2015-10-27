# These prefixes sort the various pages into categories
BIN_DIR ?= output
HDR_DIR ?= templates
SRC_DIR ?= pages

NEWS_DIR ?= $(SRC_DIR)/news
JS_DIR ?= $(SRC_DIR)/js
CSS_DIR ?= $(SRC_DIR)/css
IMG_DIR ?= $(SRC_DIR)/images

# These programs are needed to build the website, if you don't have them then
# some will be built automatically, some won't.
BLOGC ?= $(shell which blogc 2> /dev/null)
MENUGEN ?= tools/menugen

# These simple targets won't really ever change
ALL += $(BIN_DIR)/index.html
ALL += $(BIN_DIR)/news.html
ALL += $(BIN_DIR)/projects.html
ALL += $(BIN_DIR)/history.html
ALL += $(BIN_DIR)/publications.html
ALL += $(BIN_DIR)/about.html
ALL += $(BIN_DIR)/menu.js
ALL += $(BIN_DIR)/favicon.ico
ALL += $(patsubst $(CSS_DIR)/%,$(BIN_DIR)/css/%,$(wildcard $(CSS_DIR)/*.css))
ALL += $(patsubst $(JS_DIR)/%,$(BIN_DIR)/js/%,$(wildcard $(JS_DIR)/*.js))
ALL += $(patsubst $(IMG_DIR)/%,$(BIN_DIR)/images/%,$(wildcard $(IMG_DIR)/*.png))
all: $(ALL)

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

# The additional dependencies that are added to some files, which results in
# them showing up inside the generated output file.  Note that there's some
# hackery in here to make sure the ordering is correct everywhere. 
$(BIN_DIR)/index.html: $(lastword $(sort $(wildcard $(NEWS_DIR)/*.md)))

$(BIN_DIR)/news.html: $(shell find $(NEWS_DIR) -iname "*.md" | sort --reverse)

# This rule is used to generate the top-level pages, and must come after all
# the additional dependencies above.
$(BIN_DIR)/%.html: $(SRC_DIR)/%.md $(HDR_DIR)/top-level.html 
	mkdir -p $(dir $@)
	$(BLOGC) -DSHOW=$(patsubst %.html,%,$(notdir $@)) -o $@ -t $(filter %.html,$^) -l $(sort $(filter %.md,$^))

# The menu is a bit special
$(BIN_DIR)/menu.js: $(MENUGEN)
$(BIN_DIR)/menu.js: $(patsubst $(BIN_DIR)/%.html,$(SRC_DIR)/%.md,$(filter %.html,$(ALL)))
	mkdir -p $(dir $@)
	$(MENUGEN) -o $@ $(filter %.md,$^)

# Many files are just directly copied over from the from the source directory.
$(BIN_DIR)/css/%.css: $(CSS_DIR)/%.css
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/js/%.js: $(JS_DIR)/%.js
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/images/%.png: $(IMG_DIR)/%.png
	mkdir -p $(dir $@)
	cp -L $< $@

$(BIN_DIR)/favicon.ico: $(IMG_DIR)/favicon.ico
	mkdir -p $(dir $@)
	cp -L $< $@
