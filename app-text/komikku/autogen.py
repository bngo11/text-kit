#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://codeberg.org/api/v1/repos/valos/Komikku/releases", is_json=True)
	version = None
	url = None

	for item in json_data:
		try:
			if item["prerelease"] or item["draft"]:
				continue

			version = item["tag_name"].strip('v')
			list(map(int, version.split(".")))
			url = item["tarball_url"]
			break

		except (KeyError, IndexError, ValueError):
			continue

	if version and url:
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=f"komikku-{url.rsplit('/', 1)[-1].strip('v')}")]
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
