# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/anthy/anthy-9100h.ebuild,v 1.4 2009/07/01 14:15:59 armin76 Exp $

inherit elisp-common eutils

IUSE="emacs"

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/37536/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"

DEPEND="!app-i18n/anthy-ss
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

src_unpack() {

	unpack ${A}
	cd "${S}"

	local cannadicdir=${EPREFIX}/var/lib/canna/dic/canna

	if has_version 'app-dicts/canna-2ch'; then
		einfo "Adding nichan.ctd to anthy.dic."
		sed -i \
			-e "/set_input_encoding eucjp/aread /var/lib/canna/dic/canna/nichan.ctd" \
			mkworddic/dict.args.in || die
	fi

}

src_compile() {

	local myconf

	use emacs || myconf="EMACS=no"

	econf ${myconf} || die
	emake || die

}

src_install() {

	emake DESTDIR="${D}" install || die

	use emacs && elisp-site-file-install "${FILESDIR}"/50anthy-gentoo.el

	dodoc AUTHORS DIARY NEWS README ChangeLog

	docinto doc
	rm doc/Makefile*
	dodoc doc/*

}

pkg_postinst() {

	use emacs && elisp-site-regen

}

pkg_postrm() {

	use emacs && elisp-site-regen

}
