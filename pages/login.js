import { signIn, signOut, useSession } from "next-auth/react";
import { useRouter } from "next/router";

const Login = () => {
  const { data: session } = useSession();
  const router = useRouter();

  if (session) {
    router.push("/home");
    return null;
  }

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        height: "100vh",
        backgroundColor: "#e8f5e9",
        fontFamily: "'Poppins', sans-serif",
        color: "#2e7d32",
        position: "relative",
      }}
    >
      {/* Background Icons */}
      <div
        style={{
          position: "absolute",
          top: "10%",
          left: "5%",
          width: "80px",
          height: "80px",
          backgroundImage: "url(/blockchain-icon.png)", // Example icon
          backgroundSize: "contain",
          backgroundRepeat: "no-repeat",
          opacity: 0.2,
        }}
      ></div>
      <div
        style={{
          position: "absolute",
          bottom: "15%",
          right: "10%",
          width: "100px",
          height: "100px",
          backgroundImage: "url(/pregnancy-icon.png)", // Example icon
          backgroundSize: "contain",
          backgroundRepeat: "no-repeat",
          opacity: 0.2,
        }}
      ></div>

      <div
        style={{
          backgroundColor: "#ffffff",
          padding: "40px",
          borderRadius: "15px",
          boxShadow: "0px 4px 20px rgba(46, 125, 50, 0.3)",
          textAlign: "center",
          maxWidth: "400px",
          width: "90%",
        }}
      >
        <img
          src="/logo.png" // Replace with your application logo
          alt="PregAthI Logo"
          style={{ width: "120px", marginBottom: "20px" }}
        />
        <h1
          style={{
            color: "#2e7d32",
            fontSize: "26px",
            marginBottom: "15px",
          }}
        >
          Welcome to pregAthI
        </h1>
        <p style={{ color: "#4caf50", fontSize: "16px", marginBottom: "25px" }}>
          Decentralized pregnancy support platform tailored for you.
        </p>
        <button
          onClick={() => signIn("google")}
          style={{
            backgroundColor: "#4caf50",
            color: "#ffffff",
            padding: "14px 28px",
            border: "none",
            borderRadius: "30px",
            cursor: "pointer",
            fontSize: "16px",
            transition: "transform 0.2s, background-color 0.3s",
          }}
          onMouseOver={(e) => {
            e.target.style.backgroundColor = "#388e3c";
            e.target.style.transform = "scale(1.05)";
          }}
          onMouseOut={(e) => {
            e.target.style.backgroundColor = "#4caf50";
            e.target.style.transform = "scale(1)";
          }}
        >
          Sign in with Google
        </button>
        <div style={{ marginTop: "30px", fontSize: "14px", color: "#81c784" }}>
          <p>
            Unlock personalized support and resources with blockchain security.
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;
