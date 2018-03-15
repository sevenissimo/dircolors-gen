AWK		 = awk
AWKFLAGS =

dircolors:

%: %.gen
	$(AWK) $(AWKFLAGS) -f filters.awk $< > $@

install: dircolors
	cp -f $< ~/.dircolors

clean:
	-$(RM) dircolors

.PHONY: install clean
