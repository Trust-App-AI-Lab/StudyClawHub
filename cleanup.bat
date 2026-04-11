@echo off
cd /d D:\code\StudyClawHub
echo Cleaning up old ClawHub files...
rmdir /s /q convex src packages server e2e scripts clawdhub clawhub public 2>nul
del /q AGENTS.md CHANGELOG.md CONTRIBUTING.md DEPRECATIONS.md VISION.md 2>nul
del /q bun.lock convex.json package.json playwright.config.ts 2>nul
del /q tsconfig.json tsconfig.oxlint.json vercel.json vite.config.ts 2>nul
del /q vitest.config.ts vitest.e2e.config.ts vitest.setup.ts 2>nul
del /q .env.local.example .nvmrc .oxfmtrc.jsonc .oxlintrc.json 2>nul
rmdir /s /q .github\ISSUE_TEMPLATE 2>nul
del /q .github\workflows\ci.yml .github\workflows\clawhub-cli-npm-release.yml 2>nul
del /q .github\workflows\deploy.yml .github\workflows\package-publish.yml 2>nul
del /q .github\workflows\secret-scan.yml 2>nul
cd docs && for %%f in (*) do if not "%%f"=="studyclawhub-skill-format.md" del /q "%%f" 2>nul
rmdir /s /q plans 2>nul
cd ..
del /q cleanup.bat
echo Done! Old ClawHub code removed.
pause
