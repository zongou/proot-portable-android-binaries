TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
# Just bump commit and version when needed:
_COMMIT=d4e4a07fbdc16e24868c295d3f7de97eca2a7f80
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=53
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=c1572560806657f20639d6e3de4a156bed3fae49fa8f232aaa370846bf324f72
TERMUX_PKG_DEPENDS="libtalloc-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src"

# Install loader in libexec instead of extracting it every time
# export PROOT_UNBUNDLE_LOADER=$TERMUX_PREFIX/libexec/proot

termux_step_pre_configure() {
	CPPFLAGS+=" -DARG_MAX=131072"
    LDFLAGS+=" -static"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
    # sed -i 's/P_tmpdir/"\/tmp"/g' path/temp.c
    sed -i '26atemp_dir = getenv(\"TMP\");' path/temp.c
    sed -i '27aif (temp_dir == NULL)' path/temp.c

	make V=1
	make install

    $STRIP proot
	cp proot /home/builder/termux-packages
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	install -m600 $TERMUX_PKG_SRCDIR/doc/proot/man.1 $TERMUX_PREFIX/share/man/man1/proot.1
}
