import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import { Amplify } from 'aws-amplify';
import awsmobile from './aws-exports';
 

// Configure Amplify with the AWS Cognito settings
Amplify.configure(awsmobile); // This initializes Amplify with Cognito setup

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);