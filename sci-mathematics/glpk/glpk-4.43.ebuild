# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/glpk/glpk-4.43.ebuild,v 1.1 2010/04/12 16:46:00 bicatali Exp $

EAPI=2
inherit flag-o-matic autotools

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-3"
HOMEPAGE="http://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc examples gmp odbc mysql"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND="odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	gmp? ( dev-libs/gmp )
	mysql? ( virtual/mysql )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# Added for prefix, bug 267273
	sed -i "s|export-symbols-regex '^(glp_\\|_glp_lpx_).*'|export-symbols-regex '^(glp_\\|_glp_lpx_\\|_glp_lib_fault_hook\\|_glp_lib_print_hook).*'|g" src/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf="--disable-dl"
	if use mysql || use odbc; then
		myconf="--enable-dl"
	fi

	[[ -z $(type -P odbc-config) ]] && \
		append-cppflags $(pkg-config --cflags libiodbc)

	econf \
		--with-zlib \
		$(use_with gmp) \
		$(use_enable odbc) \
		$(use_enable mysql) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || \
		die "failed to install docs"

	insinto /usr/share/doc/${PF}
	if use examples; then
		emake distclean
		doins -r examples || die "failed to install examples"
	fi
	if use doc; then
		cd "${S}"/doc
		doins *.pdf notes/*.pdf || die "failed to instal djvu and pdf"
		dodoc *.txt || die "failed to install manual files"
	fi
}
