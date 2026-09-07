Portfolio Project
📂 Overview:
This project showcases my work as a Flutter Mobile Developer with 6+ years of experience building and maintaining cross-platform iOS and Android applications. It highlights production mobile work across scholarship technology, retail POS, IoT, fitness, enterprise apps, and AI tooling.

🔹 Features:

Responsive Design: Adaptable and visually appealing across different devices.
Project Highlights: Sections dedicated to BoursePad, KeelWorks Foundation, independent Flutter contract work, Coach Asia POS, and AI resume parsing.
Skills Section: Breakdown of technical proficiencies including Flutter, Dart, Clean Architecture, Firebase, Riverpod, BLoC, REST APIs, CI/CD, native Kotlin/Swift modules, BLE, and offline-first storage.
Interactive Elements: Links to portfolio, live apps, project pages, and professional profiles where applicable.
🔹 Tech Stack:

Frontend: Flutter (Dart)
Backend: REST API integrations, Firebase, FastAPI, Elasticsearch
Other Tools: GitHub Actions, Docker, TestFlight, App Store, Google Play, Kotlin, Swift
🔹 Purpose:
To provide a comprehensive overview of my professional growth and project contributions, serving as a resource for potential employers and collaborators.

## GitHub Pages release

This repo is published by GitHub Pages from the `docs/` folder on the `main` branch.

Run the release script after you finish local changes:

```sh
./scripts/deploy-gh-pages.sh
```

If macOS says `Permission denied`, run this once:

```sh
chmod +x scripts/deploy-gh-pages.sh
```

Use a custom commit message if needed:

```sh
./scripts/deploy-gh-pages.sh "Update portfolio"
```

The script will:

```sh
flutter build web --base-href /portfolio/ --no-wasm-dry-run
cp web/flutter_service_worker.js build/web/flutter_service_worker.js
rsync -a --delete build/web/ docs/
git add .
git commit -m "Update portfolio"
git push
```

Flutter no longer needs `--pwa-strategy=none`; newer Flutter Web builds do not generate or manage a service worker by default. The custom `web/flutter_service_worker.js` is kept only to retire older cached Flutter service workers for returning visitors. After `git push`, GitHub Pages may take a minute or two to publish the new `docs/` build.
