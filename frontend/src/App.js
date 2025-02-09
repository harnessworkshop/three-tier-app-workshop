import { useState, useEffect } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import travel_01 from "./travel-01.jpeg";
import Navbar from "./components/Navbar";
import './App.css';

function App() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const fillDB = await fetch('/api/init-db', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          credentials: 'include'
        });
        const response = await fetch('/api/data', {
          credentials: 'include'
        });
        if (!response.ok || !fillDB.ok) {
          throw new Error('Network response was not ok');
        }

        const jsonData = await response.json();
        console.log("Data from backend and RDS database:", jsonData);
        setData(jsonData);
        setLoading(false);
      } catch (err) {
        setError(err.message);
        setLoading(false);
      }
    };

    fetchData();
  }, []); // Empty dependency array means this runs once on mount

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  
  let divStyle = {
    // set background color to transparent
    backgroundColor: "transparent"
  }

  return (
    <div style={divStyle}>
      <Navbar/>
      <div className="hero">
        <img src={travel_01} alt="Travel" className="hero__image" />
        <div className="hero__qr">
          <QRCodeSVG value={window.location.href} />
        </div>
        <h1 className="hero__title">Devops made simple.</h1>
      </div>
    </div>
  )
}

export default App;
