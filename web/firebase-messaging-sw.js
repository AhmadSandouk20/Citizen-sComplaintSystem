importScripts(
  'https://www.gstatic.com/firebasejs/11.0.0/firebase-app-compat.js',
);
importScripts(
  'https://www.gstatic.com/firebasejs/11.0.0/firebase-messaging-compat.js',
);

firebase.initializeApp({
  apiKey: 'AIzaSyB67uKgbbMKyRhoj-Lk-A4gHoPaY-lpqpg',
  authDomain: 'gov-complaints-project-8f5b7.firebaseapp.com',
  projectId: 'gov-complaints-project-8f5b7',
  storageBucket: 'gov-complaints-project-8f5b7.firebasestorage.app',
  messagingSenderId: '283212099098',
  appId: '1:283212099098:web:0272fa9592563f6f7baba3',
});

const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title || payload.data?.title || 'CCS';
  const body = payload.notification?.body || payload.data?.body || '';
  return self.registration.showNotification(title, {
    body: body,
    data: payload.data || {},
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(clients.openWindow('/notifications'));
});
