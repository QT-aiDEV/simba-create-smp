# CurseForge Release Flow

Project: `simba-create`

Project ID: `967235`

## API Status

Last checked locally: 2026-07-08.

- `GET /api/game/versions` succeeds.
- Upload endpoint auth was checked with a no-file probe.
- No token returns `401`.
- A fake token returns `403`.
- The real token reaches the upload endpoint and returns `400` only because the probe intentionally sends no file.
- No file was uploaded during the probe.

## Uploaded Files

### 0.15.0 release

- Heavy main file ID: `8524028`
- Lite child file ID: `8524029`
- Server child file ID: `8524030`

### 0.12.1 beta

- Heavy main file ID: `8433083`
- Lite child file ID: `8433084`
- Server child file ID: `8433085`

### 0.11 beta

- Heavy main file ID: `8425275`
- Lite child file ID: `8425278`
- Server child file ID: `8425279`

### 0.10.0 beta

- Heavy main file ID: `8419841`
- Lite child file ID: `8419843`
- Server child file ID: `8419844`

### 0.9.34 beta

- Heavy main file ID: `8397490`
- Lite child file ID: `8397491`
- Server child file ID: `8397492`

Run the reusable probe:

```powershell
$env:CURSEFORGE_TOKEN = "<token from CurseForge>"
.\scripts\Test-CurseForgeApi.ps1
```

## Page Copy

The CurseForge upload API updates files and file changelogs. It does not update the public project description page.

The current public page still shows old Fabric-era text and metadata. Use `docs\CURSEFORGE_PAGE_COPY.md` as the copy source for the CurseForge author dashboard.

## Local Dry Run

```powershell
.\scripts\Publish-SimbaCurseForge.ps1 -Version "0.9.34"
```

## Local Upload

Set the token only in the current shell:

```powershell
$env:CURSEFORGE_TOKEN = "<token from CurseForge>"
.\scripts\Publish-SimbaCurseForge.ps1 -Version "0.9.34" -ReleaseType "beta" -Upload
```

The script uploads Heavy first, then uploads Lite and Server as child files using the Heavy file ID as `parentFileID`.

## Notes

- Do not commit the CurseForge token.
- Default release type is `beta`.
- The script expects exports named like `Simba Create SMP-0.9.34-Heavy-CF-With-Overrides-CurseForge.zip`.
- If CurseForge rejects the Server zip as a child file, upload only Heavy with `-SkipAdditionalFiles`, then we can add the server-pack metadata path separately.
