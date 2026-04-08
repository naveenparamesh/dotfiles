---
name: chef-cookbook-bump
description: >
  Bump a Chef cookbook version in environment files. Specify the cookbook name,
  target version, and environment (staging or production). Only modifies the
  version for the specified cookbook — touches no other lines.
---

# Chef Cookbook Version Bump

## Usage
Provide: cookbook name, version, and environment (staging or production).

## Production

Edit ALL of these files under `environments/`:
- `production.json`
- `storage.json`
- `uat.json`

In each file, find the cookbook entry under `cookbook_versions` and change ONLY
its version constraint to the specified version. Touch NO other lines.

## Staging

Edit ALL of these files under `environments/`:
- `storage-test.json`
- `storage-staging.json`
- `stage2_nyc3_s2r1.json`
- `stage2_nyc3_s2r2.json`
- `stage2_nyc3_s2r3.json`
- `stage2_nyc3_s2r4.json`
- `stage2_nyc3_s2r5.json`
- `stage2_nyc3_s2r6.json`
- `stage2_nyc3_s2r7.json`
- `stage2_nyc3_s2r8.json`

In each file, find the cookbook entry under `cookbook_versions` and change ONLY
its version constraint to the specified version. Touch NO other lines.

## Rules
- ONLY modify the version value for the specified cookbook. Do not touch any other cookbook entry or any other line in the file.
- Do not check metadata.rb. If the user is bumping, the version is ready.
- Do not skip any file in the list. Every file must be updated.
- After editing, show a summary: which files were changed and the old → new version in each.
