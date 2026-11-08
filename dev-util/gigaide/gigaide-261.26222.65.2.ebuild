# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop readme.gentoo-r1 toolchain-funcs wrapper xdg

DESCRIPTION="Integrated Development Environment for Java and Kotlin (IntelliJ-based)"
HOMEPAGE="https://gigaide.ru/"
SRC_URI="https://gigaide.ru/downloadlast/gigaide-${PV}.tar.gz"

LICENSE="GIGAIDE-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+bundled-jdk"

RDEPEND="
	!bundled-jdk? (
		>=dev-lang/java-21:21
		>=dev-java/filesystem-classes-21:21
	)
	bundled-jdk? (
		app-accessibility/at-spi2-core:2
		dev-libs/expat
		dev-libs/glib:2
		dev-libs/nspr
		dev-libs/nss
		media-libs/alsa-lib
		media-libs/freetype
		media-libs/mesa
		net-print/cups
		sys-apps/dbus
		virtual/zlib:=
		x11-libs/cairo
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXxf86vm
		x11-libs/libdrm
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/pango
	)
"

BDEPEND="
	dev-util/debugedit
	dev-util/patchelf
"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	tc-export OBJCOPY
	default

	# Remove disabled Lombook plugin
	rm -rv "${S}/plugins/lombok" || die

	# Remove debug build-id from ELF binaries for current architecture only
	find . -type f -print0 | while IFS= read -r -d '' file; do
		local file_info
		file_info=$(file "${file}")
		if echo "${file_info}" | grep -qE "ELF (32|64)-bit"; then
			# Skip files for other architectures (e.g., aarch64 .so on amd64)
			if echo "${file_info}" | grep -qi "aarch64\|arm64"; then
				continue
			fi
			if echo "${file_info}" | grep -qi "x86-64\|x86_64\|Intel 80386\|68\|64-bit"; then
				${OBJCOPY} --remove-section .note.gnu.build-id "${file}" || die
				debugedit -b "${EPREFIX}/opt/${PN}" -d "/usr/lib/debug" -i "${file}" || die
			fi
		fi
	done

	if use bundled-jdk; then
		patchelf --set-rpath '$ORIGIN/../lib' "${S}/jbr/bin/"* || die
		patchelf --set-rpath '$ORIGIN' "${S}/jbr/lib/"{libjcef.so,jcef_helper} || die
		patchelf --set-rpath '$ORIGIN:$ORIGIN/server' "${S}/jbr/lib/lib"*.so* || die
	else
		rm -rv "${S}/jbr" || die
	fi

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager." \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" \
		"${S}/bin/idea.properties" || die
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	local DIR="/opt/${PN}"

	insinto "${DIR}"
	doins -r ./*

	fperms 755 "${DIR}"/bin/{format.sh,fsnotifier,idea,idea.sh,inspect.sh,ltedit.sh,restarter}

	if use bundled-jdk; then
		fperms 755 "${DIR}/jbr"/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,jwebserver,keytool,rmiregistry,serialver}
		fperms 755 "${DIR}/jbr/lib/"{cef_server,jcef_helper,jexec,jspawnhelper}
	fi

	dostrip

	make_wrapper "${PN}" "${DIR}/bin/idea.sh"
	newicon "${S}/bin/idea.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}" "${PN}"


	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d
	cat > "${ED}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" <<-EOF || die
		fs.inotify.max_user_watches = 524288
	EOF
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
