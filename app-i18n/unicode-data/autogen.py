#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://unicode.org/Public/zipped/")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None
	links.reverse()

	for link in links:
		href = link.get("href")
		if href:
			parts = href.split("/")
			version = parts[0]

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		final_name1 = f'unicode-data-{version}-UCD.zip'
		final_name2 = f'unicode-data-{version}-Unihan.zip'
		url1 = f"https://unicode.org/Public/zipped/{version}/UCD.zip"
		url2 = f"https://unicode.org/Public/zipped/{version}/Unihan.zip"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url1, final_name=final_name1),
						hub.pkgtools.ebuild.Artifact(url=url2, final_name=final_name2)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
