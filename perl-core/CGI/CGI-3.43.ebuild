# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/CGI/CGI-3.43.ebuild,v 1.1 2009/04/07 04:52:29 tove Exp $

MODULE_AUTHOR=LDS
MY_PN=${PN}.pm
MY_P=${MY_PN}-${PV}
inherit perl-module

DESCRIPTION="Simple Common Gateway Interface Class"

SLOT="0"
KEYWORDS="~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

#DEPEND="dev-lang/perl"
#	dev-perl/FCGI" #236921

S=${WORKDIR}/${MY_P}

SRC_TEST="do"
myconf="INSTALLDIRS=vendor"
