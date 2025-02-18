#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://mandoc.bsd.lv/")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("p")
	version = None

	for link in links:
		text = link.get_text().split("\n")
		for parts in text:
			if "current version" in parts:
				for version in parts.split(" "):
					try:
						list(map(int, version.split(".")))
						break

					except ValueError:
						continue
		if version:
			break

	if version:
		final_name = f"{pkginfo.get('name')}-{version}.tar.gz"
		url = f"https://mandoc.bsd.lv/snapshots/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
