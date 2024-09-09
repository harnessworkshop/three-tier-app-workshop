import { useEffect } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { useSplitTreatments } from '@splitsoftware/splitio-react';
import travel_01 from "./travel-01.jpeg";
import Navbar from "./components/Navbar";
import './App.css';

function App() {
  const { treatments: { background_color } } = useSplitTreatments({ names: ['background_color'], updateOnSdkUpdate: true });

  let divStyle = {
    backgroundColor: background_color.treatment || "gray"
  }
  let imageSrc = background_color.treatment === "transparent" ? true : false;

  useEffect(() => {
    console.log("update");
    console.log(imageSrc);
  }, [background_color.treatment])

  if(imageSrc) { 
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

  return (
    <div style={divStyle}>
      <Navbar/>
      <div className="hero">
        <div className="hero__qr">
          <QRCodeSVG value={window.location.href} />
        </div>
        <h1 className="hero__title">Devops made simple.</h1>
      </div>
    </div>
  );
}

export default App;
