# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/povray/povray-3.7.0_beta32.ebuild,v 1.1 2009/06/14 17:56:40 lavajoe Exp $

inherit eutils autotools flag-o-matic versionator

POVRAY_MAJOR_VER=$(get_version_component_range 1-3)
POVRAY_MINOR_VER=$(get_version_component_range 4)
if [ -n "$POVRAY_MINOR_VER" ]; then
	POVRAY_MINOR_VER=${POVRAY_MINOR_VER/beta/beta.}
	MY_PV="${POVRAY_MAJOR_VER}.${POVRAY_MINOR_VER}"
else
	MY_PV=${POVRAY_MAJOR_VER}
fi

DESCRIPTION="The Persistence of Vision Raytracer"
HOMEPAGE="http://www.povray.org/"
SRC_URI="http://www.povray.org/beta/source/${PN}-${MY_PV}.tar.bz2"

LICENSE="povlegal-3.6"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="svga tiff X"

DEPEND="media-libs/libpng
	tiff? ( >=media-libs/tiff-3.6.1 )
	media-libs/jpeg
	sys-libs/zlib
	X? ( x11-libs/libXaw )
	svga? ( media-libs/svgalib )
	>=dev-libs/boost-1.36"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Print info on how to extend the expiration date of the beta
	# if it has expired.
	epatch "${FILESDIR}"/${P}-print-extend-expiration-info.patch
	#epatch "${FILESDIR}"/${P}-fix-expiration-bug.patch

	# Change some destination directories that cannot be adjusted via configure
	cp configure.ac configure.ac.orig
	sed -i -e 's:${povsysconfdir}/$PACKAGE/$VERSION_BASE:${povsysconfdir}/'${PN}':g' configure.ac
	sed -i -e 's:${povdatadir}/$PACKAGE-$VERSION_BASE:${povdatadir}/'${PN}':g' configure.ac
	sed -i -e 's:${povdatadir}/doc/$PACKAGE-$VERSION_BASE:${povdatadir}/doc/'${PF}':g' configure.ac

	cp Makefile.am Makefile.am.orig
	sed -i -e "s:^povlibdir = .*:povlibdir = @datadir@/${PN}:" Makefile.am
	sed -i -e "s:^povdocdir = .*:povdocdir = @datadir@/doc/${PF}:" Makefile.am
	sed -i -e "s:^povconfdir = .*:povconfdir = @sysconfdir@/${PN}:" Makefile.am

	# The "+p" option on the test command line causes a pause and
	# prompts the user to interact, so remove it.
	sed -i -e"s:biscuit.pov -f +d +p:biscuit.pov -f +d:" Makefile.am

	eautoreconf
}

src_compile() {
	# Fixes bug 71255
	if [[ $(get-flag march) == k6-2 ]]; then
		filter-flags -fomit-frame-pointer
	fi

	# The config files are installed correctly (e.g. povray.conf),
	# but the code compiles using incorrect [default] paths
	# (based on /usr/local...), so povray will not find the system
	# config files without the following fix:
	append-flags -DPOVLIBDIR=\\\"${EROOT}usr/share/${PN}\\\"
	append-flags -DPOVCONFDIR=\\\"${EROOT}etc/${PN}\\\"

	econf \
		COMPILED_BY="Portage (Gentoo `uname`) on `hostname -f`" \
		$(use_with svga) \
		$(use_with tiff libtiff) \
		$(use_with X x) \
		--disable-strip \
		|| die

	emake || die
}

src_test() {
	# For the beta releases, we generate a license extension in case needed
	POVRAY_BETA=`./unix/povray --betacode 2>&1` emake check || die "Test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_preinst() {
	# Copy the old config files if they are in the old location
	# but do not yet exist in the new location.
	# This way, they can be treated by CONFIG_PROTECT as normal.
	for conf_file in $(ls "${ED}/etc/${PN}"); do
		if [ ! -e "${EROOT}etc/${PN}/${conf_file}" ]; then
			for version_dir in $(ls "${EROOT}etc/${PN}" | grep "^[0-9]" | sort -rn); do
				if [ -e "${EROOT}etc/${PN}/${version_dir}/${conf_file}" ]; then
					mv "${EROOT}etc/${PN}/${version_dir}/${conf_file}" "${EROOT}etc/${PN}"
					elog "Note: ${conf_file} moved from ${EROOT}etc/povray/${version_dir}/ to ${EROOT}etc/povray/"
					break
				fi
			done
		fi
	done
}

pkg_postinst() {
	ewarn "POV-Ray betas have expiration dates, but these can be extended for up to"
	ewarn "a year.  If expired, you will get the following error when running povray:"
	ewarn
	ewarn "    povray: this pre-release version of POV-Ray for Unix has expired"
	ewarn
	ewarn "To extend the license period (a week at a time), you can do"
	ewarn "something like the following (adjust syntax for your shell):"
	ewarn
	ewarn "    export POVRAY_BETA=\`povray --betacode 2>&1\`"
	ewarn
	ewarn "You will need to repeat this each time it expires."
}
