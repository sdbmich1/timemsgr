
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /opt/bitnami/ruby/include/ruby-1.9.1
hdrdir = /opt/bitnami/ruby/include/ruby-1.9.1
arch_hdrdir = /opt/bitnami/ruby/include/ruby-1.9.1/$(arch)
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/opt/bitnami/ruby
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_BASE_NAME)-$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitedir = $(rubylibprefix)/site_ruby
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(prefix)/etc
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
rubylibdir = $(rubylibprefix)/$(ruby_version)
archdir = $(rubylibdir)/$(arch)
sitelibdir = $(sitedir)/$(ruby_version)
sitearchdir = $(sitelibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendorarchdir = $(vendorlibdir)/$(sitearch)

CC = gcc
CXX = g++
LIBRUBY = $(LIBRUBY_A)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -Wl,-R -Wl,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -Wl,-R -Wl,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)-static
OUTFLAG = -o 
COUTFLAG = -o 

RUBY_EXTCONF_H = 
cflags   =  $(optflags) $(debugflags) $(warnflags)
optflags = -O3
debugflags = -ggdb
warnflags = -Wall -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-long-long
CFLAGS   = -fPIC -I/opt/bitnami/common/include  -g -DXP_UNIX -O3 -Wall -Wcast-qual -Wwrite-strings -Wconversion -Wmissing-noreturn -Winline 
INCFLAGS = -I. -I/usr/include/libxml2 -I/usr/include -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = -D_FILE_OFFSET_BITS=64
CPPFLAGS = -DHAVE_XMLRELAXNGSETPARSERSTRUCTUREDERRORS -DHAVE_XMLRELAXNGSETPARSERSTRUCTUREDERRORS -DHAVE_XMLRELAXNGSETVALIDSTRUCTUREDERRORS -DHAVE_XMLSCHEMASETVALIDSTRUCTUREDERRORS -DHAVE_XMLSCHEMASETPARSERSTRUCTUREDERRORS -I/opt/local/include/ -I/opt/local/include/libxml2 -I/opt/local/include -DAI_ADDRCONFIG=0 -I/opt/bitnami/common/include  $(DEFS) $(cppflags)
CXXFLAGS = $(CFLAGS) $(cxxflags)
ldflags  = -L. -L/opt/bitnami/common/lib -rdynamic -Wl,-export-dynamic
dldflags = 
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
AR = ar
EXEEXT = 

RUBY_BASE_NAME = ruby
RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby
arch = i686-linux
sitearch = $(arch)
ruby_version = 1.9.1
ruby = /opt/bitnami/ruby/bin/ruby
RUBY = $(ruby)
RM = rm -f
RM_RF = $(RUBY) -run -e rm -- -rf
RMDIRS = $(RUBY) -run -e rmdir -- -p
MAKEDIRS = /bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir) /opt/local/lib
LIBPATH =  -L. -L$(libdir) -Wl,-R$(libdir) -L/opt/local/lib -Wl,-R/opt/local/lib
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = /nokogiri
LOCAL_LIBS = 
LIBS =  -lexslt -lxslt -lxml2  -lpthread -lrt -ldl -lcrypt -lm   -lc 
SRCS = nokogiri.c xml_attribute_decl.c xml_element_content.c xml_entity_decl.c xml_attr.c xml_schema.c xml_text.c xml_document_fragment.c xml_processing_instruction.c html_document.c xml_encoding_handler.c xslt_stylesheet.c xml_entity_reference.c xml_xpath.c xml_cdata.c xml_node.c xml_xpath_context.c html_sax_parser_context.c xml_element_decl.c html_element_description.c xml_namespace.c xml_dtd.c xml_syntax_error.c xml_document.c xml_node_set.c xml_reader.c xml_io.c xml_sax_push_parser.c xml_comment.c xml_sax_parser.c xml_sax_parser_context.c xml_relax_ng.c html_entity_lookup.c
OBJS = nokogiri.o xml_attribute_decl.o xml_element_content.o xml_entity_decl.o xml_attr.o xml_schema.o xml_text.o xml_document_fragment.o xml_processing_instruction.o html_document.o xml_encoding_handler.o xslt_stylesheet.o xml_entity_reference.o xml_xpath.o xml_cdata.o xml_node.o xml_xpath_context.o html_sax_parser_context.o xml_element_decl.o html_element_description.o xml_namespace.o xml_dtd.o xml_syntax_error.o xml_document.o xml_node_set.o xml_reader.o xml_io.o xml_sax_push_parser.o xml_comment.o xml_sax_parser.o xml_sax_parser_context.o xml_relax_ng.o html_entity_lookup.o
TARGET = nokogiri
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /home/sbrown/timemsgr/will_paginate/ruby/1.9.1/gems/nokogiri-1.4.1/lib$(target_prefix)
RUBYARCHDIR = /home/sbrown/timemsgr/will_paginate/ruby/1.9.1/gems/nokogiri-1.4.1/lib$(target_prefix)
HDRDIR        = $(rubyhdrdir)/ruby$(target_prefix)
ARCHHDRDIR    = $(rubyhdrdir)/$(arch)/ruby$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so 
CLEANOBJS     = *.o  *.bak

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-rb

clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-rb-default clean-rb
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean-rb-default::
distclean-rb::
distclean-so::
distclean: clean distclean-so distclean-rb-default distclean-rb
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		@-$(RMDIRS) $(DISTCLEANDIRS)

realclean: distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	@-$(MAKEDIRS) $(@D)
	$(INSTALL_PROG) $(DLLIB) $(@D)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
$(RUBYARCHDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .C .o

.cc.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cxx.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cpp.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.C.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.c.o:
	$(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

$(DLLIB): $(OBJS) Makefile
	@-$(RM) $(@)
	$(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): $(hdrdir)/ruby.h $(hdrdir)/ruby/defines.h $(arch_hdrdir)/ruby/config.h
