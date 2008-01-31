# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXScrnSaver/libXScrnSaver-1.1.2.ebuild,v 1.11 2007/08/07 13:05:35 gustavoz Exp $

EAPI="prefix"

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org XScrnSaver library"

KEYWORDS="~amd64-linux ~ia64-linux ~mips-linux ~x86-linux ~sparc-solaris"

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	>=x11-proto/scrnsaverproto-1.1"
