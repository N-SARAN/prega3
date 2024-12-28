import React from "react";
import Head from "next/head";
import { SessionProvider } from "next-auth/react"; // Import SessionProvider from next-auth
import toast, { Toaster } from "react-hot-toast";
import "../styles/globals.css";
import { UserProvider } from "@auth0/nextjs-auth0/client";
import { StateContextProvider } from "../Context/index";
import { AnonAadhaarProvider } from "@anon-aadhaar/react"; // Import AnonAadhaarProvider

const useTestAadhaar = true; // Change to false for production

export default function App({ Component, pageProps }) {
  return (
    <SessionProvider session={pageProps.session}>
      <UserProvider>
        <AnonAadhaarProvider _useTestAadhaar={useTestAadhaar}>
          <StateContextProvider>
            <Head>
              {/* Add any metadata or external script sources */}
              <script src="vendor/global/global.min.js"></script>
              <script src="vendor/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
              <script src="vendor/chart.js/chart.bundle.min.js"></script>
              <script src="vendor/owl-carousel/owl.carousel.js"></script>
              <script src="vendor/apexchart/apexchart.js"></script>
              <script src="js/custom.min.js"></script>
              <script src="js/deznav-init.js"></script>
              <script src="js/demo.js"></script>
              <script src="js/styleSwitcher.js"></script>
            </Head>
            <Component {...pageProps} />
            <Toaster />
          </StateContextProvider>
        </AnonAadhaarProvider>
      </UserProvider>
    </SessionProvider>
  );
}
