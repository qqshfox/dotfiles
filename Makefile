dirs := $(shell find . -maxdepth 1 -type d)
dirs := $(basename $(patsubst ./%,%,$(dirs)))

SUBDIRS := $(dirs)
update_dirs := $(addprefix _update_,$(SUBDIRS))
install_dirs := $(addprefix _install_,$(SUBDIRS))
clean_dirs := $(addprefix _clean_,$(SUBDIRS))

.PHONY: all submodules update $(SUBDIRS) subdirs $(install_dirs) insall $(clean_dirs) clean

all: submodules subdirs

submodules:
	git submodule sync
	git submodule update --init --recursive

$(update_dirs):
	$(MAKE) -C $(patsubst _update_%,%,$@) update

update: submodules $(update_dirs)

$(SUBDIRS):
	$(MAKE) -C $@

subdirs: $(SUBDIRS)

$(install_dirs):
	$(MAKE) -C $(patsubst _install_%,%,$@) install

install: all $(install_dirs)

$(clean_dirs):
	$(MAKE) -C $(patsubst _clean_%,%,$@) clean

clean: $(clean_dirs)
