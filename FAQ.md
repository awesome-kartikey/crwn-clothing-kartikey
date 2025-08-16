# Frequently Asked Questions (FAQ)

This document provides answers to common questions developers or users might have about the Crwn Clothing Kartikey project.

---

**Q1: What is the purpose of this project?**

**A:** This is an e-commerce application built as a learning project (likely based on the "Crwn Clothing" example from Zero To Mastery Academy or similar courses). It demonstrates building a modern web application using React, TypeScript, Redux for state management, Firebase for backend services (Auth, DB), and Stripe for payments.

---

**Q2: Where does the product data come from?**

**A:** The product category and item data are fetched asynchronously when the Shop component mounts. The data is likely stored in **Firebase Firestore** in a collection named `categories`. The `src/utils/firebase/firebase.utils.ts` file contains the `getCategoriesAndDocuments` function used for this. The `src/shop-data.js` file might have been used for initial database seeding or as a fallback during development.

---

**Q3: Why use Redux with Redux Saga?**

**A:**
*   **Redux:** Provides a predictable state container, making it easier to manage application state, especially in larger applications with complex state interactions (like user authentication status, shopping cart contents, and product categories).
*   **Redux Saga:** Is a middleware used to handle side effects (asynchronous operations like API calls) in a more organized and testable way compared to alternatives like Redux Thunk for complex scenarios. In this project, Sagas manage:
    *   User authentication flows (checking sessions, sign-in/up/out with Firebase).
    *   Asynchronously fetching category data from Firestore.

---

**Q4: How is the user's shopping cart persisted across sessions?**

**A:** The shopping cart state (`cartItems`) is persisted using `redux-persist`. As configured in `src/store/store.ts`, the `cart` slice of the Redux state is automatically saved to the browser's `localStorage`. When the application reloads, `redux-persist` rehydrates the Redux store with the saved cart data, allowing users to close their browser and return later without losing their cart contents.

---

**Q5: How are payments processed securely?**

**A:** Payment processing uses Stripe and follows a secure pattern:
1.  **Client-Side (React):** Stripe Elements (`CardElement` from `@stripe/react-stripe-js`) are used in the `PaymentForm` component. These elements securely collect card details directly within Stripe's PCI-compliant iframe, so sensitive card data never touches your server or client-side code directly.
2.  **Serverless Function (Netlify):** When the user submits the payment form, the client-side code calls a Netlify Function (`/.netlify/functions/create-payment-intent`). This function runs on Netlify's servers.
3.  **Backend (Netlify Function -> Stripe):** The Netlify Function securely holds the **Stripe Secret Key**. It receives the payment amount from the client, calls the Stripe API (`stripe.paymentIntents.create`) to create a Payment Intent, and returns the `client_secret` from the Payment Intent back to the client.
4.  **Client-Side Confirmation:** The client uses the received `client_secret` and the `CardElement` details to call `stripe.confirmCardPayment`. This confirms the payment directly with Stripe.

This flow ensures that the sensitive Stripe Secret Key is never exposed to the browser.

---

**Q6: Why was TypeScript chosen for this project?**

**A:** TypeScript adds static typing to JavaScript. This helps catch errors during development rather than at runtime, improves code readability and maintainability, provides better autocompletion and refactoring capabilities in code editors, and makes it easier to collaborate on larger projects.

---

**Q7: How does Google Sign-In work?**

**A:** Google Sign-In is implemented using Firebase Authentication:
1.  The user clicks the "Sign In With Google" button.
2.  A Redux action (`googleSignInStart`) is dispatched.
3.  A Redux Saga (`signInWithGoogle` in `user.saga.ts`) intercepts this action.
4.  The saga calls the `signInWithGooglePopup` utility function from `firebase.utils.ts`, which uses the Firebase SDK to trigger the Google Sign-In popup flow.
5.  After successful authentication with Google, Firebase returns the user authentication object.
6.  The saga then calls `getSnapshotFromUserAuth` to create or retrieve the user's document in Firestore.
7.  Finally, the saga dispatches `signInSuccess` or `signInFailed` actions to update the Redux state.

---

**Q8: How do I set up the required API keys and environment variables?**

**A:** You need API keys/credentials for Firebase and Stripe.
1.  **Local Development:** Create a `.env` file in the project root. Add the following variables (replace placeholders with your actual keys):
    ```env
    # Firebase
    REACT_APP_FIREBASE_API_KEY=your_firebase_api_key
    REACT_APP_FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain
    REACT_APP_FIREBASE_PROJECT_ID=your_firebase_project_id
    REACT_APP_FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
    REACT_APP_FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id
    REACT_APP_FIREBASE_APP_ID=your_firebase_app_id

    # Stripe
    REACT_APP_STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
    STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
    ```
    *Note: `REACT_APP_` prefix is required by Create React App for browser-accessible variables. The `STRIPE_SECRET_KEY` is used by the Netlify function.*

2.  **Netlify Deployment:** Set these environment variables in your Netlify site's settings (Site settings > Build & deploy > Environment > Environment variables). Netlify automatically makes these available to both the build process (for `REACT_APP_` variables) and the Netlify Functions (for all variables, including `STRIPE_SECRET_KEY`).

---

**Q9: What is the `deploy_project.sh` script for?**

**A:** This script automates the process of setting up the project on GitHub and deploying it to Netlify. It performs tasks like:
*   Initializing a Git repository.
*   Creating a repository on GitHub using the `gh` CLI.
*   Installing dependencies (using `--legacy-peer-deps`).
*   Building the React application (`npm run build`).
*   Linking the project to a Netlify site using the `netlify` CLI.
*   Setting placeholder environment variables on Netlify (You'll need to replace these with real values!).
*   Deploying the build output and Netlify Functions to production on Netlify.

It's a convenience script for a specific workflow.

---

**Q10: Can I use this project commercially?**

**A:** This project appears to be based on educational material. You should review the licensing terms of the original course or source material if you intend to use it for commercial purposes. If it's your own adaptation, ensure you have the rights to all assets and dependencies.