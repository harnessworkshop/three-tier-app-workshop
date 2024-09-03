import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { SplitFactoryProvider } from '@splitsoftware/splitio-react';
import sdkConfig from './splitio-config';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
      <SplitFactoryProvider config={sdkConfig} updateOnSdkTimedout={true} >
        {({ factory, isReady, isTimedout, lastUpdate }) => {
          // Uncomment the following line if you want to render a different component until the SDK is ready
          // if (!isReady) return (<div>Loading SDK ...</div>);
          return <App />
        }}
      </SplitFactoryProvider>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
