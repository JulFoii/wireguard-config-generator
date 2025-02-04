import express from "express";
import path from "path";
// import clientRouter from "./routes/client";
// import serverRouter from "./routes/server";

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Statisch die gebaute React-App ausliefern:
app.use(express.static(path.join(__dirname, "../../..", "frontend", "build")));

// Test-Route
app.get("/api/hello", (req, res) => {
  res.json({ message: "Hello from the backend!" });
});

// Beispiel für Client/Server Routen
// app.use("/api/client", clientRouter);
// app.use("/api/server", serverRouter);

// Alle anderen Routen: React-Frontend
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "../../..", "frontend", "build", "index.html"));
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`WireGuard Backend running on port ${port}`);
});
