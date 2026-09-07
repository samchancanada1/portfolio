{{flutter_js}}
{{flutter_build_config}}

async function retireOldFlutterCaches() {
  if ('serviceWorker' in navigator) {
    const registrations = await navigator.serviceWorker.getRegistrations();
    await Promise.all(
      registrations.map((registration) => {
        const worker =
          registration.active || registration.waiting || registration.installing;
        const scriptUrl = worker?.scriptURL || '';
        const isPortfolioWorker =
          registration.scope.includes('/portfolio/') ||
          scriptUrl.includes('flutter_service_worker.js');

        return isPortfolioWorker
          ? registration.unregister()
          : Promise.resolve(false);
      }),
    );
  }

  if ('caches' in window) {
    const keys = await caches.keys();
    await Promise.all(keys.map((key) => caches.delete(key)));
  }
}

retireOldFlutterCaches()
  .catch((error) => {
    console.warn('Unable to clear old Flutter web cache:', error);
  })
  .finally(() => {
    _flutter.loader.load();
  });
