import { signIn, signOut, useSession } from "next-auth/react";
import { useRouter } from "next/router"; // Import useRouter to redirect after login

const Login = () => {
  const { data: session } = useSession();
  const router = useRouter(); // Initialize router

  if (session) {
    // Redirect to the home page after login
    router.push("/home"); // This will redirect the user to the home page (index.js)
    return null; // Don't render anything while redirecting
  }

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>Login</h1>
      <p>Click below to sign in:</p>
      <button
        onClick={() => signIn("google")}
        style={{
          padding: "10px 20px",
          marginTop: "20px",
          cursor: "pointer",
        }}
      >
        Sign in with Google
      </button>
    </div>
  );
};

export default Login;
