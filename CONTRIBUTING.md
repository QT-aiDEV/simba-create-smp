# Contributing to Simba Create SMP

Thanks for helping improve the pack.

## Start with an issue

Use the provided issue forms for bugs and mod suggestions. Search existing issues first, then include enough detail for another person to reproduce or evaluate the request.

Do not post private server addresses, player IPs, access tokens, credentials, full player-data files, or unredacted logs.

## Pack changes

1. Work from the Packwiz source for every affected profile.
2. Use CurseForge metadata whenever a compatible CurseForge file exists.
3. Do not commit downloaded mod jars, release zips, worlds, backups, or server runtime data.
4. Keep Heavy, Lite, and Server aligned unless the change is intentionally profile-specific.
5. Run `.\scripts\Test-SimbaModpack.ps1 -RepoRoot $PWD`.
6. Explain gameplay impact, migration risk, and testing in the pull request.

Known compatibility pins are deliberate. In particular, do not update JEI beyond `19.27.0.338` while the current Petrolpark stack requires that pin.

## Pull requests

Keep each pull request focused. Complete the checklist, link its issue, and include:

- affected profiles;
- exact mod/config versions;
- local validation result;
- client and/or dedicated-server test result;
- world migration or rollback notes when relevant.

Maintainers may ask for a lab-server test before accepting changes. Never operate or modify a production server as part of a community contribution.
