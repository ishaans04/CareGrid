// Bundled into assets/generated/firebase-auth.js; never loaded in local PIN mode.
import { initializeApp } from "firebase/app";
import {
  initializeAuth,
  GoogleAuthProvider,
  inMemoryPersistence,
  browserPopupRedirectResolver,
  signInWithPopup,
  signOut,
} from "firebase/auth";

export async function createFirebaseIdentity(config) {
  const auth = initializeAuth(initializeApp(config), {
    persistence: inMemoryPersistence,
    popupRedirectResolver: browserPopupRedirectResolver,
  });
  return {
    async signIn() {
      const provider = new GoogleAuthProvider();
      provider.setCustomParameters({ prompt: "select_account" });
      await signInWithPopup(auth, provider);
    },
    async token() {
      return auth.currentUser ? auth.currentUser.getIdToken() : null;
    },
    async signOut() {
      await signOut(auth);
    },
  };
}
