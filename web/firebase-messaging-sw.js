importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


  const firebaseConfig = {
      apiKey: "AIzaSyAHzVKo65Wgm44zUT0KjC-GLhzKLzDrx10",
              authDomain: "whatsapp-b9990.firebaseapp.com",
              projectId: "whatsapp-b9990",
              storageBucket: "whatsapp-b9990.appspot.com",
              messagingSenderId: "364199676618",
              appId: "1:364199676618:web:bd192a7b03852b4a904233",
              measurementId: "G-E8JVFBPGM3"
    };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();


  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });