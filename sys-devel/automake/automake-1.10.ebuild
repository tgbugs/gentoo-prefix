# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.10.ebuild,v 1.13 2007/09/08 02:22:10 vapier Exp $

EAPI="prefix"

inherit eutils

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="http://sources.redhat.com/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="${PV:0:4}"
KEYWORDS="~amd64 ~ia64 ~x86 ~ppc-aix ~x86-fbsd ~ia64-hpux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-2
	>=sys-devel/autoconf-2.60
	>=sys-apps/texinfo-4.7
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}
	sys-apps/help2man"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s|: (automake)| v${SLOT}: (automake${SLOT})|" \
		doc/automake.texi || die "sed failed"
	export WANT_AUTOCONF=2.5
}

src_compile() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README THANKS TODO AUTHORS ChangeLog

	# SLOT the docs and junk
	local x
	for x in aclocal automake ; do
		help2man ./${x} > ${x}-${SLOT}.1
		doman ${x}-${SLOT}.1
		rm -f "${ED}"/usr/bin/${x}
	done
	cd "${ED}"/usr/share/info || die
	for x in *.info* ; do
		mv "${x}" "${x/${PN}/${PN}${SLOT}}" || die
	done

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
