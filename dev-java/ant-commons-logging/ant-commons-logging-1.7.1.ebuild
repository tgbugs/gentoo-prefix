# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-commons-logging/ant-commons-logging-1.7.1.ebuild,v 1.3 2008/12/20 19:49:05 ken69267 Exp $

EAPI="prefix 1"

inherit ant-tasks

KEYWORDS="~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=dev-java/commons-logging-1.0.4-r2:0"
RDEPEND="${DEPEND}"
