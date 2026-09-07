// Retires older Flutter service workers so GitHub Pages deploys show fresh builds.
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      if ('caches' in self) {
        const keys = await caches.keys();
        await Promise.all(keys.map((key) => caches.delete(key)));
      }

      await self.registration.unregister();

      const clients = await self.clients.matchAll({
        type: 'window',
        includeUncontrolled: true,
      });

      await Promise.all(
        clients.map((client) => {
          if ('navigate' in client) {
            return client.navigate(client.url);
          }
          return client.focus();
        }),
      );
    })(),
  );
});
