const { getStorage, ref, uploadBytes, getDownloadURL } = require("firebase/storage");
const { getAnalytics, isSupported } = require("firebase/analytics");
const { initializeApp } = require("firebase/app");

const firebaseConfig = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGING_SENDER_ID,
  appId: process.env.APP_ID,
  measurementId: process.env.MEASRUREMENT_ID,
};


const initializeFirebase = async () => {
    try {
      const app = initializeApp(firebaseConfig);
      const firebaseStorage = getStorage(app);
      let analytics = null;
      const supported = await isSupported();
  
      if (supported) {
        analytics = getAnalytics(app);
      }
  
      return {
        app,
        analytics,
        firebaseStorage
      };
    } catch (error) {
      console.error("Error initializing Firebase:", error);
      throw error;
    }
  };
  
  module.exports = initializeFirebase;