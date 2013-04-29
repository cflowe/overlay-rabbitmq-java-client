# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 versionator

RESTRICT='mirror'

DESCRIPTION=""
HOMEPAGE="http://www.rabbitmq.com/java-client.html"
SRC_URI="http://www.rabbitmq.com/releases/rabbitmq-java-client/v${PV}/rabbitmq-java-client-${PV}.tar.gz"

LICENSE="MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
    app-arch/tar
    <=dev-lang/python-3
	${COMMON_DEP}"

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="javadoc"

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch "${FILESDIR}"/build.properties.patch
}

src_install() {
	java-pkg_jarinto /usr/lib64
	java-pkg_dojar build/dist/*.jar
	use doc && java-pkg_dojavadoc build/doc
	use source && java-pkg_dosrc src

    local share=${D}/usr/share/${PN}
    mkdir -p $share

    for file in build/dist/*.{bat,sh}; do
		debug-print "installing ${file} to ${share}"

        local dest="${D}/${share}/$(basename $file)"

		if [[ -e "${dest}" ]]; then
			ewarn "Overwriting ${dest}"
		fi

		INSDESTTREE="/usr/share/${PN}" \
			doins "${file}" || die "failed to install ${file}"
    done
}
