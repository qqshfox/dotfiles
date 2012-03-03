dirs := $(shell find . -maxdepth 1 -type d)
dirs := $(basename $(patsubst ./%,%,$(dirs)))

SUBDIRS := $(dirs)
install_dirs := $(addprefix _install_,$(SUBDIRS))
clean_dirs := $(addprefix _clean_,$(SUBDIRS))

.PHONY: all subdirs $(SUBDIRS) clean

all: submodules subdirs

submodules:
	git submodule update --init --recursive

$(SUBDIRS):
	$(MAKE) -C $@

subdirs: $(SUBDIRS)

$(install_dirs):
	$(MAKE) -C $(patsubst _install_%,%,$@) install

install: all $(install_dirs)

$(clean_dirs):
	$(MAKE) -C $(patsubst _clean_%,%,$@) clean

clean: $(clean_dirs)
