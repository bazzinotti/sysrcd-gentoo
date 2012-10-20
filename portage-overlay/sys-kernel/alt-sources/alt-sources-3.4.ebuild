EAPI="2"
ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-3.4.tar.bz2
	mv linux-3.4 linux-${KV}
	ln -s linux-${KV} linux
	cd linux-${KV}

	epatch ${FILESDIR}/alt-sources-3.4-01-stable-3.4.14.patch.bz2 || die "alt-sources stable patch failed."
	epatch ${FILESDIR}/alt-sources-3.4-02-fc16.patch.bz2 || die "alt-sources fedora patch failed."
	epatch ${FILESDIR}/alt-sources-3.4-03-aufs.patch.bz2 || die "alt-sources aufs patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e "${sedlockdep}" include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e "${sednoagp}" drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -alt301/" Makefile
	sed -i -e 's/2.6.$$((40 + $(PATCHLEVEL)))$(EXTRAVERSION)/$(KERNELVERSION)/' Makefile
}

