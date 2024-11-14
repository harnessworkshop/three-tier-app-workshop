import { QRCodeSVG } from 'qrcode.react';
import travel_01 from "./travel-01.jpeg";
import Navbar from "./components/Navbar";
import './App.css';

function App() {
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
