# Crwn Clothing Kartikey

Welcome to Crwn Clothing Kartikey, a modern, full-stack e-commerce application built using React, Redux, Firebase, and Stripe. Browse clothing items by category, add them to your cart, sign in using Email/Password or Google, and complete your purchase securely with Stripe.

## Features

- **Product Browsing:** View products organized into categories (Hats, Jackets, Sneakers, Womens, Mens).
- **Shopping Cart:** Add/remove items, view cart dropdown, checkout page.
- **User Authentication:** Sign up, Sign in with Email/Password, Sign in with Google, Sign out. User sessions are persisted.
- **Secure Payments:** Integrated with Stripe for secure credit card payments.
- **State Management:** Robust state management using Redux, with asynchronous operations handled by Redux Saga.
- **Styling:** Component-based styling with Styled Components.
- **Routing:** Client-side routing handled by React Router v6.
- **Performance:** Route-based code splitting (Lazy Loading) with React Suspense.
- **Progressive Web App (PWA):** Includes service worker for offline capabilities and caching strategies.
- **Deployment:** Easily deployable to Netlify (includes deployment script and Netlify functions setup).

## Tech Stack

- **Frontend:**
  - React (v17) & React DOM
  - TypeScript
  - React Router (v6)
  - Redux & React-Redux
  - Redux Saga (for side effects)
  - Redux Persist (for cart persistence)
  - Reselect (for memoized selectors)
  - Styled Components (CSS-in-JS)
  - Axios (or Fetch API used implicitly via libraries)
- **Backend & Services:**
  - Firebase Authentication (Google & Email/Password)
  - Firebase Firestore (User data, Product categories)
  - Stripe (Payment processing)
  - Netlify Functions (Serverless backend for Stripe integration)
- **Build & Development:**
  - Create React App (react-scripts v5)
  - npm/yarn
  - ESLint
- **Deployment:**
  - Netlify
  - Git & GitHub

## Setup Instructions

Follow these steps to get the project running locally:

1.  **Fork and Clone:**

    - Fork this repository to your own GitHub account using the 'Fork' button.
    - Clone your forked repository:
      ```bash
      git clone https://github.com/<Your-Username>/crwn-clothing-kartikey.git
      cd crwn-clothing-kartikey
      ```

2.  **Install Dependencies:**

    - Install project dependencies using npm or yarn. Note: This project might require `--legacy-peer-deps` due to potential version conflicts noted in `deploy_project.sh`.
      ```bash
      npm install --legacy-peer-deps
      # OR
      # yarn install
      ```

3.  **Firebase Configuration:**

    - Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
    - Enable **Authentication** (Email/Password and Google providers).
    - Enable **Firestore Database**. You might need to seed data (see `src/shop-data.js` for structure, and `src/utils/firebase/firebase.utils.ts` `addCollectionAndDocuments` function for how it might be done).
    - Go to Project Settings > General tab > Your apps > Web app.
    - Find your Firebase **config object**.
    - Replace the placeholder config in `src/utils/firebase/firebase.utils.ts` with your actual Firebase config _or_ (recommended) set up environment variables:
      - Create a `.env` file in the project root.
      - Add your Firebase config keys:
        ```env
        REACT_APP_FIREBASE_API_KEY=your_api_key
        REACT_APP_FIREBASE_AUTH_DOMAIN=your_auth_domain
        REACT_APP_FIREBASE_PROJECT_ID=your_project_id
        REACT_APP_FIREBASE_STORAGE_BUCKET=your_storage_bucket
        REACT_APP_FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
        REACT_APP_FIREBASE_APP_ID=your_app_id
        ```
      - _Ensure `firebase.utils.ts` reads from `process.env` as shown in the file._

4.  **Stripe Configuration:**

    - Sign up for a Stripe account at [https://stripe.com/](https://stripe.com/).
    - Find your API keys in the Stripe Dashboard (Developers > API Keys). You need both **Publishable Key** and **Secret Key**.
    - Add your Stripe keys to the `.env` file:

      ```env
      # Used in src/utils/stripe/stripe.utils.js
      REACT_APP_STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key

      # Used in netlify/functions/create-payment-intent.js (for local Netlify Dev)
      STRIPE_SECRET_KEY=sk_test_your_secret_key
      ```

    - Ensure `process.env.REACT_APP_STRIPE_PUBLISHABLE_KEY` is used in `src/utils/stripe/stripe.utils.js`.
    - Ensure `process.env.STRIPE_SECRET_KEY` is used in `netlify/functions/create-payment-intent.js`.

5.  **Netlify Dev (Optional but Recommended for Testing Payments):**

    - Install the Netlify CLI: `npm install -g netlify-cli`
    - Log in: `netlify login`
    - Link the site (optional, connects to a Netlify site): `netlify link`
    - Run the development server with Netlify Dev (this runs your React app and the serverless function locally):
      ```bash
      netlify dev
      ```
    - This command will typically pick up your `.env` file variables.

6.  **Run the Application Locally:**
    - If not using Netlify Dev, start the React development server:
      ```bash
      npm start
      # OR
      # yarn start
      ```
    - Open your browser to `http://localhost:3000` (or the port specified).

## Usage

- Navigate through the different clothing categories via the homepage or the "SHOP" link in the navigation.
- Click "Add to card" on product cards to add items to your shopping cart.
- Click the cart icon in the navigation to view items in the cart dropdown.
- Click "GO TO CHECKOUT" to proceed to the checkout page.
- Use the "SIGN IN" link to log in or create an account (Email/Password or Google).
- On the checkout page, enter your card details (use Stripe test card numbers) and click "Pay now" to simulate a payment.
