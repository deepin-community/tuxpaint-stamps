# Makefile for tuxpaint-stamps

# Tux Paint - A simple drawing program for children.
# This is a collection of 'rubber stamp' images for Tux Paint.

# Copyright 2002-2018 by various contributors; see CONTRIBUTORS.txt
# http://www.tuxpaint.org/

# September 6, 2002 - August 28, 2018


VER_DATE=`date +"%Y.%m.%d"`


# Where to install things:

PREFIX=/usr/local


# Data:

DATA_PREFIX=$(PREFIX)/share/tuxpaint/


# "make" with no arguments provides info on installing tuxpaint stamps:

all:
	@echo
	@echo "To install these Tux Paint stamps, run the following command(s),"
	@echo "depending on which sets of stamps you'd like to install"
	@echo "(probably as 'root' superuser):"
	@echo
	@echo "  make install-animals    (Birds, fish, dinosaurs, etc.)"
	@echo "  make install-clothes    (Hats, etc.)"
	@echo "  make install-food       (Fruit, vegetables, dessert, etc.)"
	@echo "  make install-hobbies    (Camera, binoculars, etc.)"
	@echo "  make install-household  (Toilet, dishes, garbage can, etc.)"
	@echo "  make install-medical    (Syringe, stethescope, etc.)"
	@echo "  make install-military   (Tanks, etc.)"
	@echo "  make install-naturalforces  (Fire, lightning, etc.)"
	@echo "  make install-people     (Fireman, etc.)"
	@echo "  make install-plants     (Flowers, trees, etc.)"
	@echo "  make install-seasonal   (Christmas, Easter, Hanukkah, etc.)"
	@echo "  make install-space      (Planets, space vehicles, etc.)"
	@echo "  make install-sports     (Balls, tropheys, etc.)"
	@echo "  make install-symbols    (Digits, music, money, shapes, etc.)"
	@echo "  make install-town       (Houses, flags, roadsigns, etc.)"
	@echo "  make install-vehicles   (Cars, construction, air, boats, etc.)"
	@echo
	@echo "Or run 'make install-all' to install all of the above."
	@echo 
	@echo "The stamps will be placed in:"
	@echo "  $(DATA_PREFIX)stamps"
	@echo
	@echo "(Run each 'make install' with 'DATA_PREFIX=path' to override.)"
	@echo
	@if [ -x "`which tuxpaint`" ]; then echo ""; else \
	echo "(Tux Paint doesn't appear to be installed, though!!!)"; \
	echo; fi

install:	all
	@echo
	@echo "NOTE: 'make install' is now deprecated."
	@echo


clean:
	@echo
	@echo "There's no source here, so 'make clean' doesn't make sense!"
	@echo



releaseclean:
	@echo
	@echo "Cleaning release directory"
	@echo
	@rm -rf "build/tuxpaint-stamps-$(VER_DATE)" "build/tuxpaint-stamps-$(VER_DATE).tar.gz"
	@-if [ -d build ] ; then rmdir build ; fi

releasedir: build/tuxpaint-stamps

build/tuxpaint-stamps:
	@echo
	@echo "Creating release directory"
	@echo
	@mkdir -p build/tuxpaint-stamps-$(VER_DATE)
	@find . -follow \
		\( -wholename '*/.git' -o -name .gitignore -o -name .cvsignore -o -name 'build' -o -name '.#*' \) \
		-prune -o -type f -exec cp --parents -vdp \{\} build/tuxpaint-stamps-$(VER_DATE)/ \;
	@sed s/__VER_DATE__/$(VER_DATE)/ < tuxpaint-stamps.spec.in > build/tuxpaint-stamps-$(VER_DATE)/tuxpaint-stamps.spec
	@rm -f build/tuxpaint-stamps-$(VER_DATE)/tuxpaint-stamps.spec.in

release: releasedir
	@echo
	@echo "Creating release tarball"
	@echo
	@cd build ; \
		tar -czvf tuxpaint-stamps-$(VER_DATE).tar.gz tuxpaint-stamps-$(VER_DATE)



# "make uninstall" should remove the various parts from their
# installation locations.  BE SURE the *PREFIX variables at the top
# are the same as they were when you installed, of course!!!

uninstall:
	@echo
	@echo "Removing Tux Paint stamps from $(DATA_PREFIX)"
	@echo
	-@/bin/rm -r $(DATA_PREFIX)stamps


# Install the stamps:

install-all:
	@./install-stamps.sh animals $(DATA_PREFIX)
	@./install-stamps.sh clothes $(DATA_PREFIX)
	@./install-stamps.sh food $(DATA_PREFIX)
	@./install-stamps.sh hobbies $(DATA_PREFIX)
	@./install-stamps.sh household $(DATA_PREFIX)
	@./install-stamps.sh medical $(DATA_PREFIX)
	@./install-stamps.sh military $(DATA_PREFIX)
	@./install-stamps.sh naturalforces $(DATA_PREFIX)
	@./install-stamps.sh people $(DATA_PREFIX)
	@./install-stamps.sh plants $(DATA_PREFIX)
	@./install-stamps.sh seasonal $(DATA_PREFIX)
	@./install-stamps.sh space $(DATA_PREFIX)
	@./install-stamps.sh town $(DATA_PREFIX)
	@./install-stamps.sh sports $(DATA_PREFIX)
	@./install-stamps.sh symbols $(DATA_PREFIX)
	@./install-stamps.sh vehicles $(DATA_PREFIX)
	@echo
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-animals:
	@./install-stamps.sh animals $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-clothes:
	@./install-stamps.sh clothes $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-food:
	@./install-stamps.sh food $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-household:
	@./install-stamps.sh household $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-hobbies:
	@./install-stamps.sh hobbies $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-medical:
	@./install-stamps.sh medical $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-military:
	@./install-stamps.sh military $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-naturalforces:
	@./install-stamps.sh naturalforces $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-people:
	@./install-stamps.sh people $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-plants:
	@./install-stamps.sh plants $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-seasonal:
	@./install-stamps.sh seasonal $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-space:
	@./install-stamps.sh space $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-sports:
	@./install-stamps.sh sports $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-symbols:
	@./install-stamps.sh symbols $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-town:
	@./install-stamps.sh town $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

install-vehicles:
	@./install-stamps.sh vehicles $(DATA_PREFIX)
	@./fix-permissions.sh $(DATA_PREFIX)
	@./post-install-message.sh

dmg:
	@echo "Make sure you move 'Tux Paint Stamps Installer.app' to '$(PWD)' first"
	@macosx/DMG/build-dmg.sh

