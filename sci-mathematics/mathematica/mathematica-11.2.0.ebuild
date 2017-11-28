# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker versionator xdg-utils

MATHEMATICA_INSTALLER=Mathematica_${PV}_LINUX.sh
MATHEMATICA_VERSION="$(get_version_component_range 1-2)"
MATHEMATICA_INSTALL_DIR=opt/mathematica-${MATHEMATICA_VERSION}
MATHEMATICA_BIN_DIR=usr/bin
MATHEMATICA_DESKTOP_FILE=wolfram-mathematica$(get_major_version).desktop

DESCRIPTION="A mathematical symbolic computation program by Wolfram"
HOMEPAGE="https://www.wolfram.com/mathematica/"
SRC_URI="${MATHEMATICA_INSTALLER}"
RESTRICT="strip"

SLOT="${MATHEMATICA_VERSION}"
LICENSE="Mathematica-EULA"
KEYWORDS="~amd64 ~x86"
IUSE="+doc +bundled-libs"

RDEPEND="
	!bundled-libs? ( 
		app-accessibility/espeak[portaudio]
		dev-libs/glib:2
		dev-libs/gmp:0/10.4
		dev-libs/libffi
		dev-libs/openssl
		>=dev-qt/qtcore-5.6.0
		>=dev-qt/qtdbus-5.6.0
		>=dev-qt/qtgui-5.6.0
		>=dev-qt/qtlocation-5.6.0
		>=dev-qt/qtnetwork-5.6.0
		>=dev-qt/qtprintsupport-5.6.0
		>=dev-qt/qtwidgets-5.6.0
		>=dev-qt/qtxml-5.6.0
		media-libs/freetype:2
		media-libs/harfbuzz
		media-libs/libpng:1.2
		media-libs/mesa[osmesa]
		media-libs/portaudio
		net-libs/libssh2
		sci-libs/lemon
		sys-libs/zlib:0/1
		virtual/glu
		x11-libs/cairo
		x11-libs/pango[X]
		x11-libs/pixman
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	local line_offset=$(grep -m 1 -n -a 'eval \$finish; exit \$res' ${DISTDIR}/${MATHEMATICA_INSTALLER} | grep -Eo --colour=never '^[^:]+')
	local offset=$(head -n ${line_offset} ${DISTDIR}/${MATHEMATICA_INSTALLER} | wc -c)
	unpack_makeself ${DISTDIR}/${MATHEMATICA_INSTALLER} ${offset} dd
}

src_prepare() {
	sed -i -e "s_\[ -f \"\${xdgScripts}/xdg-desktop-menu\" \]_false_" Unix/Installer/MathInstaller || die
	sed -i -e "s_\[ -f \"\${xdgScripts}/xdg-icon-resource\" \]_false_" Unix/Installer/MathInstaller || die
	sed -i -e "s/ = true//" Unix/Installer/MathInstaller || die
	
	eapply_user
}

