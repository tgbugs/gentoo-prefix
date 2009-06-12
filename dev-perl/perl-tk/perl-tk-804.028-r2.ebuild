# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perl-tk/perl-tk-804.028-r2.ebuild,v 1.9 2009/06/11 17:18:01 armin76 Exp $

MODULE_AUTHOR="SREZIC"
MY_PN=Tk
MY_P=${MY_PN}-${PV}
inherit eutils multilib perl-module

DESCRIPTION="A Perl Module for Tk"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXft
	media-libs/freetype
	media-libs/libpng
	media-libs/jpeg
	dev-lang/perl"

S=${WORKDIR}/${MY_P}

# No test running here, requires an X server, and fails lots anyway.
SRC_TEST="skip"

PATCHES=( "${FILESDIR}"/xorg.patch
	"${FILESDIR}"/${PV}-MouseWheel.patch
	"${FILESDIR}"/${PV}-FBox.patch
	"${FILESDIR}"/${PV}-path.patch
	"${FILESDIR}"/${PN}-CVE-2008-0553.patch
	"${FILESDIR}"/${PN}-804.027-interix-x11.patch )

myconf="X11ROOT=${EPREFIX}/usr XFT=1 -I${EPREFIX}/usr/include/ -l${EPREFIX}/usr/$(get_libdir)"
mydoc="ToDo VERSIONS"
