#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	url = None
	major_url = f"http://download.calibre-ebook.com/"
	major_data = await hub.pkgtools.fetch.get_page(major_url)
	major_soup = BeautifulSoup(major_data, "html.parser")
	
	ver_ref = major_soup.find("a").get("href")
	ver_data = await hub.pkgtools.fetch.get_page(major_url + ver_ref)
	ver_soup = BeautifulSoup(ver_data, "html.parser")
	version = ver_soup.find("a").get_text()
	
	src_url = major_url + version + "/"
	src_data = await hub.pkgtools.fetch.get_page(src_url)
	src_soup = BeautifulSoup(src_data, "html.parser")
	
	for link in src_soup.find_all("a"):
		href = link.get("href")
		if href is not None and href.endswith("x86_64.txz"):
			url = src_url + href
			break

	if url and version:
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
		)
		ebuild.push()


# vim: ts=4 sw=4 noet