# based on AUR PKGBUILD for Mathematica
src_install() {
	einfo "Running Mathematica installer (this may take a long time)"
	Unix/Installer/MathInstaller -silent \
	-targetdir=${D%/}/${MATHEMATICA_INSTALL_DIR} \
	-execdir=${D%/}/${MATHEMATICA_BIN_DIR}
	
	# Fixing permissions
	einfo "Fixing permissions (remove global writable)"
	fperms -R go-w /${MATHEMATICA_INSTALL_DIR}
	
	# Copying menu files
	einfo "Copying menu files"
	cd ${D%/}/${MATHEMATICA_INSTALL_DIR}/SystemFiles/Installation/ || die
	sed -i -e "s_${D%/}__" ${MATHEMATICA_DESKTOP_FILE} || die
	echo 'Categories=Science;Math;NumericalAnalysis;DataVisualization;' >> ${MATHEMATICA_DESKTOP_FILE}
	domenu ${MATHEMATICA_DESKTOP_FILE} wolfram-all.directory
	
	# Copying mimetypes
	einfo "Copying mimetypes"
	insinto /usr/share/mime/packages/
	doins *.xml
	
	# Copying icons
	einfo "Copying icons"
	cd ${D%/}/${MATHEMATICA_INSTALL_DIR}/SystemFiles/FrontEnd/SystemResources/X || die
	for i in 32 64 128; do
		newicon -s ${i} -c apps App-${i}.png wolfram-mathematica.png
		for mimetype in $(ls vnd.* | cut -d '-' -f1 | uniq); do
			newicon -s ${i} -c mimetypes ${mimetype}-${i}.png application-${mimetype}.png
		done
	done
	
	# Copying man pages
	einfo "Copying man pages"
	cd ${D%}/${MATHEMATICA_INSTALL_DIR}/SystemFiles/SystemDocumentation/Unix || die
	doman *.1
	
	# Fixing executable symlinks
	einfo "Fixing executable symlinks"
	cd ${D%/} || die
	rm ${MATHEMATICA_BIN_DIR}/* || die
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/math ${MATHEMATICA_BIN_DIR}/math
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/Mathematica ${MATHEMATICA_BIN_DIR}/Mathematica
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/mathematica ${MATHEMATICA_BIN_DIR}/mathematica
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/MathKernel ${MATHEMATICA_BIN_DIR}/MathKernel
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/mcc ${MATHEMATICA_BIN_DIR}/mcc
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/wolfram ${MATHEMATICA_BIN_DIR}/wolfram
	dosym /${MATHEMATICA_INSTALL_DIR}/Executables/WolframKernel ${MATHEMATICA_BIN_DIR}/WolframKernel
	
	# Removing files for different arch
	einfo "Removing binaries for $(usex x86 amd64 x86)"
	local bin_dirs=(
		AddOns/Applications/DocumentationSearch/LibraryResources
		AddOns/Applications/StandardOceanData/LibraryResources
		SystemFiles/Activation
		SystemFiles/Autoload/PacletManager/LibraryResources
		SystemFiles/Components/HTTPHandling/Resources/Binaries
		SystemFiles/Components/MXNetLink/LibraryResources
		SystemFiles/Components/MachineLearning/Resources/Binaries
		SystemFiles/Components/NumericArrayUtilities/LibraryResources
		SystemFiles/Components/PredictiveInterface/Kernel/Predictions.mx
		SystemFiles/Components/PredictiveInterface/Kernel/PredictiveInterfaceCode.mx
		SystemFiles/Components/SemanticImport/Binaries
		SystemFiles/Components/SpellCorrect/LibraryResources
		SystemFiles/Components/TextSearch/Binaries
		SystemFiles/Converters/Binaries
		SystemFiles/FrontEnd/Binaries
		SystemFiles/Graphics/Binaries
		SystemFiles/Java
		SystemFiles/Kernel/Binaries
		SystemFiles/Kernel/SystemResources
		SystemFiles/Libraries
		SystemFiles/Links/AudioFileStreamTools/LibraryResources
		SystemFiles/Links/AudioTools/LibraryResources
		SystemFiles/Links/CURLLink/LibraryResources
		SystemFiles/Links/CalendarTools/LibraryResources
		SystemFiles/Links/CloudObject/LibraryResources
		SystemFiles/Links/DTWTools/LibraryResources
		SystemFiles/Links/FDLLink/LibraryResources
		SystemFiles/Links/GIFTools/LibraryResources
		SystemFiles/Links/GeometryTools/LibraryResources
		SystemFiles/Links/HDF5Tools/LibraryResources
		SystemFiles/Links/IPOPTLink/LibraryResources
		SystemFiles/Links/JLink/Kernel/SystemResources
		SystemFiles/Links/JLink/SystemFiles/Libraries
		SystemFiles/Links/JSONTools/LibraryResources
		SystemFiles/Links/LibraryLink/LibraryResources
		SystemFiles/Links/LightGBMLink/LibraryResources
		SystemFiles/Links/MIDITools/LibraryResources
		SystemFiles/Links/MIMETools/LibraryResources
		SystemFiles/Links/MP3Tools/LibraryResources
		SystemFiles/Links/MQTTLink/LibraryResources
		SystemFiles/Links/MQTTLink/Resources/Binaries
		SystemFiles/Links/MathLink/DeveloperKit
		SystemFiles/Links/MongoLink/LibraryResources
		SystemFiles/Links/OpenCVLink/LibraryResources
		SystemFiles/Links/OpenSURF/LibraryResources
		SystemFiles/Links/ProcessLink/LibraryResources
		SystemFiles/Links/RAWTools/LibraryResources
		SystemFiles/Links/RLink/SystemFiles/Libraries
		SystemFiles/Links/SerialLink/LibraryResources
		SystemFiles/Links/SocketLink/LibraryResources
		SystemFiles/Links/SoundFileTools/LibraryResources
		SystemFiles/Links/SpeechSynthesisTools/LibraryResources
		SystemFiles/Links/StreamLink/LibraryResources
		SystemFiles/Links/SVTools/LibraryResources
		SystemFiles/Links/SystemTools/LibraryResources
		SystemFiles/Links/TesseractTools/LibraryResources
		SystemFiles/Links/TetGenLink/LibraryResources
		SystemFiles/Links/TinkerForgeWeatherStationTools/Binaries
		SystemFiles/Links/TriangleLink/LibraryResources
		SystemFiles/Links/UUID/LibraryResources
		SystemFiles/Links/VernierLink/LibraryResources
		SystemFiles/Links/WSTP/DeveloperKit
		SystemFiles/Links/WebpTools/LibraryResources
		SystemFiles/Links/XMPTools/LibraryResources
		SystemFiles/Links/ZeroMQLink/LibraryResources
	)
	for directory in "${bin_dirs[@]}"; do
		if use x86 ; then
			rm -r "${D%/}/${MATHEMATICA_INSTALL_DIR}/${directory}/Linux-x86-64" || die
		elif use amd64 ; then
			rm -r "${D%/}/${MATHEMATICA_INSTALL_DIR}/${directory}/Linux" || die
		else
			die "Only amd64 and x86 allowed."
		fi
	done
	
	# Removing documentation
	if ! use doc ; then
		einfo "Removing documentation"
		rm -r ${D%/}/${MATHEMATICA_INSTALL_DIR}/Documentation || die
	fi
	
	# Remove qt5 bundled libs (except qt5)
	if ! use bundled-libs ; then
		local bundled_libs=()
	fi
	
	# Replace bundled libs
	if ! use bundled-libs ; then
		cd ${D%/}/${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64) || die
		local bundled_libs=(
			libcairo.so
			libcairo.so.2
			libcrypto.so.1.0.0
			libespeak.so
			libffi.so
			libffi.so.6
			libffi.so.6.0.1
			libfreetype.so
			libfreetype.so.6
			libgio-2.0.so
			libgio-2.0.so.0
			libglib-2.0.so
			libglib-2.0.so.0
			libGLU.so
			libGLU.so.1
			libgmodule-2.0.so
			libgmodule-2.0.so.0
			libgmp.so.10
			libgobject-2.0.so
			libgobject-2.0.so.0
			libgthread-2.0.so
			libgthread-2.0.so.0
			libharfbuzz.so
			libharfbuzz.so.0
			liblemon.so
			libOSMesa32.so
			libOSMesa32.so.8
			libOSMesa32.so.8.0.0
			libpango-1.0.so
			libpango-1.0.so.0
			libpangocairo-1.0.so
			libpangocairo-1.0.so.0
			libpangoft2-1.0.so
			libpangoft2-1.0.so.0
			libpangoxft-1.0.so
			libpangoxft-1.0.so.0
			libpixman-1.so
			libpixman-1.so.0
			libpng12.so.0
			libportaudio.so.2
			libssh2.so.1
			libssl.so.1.0.0
			libz.so.1
		)
		for bl in "${bundled_libs[@]}" ; do
			einfo "Removing ${bl}"
			rm "${bl}" || die
		done
		
		einfo "Removing Qt-Plugins/"
		rm -r Qt-Plugins || die
		einfo "Symlinking Qt-Plugins -> /usr/lib/qt5/plugins"
		dosym /usr/lib/qt5/plugins /${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64)/Qt-Plugins
		
		einfo "Symlinking libOSMesa32.so -> /usr/lib/libOSMesa.so"
		dosym /usr/lib/libOSMesa.so /${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64)/libOSMesa32.so
		einfo "Symlinking libOSMesa32.so.8 -> /usr/lib/libOSMesa.so.8"
		dosym /usr/lib/libOSMesa.so.8 /${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64)/libOSMesa32.so.8
		einfo "Symlinking libOSMesa32.so.8.0.0 -> /usr/lib/libOSMesa.so.8.0.0"
		dosym /usr/lib/libOSMesa.so.8.0.0 /${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64)/libOSMesa32.so.8.0.0
		
		local qt_libs=(
			Core
			DBus
			Gui
			Network
			PrintSupport
			Widgets
			XcbQpa
			Xml
		)
		for qtl in "${qt_libs[@]}" ; do
			rm libQt5${qtl}WRI.so.5 || die
			einfo "Symlinking libQt5${qtl}WRI.so.5 -> /usr/lib/libQt5${qtl}.so.5"
			dosym /usr/lib/libQt5${qtl}.so.5 /${MATHEMATICA_INSTALL_DIR}/SystemFiles/Libraries/$(usex x86 Linux Linux-x86-64)/libQt5${qtl}WRI.so.5
		done
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
