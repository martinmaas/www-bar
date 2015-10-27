# These prefixes sort the various pages into categories
BIN_DIR ?= output
HDR_DIR ?= templates
SRC_DIR ?= pages

NEWS_DIR ?= $(SRC_DIR)/news

# These programs are needed to build the website, if you don't have them then
# some will be built automatically, some won't.
BLOGC ?= $(shell which blogc 2> /dev/null)

# These simple targets won't really ever change
all: $(BIN_DIR)/index.html
all: $(BIN_DIR)/news.html

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

# The additional dependencies that are added to 
$(BIN_DIR)/index.html: $(lastword $(sort $(wildcard $(NEWS_DIR)/*.md)))

$(BIN_DIR)/news.html: $(shell find $(NEWS_DIR) -iname "*.md" | sort --reverse)

# This rule is used to generate the top-level pages, and must come after all
# the additional dependencies above.
$(BIN_DIR)/%.html: $(SRC_DIR)/%.md $(HDR_DIR)/top-level.html
	mkdir -p $(dir $@)
	$(BLOGC) -DSHOW=$(patsubst %.html,%,$(notdir $@)) -o $@ -t $(filter %.html,$^) -l $(filter %.md,$^)

# The main site has the latest news entry on it

