# CI reports

GitHub Actions writes diagnostic files here after CI runs.

- `latest.md` contains the most recent combined CI diagnosis.
- `history.md` keeps a short timeline of workflow failures and fixes.
- `logs/` contains trimmed log tails committed by the workflow.

Full logs are also uploaded as GitHub Actions artifacts for each run.
